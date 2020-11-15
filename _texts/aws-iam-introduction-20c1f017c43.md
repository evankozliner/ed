---
layout: narrative
title:  AWS IAM Introduction
author: Evan Kozliner
---

An overview of AWS identity and access management service

![The key elements of IAM are users, roles, and policies. We’ll go over each in this post, in addition to any relevant background. Created with [Draw.io](https://desk.draw.io/support/solutions/articles/16000042494-usage-terms-for-diagrams-created-in-diagrams-net)](https://cdn-images-1.medium.com/max/2000/1*r-XTV-N4LxMszEYs1_YKww.png)*The key elements of IAM are users, roles, and policies. We’ll go over each in this post, in addition to any relevant background. Created with [Draw.io](https://desk.draw.io/support/solutions/articles/16000042494-usage-terms-for-diagrams-created-in-diagrams-net)*

The first thing to both shock (and frustrate) many people moving into cloud-based environments is how complicated permissions can be. Typically, after years of becoming acclimated to being the God — sudo— of whatever code you have been writing prior, you are introduced to an environment where nearly everything is locked down by default.

This post will focus on alleviating some of that pain by teaching you the most important parts of IAM, the identity and access management service for Amazon Web Services, as well as introducing some well known best practices. In future posts I plan to build off this one.

## Accounts and Resources

The world of AWS starts with accounts and resources within those accounts. IAM exists primarily to protect the resources in your account from problems like:

* Malicious actors trying to do unwanted things to your AWS account (e.g. steal your data from your S3 buckets).

* Users/applications within your company accidentally deleting resources, or performing actions they otherwise should not be able to.

### **Accounts:**

The logical barrier between users of AWS. Pretty straightforward:

* 1–1 correspondence with a 12-digit *account id *e.g. 123456789012.

* As a best practice, an organization will have multiple AWS accounts [1]. IAM is often used to handle permissions between AWS accounts within an organization.

* Tied to an email address, credit card; accounts are how you are billed.

### **Resources:**

Resources are persisted objects in your account that you want to use, like load balancers or EC2 instances.

* Resources always have an [ARN](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html) — Amazon Resource Name — that uniquely identify them. E.g. for an IAM user, an ARN might look like the below:

    arn:aws:iam::123456789012:user/Development/product_1234/*

Notice how the account id 123456789012is present in the ARN, as well as the type of resource (this resource is an IAM user).

## Identities

The core feature of IAM is identities, a type of AWS resource. AWS services always expose APIs you can call using some identity; this tells AWS who you are (authentication) and whether you’re allowed to do what you’re doing (authorization).

There are two major forms of identities in IAM: users, and roles.

### Users

The intention of a user in IAM is similar those in other websites like Facebook. When you first create an AWS account you are given a [root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html) that has complete access to your account [2]. Then you’re given the — strongly suggested — option of creating further users and roles.

Some notes on users:

* Users, unlike roles, have a username and password. These are *long lived *credentials that can be persisted for an extended period of time and used to log into the AWS console.

* Often intended to give individuals access to AWS console, or APIs. **However, as a [best practice](https://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html#use-roles), you should use roles instead of users whenever possible. **This is to limit the risk of long-lived credentials being misplaced and giving an attacker access to your AWS account.

* Users are given access keys*. *Access keys can be used to call AWS services via the CLI or SDK. Like a username/password, access keys are long lived. They will look more randomized, and can be used together with the CLI by creating a file named ~/.aws/credentials with contents that look like the below:

    [personal]
    aws_access_key_id     = AKIAIOSFODNN7EXAMPLE
    aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

You can use a credentials profile with the CLI with the --profile option on the CLI:

    > aws s3 ls --profile personal

    2017-11-30 16:20:55 some-s3-bucket
    2017-10-31 20:05:17 some-other-s3-bucket
    ...

### Roles

Like users, roles are an identity used for accessing an AWS APIs and resources. However, roles are generally used to grant *temporary *credentials to an AWS account. Further, these temporary credentials can be configured to trust third parties, or other AWS services.

Roles are used ubiquitously in AWS:

* An EC2 instance that needs to access AWS resources will use an instance role to command other AWS services/resources based on your application logic.

* Other AWS accounts that need access to resources in your account will sometimes *assume* a role in your account to gain access via the [STS assume role API](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html). To allow them to do this, you can grant permissions on a role for some identity in another account via a trust policy (more on this later).

* A critical feature of AWS is its ability to take actions on your behalf. However, AWS services are typically implemented as AWS accounts; this means that they do not, by default, have access to the resources in your account. Accordingly, they will often require you create and grant them access to a “service role” in your account so that they can take actions *on your behalf. *Autoscaling on EC2, for example, [will need permissions](https://docs.aws.amazon.com/autoscaling/ec2/userguide/autoscaling-service-linked-role.html) to spin up and down EC2 instances for you.

* Third parties, like JumpCloud, will use roles to grant users managed outside of AWS access to AWS resources. This process is known as federation.

## Policies

Finally, when you (running as some identity) call an AWS API, IAM will determine whether the call is valid by evaluating one or more policies. There are two major kinds of policies: identity policies and resource policies.

### Identity Policies

Identity policies determine what a given identity (role/user) is allowed to do. Identity policies can be managed by either AWS — these managed policies will be pre-created in your account — or by you.

Below is an example of a simpler identity policy:

```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:CreateUser"
            ],
            "Resource": [
                "arn:aws:iam::123456789012:role/some-role",
                "arn:aws:iam::123456789012:user/some-user"
            ]
        },
        {
            "Action": [
                "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

* APIs that can be called are referred to as Actions in IAM. Multiple APIs can hit into a single action, but, more often than not, actions just correspond to a single API.

* The policy is a whitelist; this means that, by default, actions are *not* permitted. An explicit Allow is given for 2 actions: CreateRole and CreateUser. For a full breakdown of how policy logic is evaluated within an AWS account, see [this doc](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html#policy-eval-denyallow).

* Most API calls in AWS can be scoped-down to only being allowed on specific resources, as the above has. You can tell this has happened because the Resources section is not a *. This means that a request using this identity will succeed only against resources with those specific ARNs. For example, you could only create a role with the ARN arn:aws:iam::123456789012:role/some-role using this policy. **Scoping down to individual resources is a best practice that prevents many security holes. **Take, for instance, the 2019 Capital One hack. Capital One [gave their firewall excessive S3 permissions](https://krebsonsecurity.com/2019/08/what-we-can-learn-from-the-capital-one-hack/), which, once it was tricked via [SSRF](https://www.hackerone.com/blog-How-To-Server-Side-Request-Forgery-SSRF), allowed attackers to steal data from over 100 million individuals.

* Identity policies alone — without resource policies — will only work within the same AWS account.

* Wildcards are supported. The second statement in this policy is related to Cloudwatch logs, and gives *full access *to Cloudwatch logs (any API they open up, and for any resource).

Any given identity can have multiple policies attached to it; when this is the case, the identity gets the logical OR of the policies applied to it, where an explicit Deny will overwrite an explicit Allow .

I think the syntax is mostly straightforward, but, for a deeper dive into policy syntax, read the [docs.](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html)

There is also an EMR policy generator I recommend you use to build these faster here: [https://awspolicygen.s3.amazonaws.com/policygen.html](https://awspolicygen.s3.amazonaws.com/policygen.html)

### Resource Policies

When a resource is *acted* *on *by some Principal*, *whether that resource is an S3 bucket getting objects pulled from it, or an IAM role that someone is trying to assume, its resource policy will take effect. These may seem redundant at first, as you can scope identity policies to specific resources, but oftentimes it can be useful to set a policy on your resource instead of the identities that call it.

These resource policies also serve a critical role in enabling cross-account access to resources. Identity policies alone cannot enable cross account access, as the permissions boundary between AWS accounts is much tighter than within a single account.

Let’s examine a resource policy for a role. Note that resource policies on roles are also known as trust policies, because they enable others to assume the role.

```JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowEC2",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "AllowAssumeRole",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::123456789012:role/devops",
          "arn:aws:iam::123456789012:role/jenkins-master"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

* [**Principals](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html) are a name for the caller attempting to access a resource**. This policy whitelists the service, EC2, as well as two other roles in account 123456789012 to assume this role. Principals are a super-set of normal Identities, that can include things like AWS services, or users federated from other applications.

* You’ll notice that when you specify a principal for some rule, you need to specify what kind of principal it is. There are several types of principals, but two of the most common are Service and AWS . The former allows an AWS service, like EC2, to access this role, and the latter allows a specific AWS account’s identities to access the role.

* Depending on the service, resource policies vary widely. Some resource policies are stricter than others, or enable different features. In Key Management Service, for example, you must [grant your account’s root user permissions](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default) in a key’s resource policy before identity policies will be able to grant access to that key. S3 buckets have additional security controls, like [Access Control Lists](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html). **Always aim to understand how the resource you’re working with manages permissions individually: don’t assume two types of resources manage permissions the same way**.

On most resources, resource policies are optional. If they are not present, they are ignored, as you will see below.

## Simplified policy evaluation logic

To close, I want to offer a simple diagram to visualize what *order *the policies we talked about are evaluated in.

In the interests of simplicity, I’ve omitted the complete evaluation logic and only included common policies below. I recommend you read [the public documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html#policy-eval-denyallow) for a more detailed view of policy evaluation, including more esoteric policies like Session policies and Permissions Boundaries.

![A flowchart for typical policies evaluated when a Principal makes a request. Allow/Deny here correspond with the Allow/Deny are specified in the JSON policy documents you saw above. Created with [Draw.io](https://desk.draw.io/support/solutions/articles/16000042494-usage-terms-for-diagrams-created-in-diagrams-net)](https://cdn-images-1.medium.com/max/2000/1*8OAVGkgrpeNHjjHecdXcDg.png)*A flowchart for typical policies evaluated when a Principal makes a request. Allow/Deny here correspond with the Allow/Deny are specified in the JSON policy documents you saw above. Created with [Draw.io](https://desk.draw.io/support/solutions/articles/16000042494-usage-terms-for-diagrams-created-in-diagrams-net)*

IAM is one of the major building blocks of AWS. I hope this has served to introduce you to the major topics you will encounter when using it. If you have any more questions or just want to chat you can contact me through my, evankozliner@gmail.com or message me on [Twitter](https://twitter.com/evankozliner).

## Notes

[1] Architecting a multi-account organization is beyond the scope of this post, but, if you’re interested, I would recommend this video below and [this introduction](https://aws.amazon.com/organizations/getting-started/best-practices/).

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/zVJnenaD3U8" frameborder="0" allowfullscreen></iframe></center>

[2] The root user is actually distinct from IAM users. [There are certain tasks that only a root user can execute](https://docs.aws.amazon.com/general/latest/gr/root-vs-iam.html#aws_tasks-that-require-root).
