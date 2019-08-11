---
layout: narrative
title: Bitcoin and Cryptocurrency Technologies on Coursera Review
author: Evan Kozliner
---

<figure>
  <img src="https://miro.medium.com/max/1050/1*gN1hMMko0EBMYM-PKSKjwA.jpeg" />
  <figcaption>Want some technical foundation before you buy anything? I know I did</figcaption>
</figure>


The [Bitcoin and Cryptocurrency Technologies](https://www.coursera.org/learn/cryptocurrency) class on [Coursera](https://www.coursera.org/) provides a solid introduction to cryptocurrencies and the blockchain from a technical perspective; albeit with some caveats that I wanted to make the subject of this blog post. With that said, here are the things I would have liked to know before taking the class:

**TLDR;**
If you’re wondering if you should take the class I would say **yes**, but do it like this: Power through the first 3 weeks of material, doing only the first and third assignment (even though the third isn’t due until the 7th week), and watch only the topics that really interest you afterwards. A good follow up project might be to [build a Merkle Tree](https://medium.com/@rogue_whale/merkle-tree-introduction-4c44250e2da7).

# The Good

**1. Comprehensive view of Bitcoin**

The first assignment really shines here. You’ll be asked to implement parts of a “centralized Bitcoin” known as ScroogeCoin, doing so will expose you to concepts such as the way Bitcoin actually handles transactions internally (hint: it’s not through a traditional database scheme). By the end you will feel comfortable with the basics contained in the [Bitcoin Developer Guide](https://bitcoin.org/en/developer-guide), like Bitcoin’s UTXO model. If you’re already knowledgable about the basics of Bitcoin’s implementation though, this may not be a worthwhile exercise for you.

**2. Cryptographic Primitives**

The first week of the class includes a comprehensive overview of the basic cryptography used in Bitcoin. Hash functions, hash-based data structures (e.g. the blockchain and Merkle Trees), digital signatures, and public key cryptography. These topics are definitely on the computer science greatest-hits list. Even if you have no interest in cryptocurrencies, I would suggest the first couple of lectures for just about anyone with a CS background.

# The Bad

**1. The bulk of learning is done in the first 3 weeks**

Just about all of the assignments can (and probably should) be completed in the first 3 weeks. This means that most of the lectures after the first 3 weeks are just interesting semi-technical tangents with no assignments or serious tests to reenforce the knowledge (on hardware, alternative puzzles, etc).

**2\.The second assignment is too trivial**

The topic (distributed consensus) is fascinating, but the second assignment takes an unfortunately shallow dive into it. You can get a passing grade simply by having every node in the network message every other node… Surely there’s more to distributed systems than that?

**3\.The assignments are timed poorly**

Oddly you will be able to complete all of the assignments using only information from the first 3 or 4 weeks. The last assignment isn’t due until the 7th week, but by then the information being taught in the course has diverged far from the implementation details needed to complete that last assignment. You will find yourself going back almost a month in the lectures to figure out when specific pieces of information were actually taught.

**4\. Java was a poor choice for this course**

This isn’t a complaint about Java as a language: This is a complaint about the accessibility of Java. Starting Java projects from a set of files someone else gives you is cumbersome, and unrelated to the material. In order to use the starter code for the assignments, you will have to do the_entire_Java song and dance with no assistance in how to do so (that is download and configuring an IDE, figuring out how to get your tests and code to compile properly, etc). When I talked to other students in the class, it became apparent that was in fact a barrier to entry. Why not the [most popular language taught in universities](https://cacm.acm.org/blogs/blog-cacm/176450-python-is-now-the-most-popular-introductory-teaching-language-at-top-u-s-universities/fulltext): Python?

**5\.Getting a little dated**

There’s very little (or no) information on contemporary topics like Etherium, smart contracts, and ICOs. In some ways this is an advantage because it minimizes the amount of jargon by giving you just the meat and bones of cryptocurrency information, but presumably it could be updated.
Thanks for reading, I hope this has been a good resource for anyone considering the class.

