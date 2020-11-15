---
layout: narrative
title: "
 How to Copy between Encrypted S3 Buckets Cross Account
"
author: Evan Kozliner
---

Including a step-by-step tutorial

![An outline of all the resources involved when copying between encrypted buckets, cross account. Created with [Draw.io](https://desk.draw.io/support/solutions/articles/16000042494-usage-terms-for-diagrams-created-in-diagrams-net)](https://cdn-images-1.medium.com/max/2000/1*rZNRjfrC3L8vLyKhpKHV3w.png)*An outline of all the resources involved when copying between encrypted buckets, cross account. Created with [Draw.io](https://desk.draw.io/support/solutions/articles/16000042494-usage-terms-for-diagrams-created-in-diagrams-net)*

Encryption is tricky, even when you’re using managed services, like AWS.

In [my last post](https://towardsdatascience.com/aws-iam-introduction-20c1f017c43), I went over what you need to know about IAM, the identity and access management service offered by AWS. In this post, I want to be a little more concrete, by covering a common scenario where a large number of different permissions are at play. Here, you’ll see all the different types of resources I talked about previously in action, and hopefully everything will click.
> Read my [Introduction to IAM post](https://towardsdatascience.com/aws-iam-introduction-20c1f017c43) if you need a rundown on the basics of how permissions work within AWS.

## Overview

Suppose we’re using several AWS accounts, and we want to copy data in some S3 bucket from a *source *account to some *destination *account, as you see in the diagram above. Further, let’s imagine our data must be encrypted at rest, for something like regulatory purposes; this means that our buckets in *both* accounts must also be encrypted.

There are plenty of ways to accomplish the above goal on AWS, but I’ll be talking about the below combination:

* KMS for the encryption/decryption of your master keys. One alternative to this is to implement client-side encryption and manage the master keys yourself.

* [S3 server-side encryption with customer-managed keys](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingKMSEncryption.html) is OK for your use case. Customer-managed keys offers several benefits over S3 managed keys, like audit-trails.

* [S3 default encryption](https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-encryption.html) is fine for your bucket objects; this means that objects added to your bucket will be automatically encrypted without you needing to specify a flag to have them encrypted.

* A role as the identity doing the copying, as opposed to a user.

## Policies

There are 5 major resources at play here: our two master keys that will handle bucket encryption, our 2 S3 buckets, and our role. This means there are 4 resource policies you will need to get right for this to work (excluding the trust policy on the role) and 1 identity policy.

**Note: **You can’t just copy/paste everything below. For each policy, you will have to change the resource ARNs and account id’s to the ones belonging to your source/destination.

### Role Identity Policy

This is the identity policy we will attach to our S3Porter role in order to have it contact S3 and KMS. There are 4 statements necessary in here: one for each resource in the diagram at the top.

1. Copying from the cross-account source bucket. Cross-account access requires that *both *the sender’s identity policy *and *the receiver’s resource policy allow access. In this case, we’re enabling the sender to make the request.

1. Copying to our bucket in the same AWS account. Notice how the below policy restricts the resource to a single S3 bucket: as a best practice, it’s important to scope your policies to only the resource they absolutely need.

1. Using a cross-account KMS key to decrypt objects from our source bucket.

1. Encrypting into our destination account’s bucket. It might seem funny that we still need kms:Decrypt permissions on our destination bucket, as we’re only copying data to it. We need kms:Decrypt because,[ behind the scenes, S3 may break your files into chunks and reassemble them](https://aws.amazon.com/premiumsupport/knowledge-center/s3-multipart-kms-decrypt/#:~:text=Because%20the%20parts%20are%20encrypted,Amazon%20S3%20with%20SSE%2DKMS.) in order to copy them to a bucket. The re-assembly process may require your role has decryption permissions, as chunks of the files will be encrypted when they are initially uploaded, and will need to be decrypted again before reassembly. You might notice that the policy needs kms:GenerateDataKey permissions; these are needed because S3 will encrypt *each *of your objects in your with its own unique key derived from your master key, in a process known as [envelope encryption](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#enveloping) [1]*.*

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowS3CopyFromSource",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::source/*",
                "arn:aws:s3:::source"
            ]
        },
        {
            "Sid": "AllowS3CopyToDestination",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::destination/*"
            ]
        },
        {
            "Sid": "AllowKMSDecryptFromSourceBucket",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:us-east-1:source-account-id:key/source-key-id"
            ]
        },
        {
            "Sid": "AllowKMSEncryptToDestinationBucket",
            "Effect": "Allow",
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt",
                "kms:GenerateDataKey",
                "kms:DescribeKey"
            ],
            "Resource": [
                "arn:aws:kms:us-east-1:destination-account-id:key/destination-key-id"
            ]
        }
    ]
}
```

### Destination Bucket Resource Policy

Our destination bucket does not need a resource policy, as requests to it are coming from the S3Porter role in the *same *AWS account, and we have added s3:PutObject permissions for the destination bucket in our identity policy.

It’s worth noting that we could have also added a resource policy on the destination bucket, instead of adding it on the S3Porter identity policy above.

### Destination Encryption Key Resource Policy

The below is actually the [default key policy](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default). A little boring.

What’s worth noting, however, is that in KMS key policies are different than most resource policies. Without explicit access, IAM permissions on an identity policy alone are not allowed to access a CMK, even within the same AWS account. In a KMS key policy, the default way of giving intra-account policies the ability to access a key is by enabling a root account user to access the key; this will also enable other IAM policies to take action the key, as you see below.

```json
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::destination-account-id:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
```

### Source Bucket Resource Policy

To allow cross account access to an S3 bucket, we’ll need to add a resource policy, called a *bucket policy, *to our S3 bucket. This policy is relatively straightforward:

* In the principal section we specify the ARN of the cross-account role we want to give permissions to.

* In the actions section we provide both s3:GetObject and s3:ListObject permissions. These will both be necessary to fetch all of our bucket’s contents.

* As a resource, we specify both the bucket itself arn:aws:s3:::source as well as *all the objects in the bucke*t arn:aws:s3:::source/* .

Missing any of these things may result in a fairly vague 403 (access denied).

A more sophisticated bucket policy might use [conditions](https://docs.aws.amazon.com/AmazonS3/latest/dev/amazon-s3-policy-keys.html) to limit IP address ranges or narrow down which objects our S3Porter role can access.

Another way to grant the below permissions would be to use [access control lists (ACLs)](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html). ACLs are S3’s “old way” of managing permissions pre-IAM. ACLs are not deprecated, but they *are *legacy, and [AWS recommends bucket policies instead](https://aws.amazon.com/blogs/security/iam-policies-and-bucket-policies-and-acls-oh-my-controlling-access-to-s3-resources/).

```json
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::destination-account:role/S3Porter"
            },
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::source/*",
                "arn:aws:s3:::source"
            ]
        }
    ]
}
```

### Source Encryption Key Resource Policy

Finally, we have one more policy allowing our S3Porter to decrypt data from our cross-account source bucket.

```json
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::source-account-id:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow cross account decryption",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::destination-account-id:role/S3Porter"
            },
            "Action": "kms:Decrypt",
            "Resource": "*"
        }
    ]
}
```

## Walkthrough tutorial

Below I set up and execute copying between 2 buckets, cross account.

I recommend going through the below on your own to gain comfortability with cross-account bucket access, prior to automation or checking things in with [infrastructure-as-code](https://en.wikipedia.org/wiki/Infrastructure_as_code).

* I’ve changed all the names of the IDs, ARNs, accounts, etc, for privacy.

* Naturally, you will have to have permissions to create all the necessary objects in the first place. For this tutorial, I assume you have two profiles: source-admin and destination-admin. You can see how I set up these profiles with the ~/.aws/credential file below.

**Note: **It’s worth mentioning here that we’re using version 2 of the AWS CLI. The AWS CLI is great because it [encrypts our data in transit](https://docs.aws.amazon.com/cli/latest/userguide/cli-security-enforcing-tls.html#enforcing-tls-v2) with TLS 1.2 by default, so there’s no worry about us sending plaintext over the wire here.

```shell
# Set up our source and destination buckets
% aws kms create-key --profile destination-admin
...
        "KeyId": "destination-key-id",
...
% aws kms create-key --profile source-admin --policy file://source-encryption-key.json
...
        "KeyId": "source-key-id",
...
% aws s3 mb s3://destination --profile destination-admin
make_bucket: destination
% aws s3 mb s3://source --profile source-admin
make_bucket: source

# Add default bucket encryption
% aws s3api put-bucket-encryption --bucket destination  --profile destination-admin --server-side-encryption-configuration '
{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "aws:kms",
        "KMSMasterKeyID": "destination-key-id"
      }
    }
       
  ]
}'
%  aws s3api put-bucket-encryption --bucket source   --profile source-admin --server-side-encryption-configuration '
{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "aws:kms",
        "KMSMasterKeyID": "source-key-id"
      }
    }

  ]
}'

# Set up our S3Porter role. We'll allow our pretend admin user, destination-admin, to assume the role. This could also be your root user.
ekozliner@OH-PRO16-EKOZLINER schema-dl % aws iam create-role --profile destination --role-name S3Porter --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": { "AWS": "arn:aws:iam::destination-account-id:user/destination-admin" },
        "Action": "sts:AssumeRole"
    }
}
'
...

# Create an identity policy for our role using our "Role Identity Policy" from the tutorial, and attach that policy to our role.
% aws iam create-policy --policy-name S3PorterPolicy --profile destination --policy-document file://S3PorterPolicy.json
...

% aws iam attach-role-policy --role-name S3Porter --policy-arn arn:aws:iam::destination-account-id:policy/S3PorterPolicy --profile destination-admin

# Attach our source-bucket-policy.json to our source bucket: This will aloow cross account access.
% aws s3api put-bucket-policy --profile source-admin --bucket source --policy file://source-bucket-policy.json
...

# Explicitly block public access to our new bucket. This is a little unrelated to the tutorial, but a best practice. 
% aws s3api put-public-access-block  --bucket destination-ekozliner-tutorial --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" --profile personal

# Assume the role we will use to perform the cross-account access.
% aws sts assume-role  --role-arn arn:aws:iam::destination-account-id:role/S3Porter --role-session-name S3Porter --profile destination

{
    "Credentials": {
        "AccessKeyId": "access-key-id",
        "SecretAccessKey": "secret-access-key",
        "SessionToken": "session-token",
        "Expiration": "2020-11-08T23:50:23+00:00"
    },
    "AssumedRoleUser": {
        "AssumedRoleId": "AROA26ZK4I26EXAMPLE:S3Porter",
        "Arn": "arn:aws:sts::destination-account-id:assumed-role/S3Porter/S3Porter"
    }
}
```

Next, we will need to edit our ~/.aws/credentials file; this will let us use our porter role as a profile.



### Final steps

```shell
# Finally: Run our copy!
aws s3 cp s3://source s3://destination --recursive --profile porter
copy: s3://source/1.txt to s3://destination/1.txt
copy: s3://source/2.txt to s3://destination/2.txt
...
```

**If you followed the above example, remember to tear down any resources you created while doing it!**

Thanks for reading! If you want to chat or have feedback on a post, you can always contact me on Twitter, LinkedIn, or at evankozliner@gmail.com

## Notes

[1] A full rundown of envelope encryption is beyond the scope of this post, but envelope encryption is an important (and interesting) topic. There are a lot of reasons envelope encryption is handy: ranging from simplifying the rotation of master keys and ensuring they stay in [HSMs](https://en.wikipedia.org/wiki/Hardware_security_module), to speeding up encryption by enabling the use of different algorithms for object and key storage.
