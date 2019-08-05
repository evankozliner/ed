---
layout: narrative
title: Merkle Tree Introduction
author: Evan Kozliner
---

![](https://miro.medium.com/max/948/1*16SWZME_BYN1y2nAv0cwFw.jpeg)

A Merkle tree, as present in a typical blockchain

The aim of this post is to provide an overview of the basic Merkle Tree data structure and a jumping off point for more advanced topics related to Merkle Trees.
While taking the[Bitcoin and Cryptocurrency Technologies](https://www.coursera.org/learn/cryptocurrency)class on Coursera I learned the basics of howhash based data structures could be used to verify the integrity of data in peer-to-peer systems. One of the core data structures mentioned in the class was the[Merkle Tree](https://brilliant.org/wiki/merkle-tree/),which is used in the[Bitcoin](https://hackernoon.com/tagged/bitcoin)[blockchain](https://hackernoon.com/tagged/blockchain)toverify the existence of a transaction in a way that conserves both space and time quite effectively(more on that later in this post!). It wasn’t until I dug a little deeper into the Merkle Tree that I realized how prolific this data structure really was, and decided to build an example[Merkle Tree of my own](https://github.com/evankozliner/merkle-tree).

> If you’re curious about whether you should take the Bitcoin and Cryptocurrency Technologies class, you should read my reflections on it[here](https://medium.com/@evankozliner/bitcoin-and-cryptocurrency-technologies-on-coursera-review-9c1f88444c82).

# Explanation

After construction, a Merkle Tree looks something like this:

![](https://miro.medium.com/max/842/1*TANA9WXlfDz3FNoNfrSGVw.png)

A basic Merkle Tree. I’ve abbreviated the middle nodes as H(cd) and H(ab) respectively, but without this shorthand the root hash could also be called H(H(H(a) + H(b)) + H(H(c) + H(d)))

*a, b, c,\_and_d_are some data elements (files, public/private keys, JSON, etc) and_H_is a hash function.If you’re unfamiliar,a hash function acts as a “digital fingerprint”of some piece of data by mapping it to a simple string with a low probability that any other piece of data will map to the same string.Each node is created by hashing the concatenation of its “parents” in the tree.You’ll notice that the Merkle tree here is a binary tree,most Merkle Trees are binary, but there are[non-binary Merkle Trees](https://blog.ethereum.org/2015/11/15/merkling-in-ethereum/)employed in platforms like Ethereum.Here we will just cover the binary case as it is by far the most common.
The tree can be constructed by taking nodes at the same height, concatenating their values, and hashing the result until the root is reached.A special case needs handled when only one node remains before the tree is complete, but other than that the tree construction is somewhat straightforward (more on this in the implementation section).
Once built, data can be audited using_only_the root hash in logarithmic time to the number of leaves (this is also known as a Merkle-Proof).Auditing works by recreating the branch containing the piece of data from the root to the piece of data being audited.In the example above,if we wanted to audit_c*(assuming we have the root hash)\_,\_we would need to be given H(d) and H(H(a) + H(b)).We would hash_c_to get H(c), then concatenate and hash H(c) with H(d), then concatenate and hash the result of that with H(H(a) + H(b)). If the result was the same string as the root hash, it would imply that_c_is truly a part of the data in the Merkle Tree.
In a case such as torrenting, another peer would provide the piece of data,\_c,\_H(d), and H(H(a) + H(b)). If you’re concerned about the security of this approach, recall that in a hash function it is computationally infeasible find some_e_such that H(e) = H(c). Thismeansthat so long as the root hash is correct, it would be difficult for adversaries to lie about the data they were providing.
Outputting the authentication path of some data is as simple as recreating the branch leading up until the root. Traversing the entire tree to produce the leaves and their respective authentication data becomes important when using the Merkle Tree in digital signature schemes, and this can actually be accomplished in under logarithmic time. There are some clever (but complex) algorithms to accomplish this described in[this paper](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.84.9700&rep=rep1&type=pdf).

# Selected Implementation Methods

You can find a complete version of the code[here](https://github.com/evankozliner/merkle-tree). I’ll explain the bulk of the tree creation and auditing methods.Note that both the*build_tree_and*\_audit_methods are instance methods from a larger class.

```python
def build_tree(self):
    """ Builds a merkle tree by adding leaves one at a time to a 
        stack and combining leaves in the stack when they are of the 
        same height.
        Expected items to be an array of type Node.
        Also constructs node_table, a dict containing hashes that map 
        to individual nodes for auditing purposes.
    """
    stack = []
    self._handle_solo_node_case()
    while self.root_hash == None:
        if len(stack) >= 2 and stack[-1].height == stack[-2].height:
            mom = stack.pop()
            dad = stack.pop()
            child_hash = self._md5sum(mom.hash + dad.hash)
            child = self.Node(mom, dad, child_hash)
            self.node_table[child_hash] = child
            mom.child = child
            dad.child = child

            if child.height == self.max_height:
                self.root_hash = child.hash

            stack.append(child)
        elif len(self.leaves) > 0:
            leaf = self.leaves.pop()
            self.node_table[leaf.hash] = leaf
            stack.append(leaf)
        # Handle case where last 2 nodes do not match in height by
        # "graduating" the last node
        else:
            stack[-1].height += 1
    self.is_built = True

```

Building the tree works by adding leaves to a stack and checking to see if the top two nodes in the stack are the same height. When they are, the nodes have a “child” (the hash of the concatenation of their two hashes), and when they are not a new node is appended to the stack. A small edge case needs handled when the last two nodes are of different heights.
The method above will fail in thesingle node case because no conditions will be met, so I added a small method to handle this for completeness.

```python

def _audit(self, questioned_hash, proof_hashes):
    """ Returns a boolean testing if questioned_hash
        is contained in the merkle tree.
        
        proof_hashes are the nodes to hash questioned_hash with
        in order from the bottom of the tree to the second-to-last
        level. len(proof_hashes) is expected to be the height of the
        tree, ceil(log2(n)), as one node is needed for proof per layer.
    """
    proof_hash = proof_hashes.pop()

    if not proof_hash in self.node_table.keys():
        return False

    sibling = self.node_table[proof_hash]
    child = sibling.child

    # Because the order in which the hashes are concatenated matters,
    # we must test to see if questioned_hash is the "mother" or "father"
    # of its child (the hash is always build as mother + father).
    if child.mom.hash == questioned_hash:
        actual_hash = self._md5sum(questioned_hash + sibling.hash)
    elif child.dad.hash == questioned_hash:
        actual_hash = self._md5sum(sibling.hash + questioned_hash)
    else:
        return False

    if actual_hash != child.hash:
        return False
    if actual_hash == self.root_hash:
        return True

    return self._audit(actual_hash, proof_hashes)
```

This is the auditing process described in the explanation section of this post. Some preconditions are checked in the public audit method, which is why I put the bulk of the logic inside this private version.

# Applications

Merkle Trees have gotten a lot of attention recently due to their use in blockchain applications.In many peer-to-peer (P2P) systems (not just blockchains!)individuals need to be able to request data from untrusted peers with some proof that what those peers sent them is part of the real content they requested.Torrents are an example of this problem: When you download a torrent, you receive files from others “seeding” that torrent online, but how can you be sure those files are really a part of what you’re trying to download, and not garbage or malware?The Merkle Tree can authenticate the data received from your peers to solve this trust problem.
A similar problem applies tocryptocurrencieslike Bitcoin and Ethereum: If someone claims that in sometransactionanother peer paid them, how can a node on the network verify that transaction really happened? One option is that the node could store the entire history of every transaction that has ever occurred, however, this is prohibitive in terms of both time and space costs to that node.Merkle Trees provide a solution that provide time and space savings for nodes on the network.By creating a Merkle Tree out of the transaction data in each block, transactions can be audited in logarithmic time instead of linear time. Additionally,it opens the door for some bitcoin clients can save space by only storing the root of the Merkle Tree:Not needing to store every transaction that has ever happenedin the history of Bitcoin is a huge value!
Beyond blockchains and torrents, Merkle Trees see usage in any system that needs to detect inconsistencies efficiently:

* Certificate authorities (CAs) use Merkle Trees as a means of[certificate transparency](https://www.certificate-transparency.org/what-is-ct). Here, public and private key pairs are treated as the leaves of the Merkle Tree. This is one mechanism CAs use to prevent situations where one CA might “go rogue” and try to certify a domain without the owner of the domain knowing of the certification.
* Highly scalable databases like[Apache Cassandra](http://cassandra.apache.org/)and[Dynamo DB](https://aws.amazon.com/dynamodb/)handling failures for replica databases on the network. This process is known as “Anti-Entropy” and is described in some depth on the[Apache Cassandra Blog](https://docs.datastax.com/en/cassandra/3.0/cassandra/operations/opsRepairNodesManualRepair.html)and to a lesser extent in[Amazon Dynamo DB paper.](http://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf)
* [Digital signature alternatives to RSA](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.84.9700&rep=rep1&type=pdf). In this case the root of the Merkle Tree acts as a public key and the individual nodes are used as one-time signatures. Recently some more work has been done to advance this techniques as it has been theorized to be resistant to quantum computing attacks (unlike RSA, which powers most public key cryptography today).

The applications of Merkle Trees are indeed numerous, and their utilization in any particular domain could be the subject of an entire blog post. I hope this served as a reasonable introduction.
If you have any more questions or just want to chat you can contact me through my, evankozliner@gmail.com or message me on Twitter: @evankozliner .
EDIT: Adds & fixes an image, fixes typos, bit of clarification on the basic example too
