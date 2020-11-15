---
layout: narrative
title: " A Free Coding Curriculum for Beginners"
author: Evan Kozliner
---

An opinionated guide to organizing your self-teaching process.

![](https://cdn-images-1.medium.com/max/2000/1*-6lfN_z-YUy0ijCI_EWlmA.jpeg)

There’s a magic point in your journey to becoming a software developer where you get the feeling you could build just about anything given enough time and access to Google [1]. This is the point where code becomes a tool for self-expression; the point where you can build what you feel like building. The aim of this post is to get you to that point.

I remember exactly when this happened to me. It was when I got my first programming job at 18 as an intern at a startup in Cincinnati, Ohio called LISNR. They wanted me to write some very junior-level Android code for them, and even though I’d never touched Android or Java before, I had the confidence to do it. I can’t promise this post will get you a programming job — that’s not the objective of this post — but if you can do the things I outline here, you’ll feel confident enough to apply as a side effect. Most of this curriculum comes from reflecting on everything I’d done prior to that job.

### How is the Curriculum Organized?

There are 3 sections, each builds on top of the last. I’ve put them in order, but don’t feel like you need to complete them in order. Just be sure you can close all the exit criteria from every section. The ultimate goal of the curriculum is for you to have a portfolio of projects on a personal website [2].

Each section has some free resources I’ve vetted and exit criteria to“prove” you’re at the next level. You don’t need to complete the resources in each section in their entirety, just be sure you can complete the exit criteria.

Admittedly, some of the exit criteria are a little vague. If you’re following the curriculum strictly and would like some clarification on any of them, reach out to evankozliner@gmail.com.

### What Makes this Curriculum Different?

The philosophy behind this curriculum is that to gain confidence as a coder you need to build projects and take them from conception to users. If you build it, but it’s never public, it doesn’t count. Delivering real things is the only metric that should matter as a craftsman; this is why only the first section is based primarily on online classes. Online classes are great for getting started, but they’re primarily passive.

To have confidence you need to be able to deal with ambiguity, not just listen and follow directions. This doesn’t mean you can’t ask for help — you should — just be sure you take an [active role in your education.](https://www.pnas.org/content/116/39/19251)

### How Long Will this Take?

How fast you move through this process is up to you. That being said, I think you should be programming a minimum of an hour a night, with at least two 4+ hour sessions over the weekend. Once you get past section 1, you’ll most likely want to work more than that because the project will be interesting to you.

Between the time I first wrote code and when I got my first job was about 2 years, but I wasted a bunch of time trying to learn things way beyond my skill level. If you follow this curriculum, you won’t make that mistake.

Consider the [100 days of code challenge](https://www.100daysofcode.com) to keep yourself committed. You might have to do it more than once.

### Prerequisites / What Computer Do I Need?

The only prerequisite is a functioning computer. The one at your local library is probably fine for getting started.

Once you get a little more serious, you’ll want a computer that can run either Linux or Mac OS. Both of these are what are known as Unix-based systems.

Linux is a free, open-source operating system that you can install on most Windows computers. It’s important to use either Linux or Mac OS and not Windows because much of the stuff you’re going to find out there in the wild is done on Unix based systems. Windows is not Unix based, so you’ll hit some barriers running certain programs [3].

Chances are if you’re not rich or in the arts, you’re using a Windows machine. Your first challenge will be getting Linux on it. Be careful: some of the newer Windows machines I’ve run into can’t install Linux. If you need to buy a new computer to do this, the specs do not matter (having bad specs and a free OS is probably even educational). I’d recommend getting the cheapest laptop you can. Here’s a recommendation:

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/k1hHRMIod0A" frameborder="0" allowfullscreen></iframe></center>

If you’re in a situation where you don’t have a computer and can’t buy a computer, that’s ok. You can start learning to program entirely in a web browser at a public library, even if they’re using a Windows machine and you can’t boot a second operating system. This also works if you’re stuck with a tablet. Most of the really good introductory courses I recommend are in the browser anyway and will take a complete beginner a few months to complete. Do those while you save up for that 100$ computer.

## 1. Basic Concepts

Before you start building anything it’s best to understand your tools. Watching lectures, reading blogs, and building small programs is how you get there. There are 4 things I want you to know first, no particular order:

**How to Write Code and Basic Theory**

This is where online classes come in. Find yourself an introductory online class or two. Or three, if you hate the first two. You need to walk away with basic programming concepts at the college freshman level. After that, I’d recommend ditching the theory for some time, then come back to theory once you’ve got practical more experience (big note on this approach here: [4]).

The quality of the instruction is more important than the language at this point. Note that the difficulty of switching languages is in no way analogous to real languages, don’t feel bad if you end up trying a lot of classes with different languages to find a fit. Here are a few classes where I liked what I saw:

* [Learn Python the Hard Way](https://learnpythonthehardway.org/python3/)

* [Javascript for complete beginners](https://opentechschool.github.io/js-beginners-1/)

* [MIT OpenCourseWare's Programming in Python](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-0001-introduction-to-computer-science-and-programming-in-python-fall-2016/lecture-videos/lecture-1-what-is-computation/)

* [Free code camp](https://learn.freecodecamp.org) intro to Javascript. This one is entirely in the browser for your tablet/library folks.

* [Stepik intro to Python](https://stepik.org/course/238/promo)

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/nykOeWgQcHM" frameborder="0" allowfullscreen></iframe></center>

There are countless others. [Coursera](https://www.coursera.org), for example, is another good source of classes.

Once you’re ready, supplement these classes with free [LeetCode easy questions.](https://leetcode.com) I played around with these myself and many of them are definitely not easy. To find questions that are actually easy, sort by acceptance percentage.

Exit Criteria:

These questions are meant to be sure you understand the process of taking a problem from description to code. The questions are language agnostic.

* Write matrix multiplication.

* Write Bubblesort and QuickSort. Understand why QuickSort is faster.

* Do 10 Leetcode easy problems with an acceptance of 75% or lower. One of them must involve searching a binary tree with recursion.

**Unix Terminal Basics and Scripting**

You can do all the browser-based things you like, but you’re not really a programmer until you’re interacting with a Unix-based terminal on a regular basis. Windows “Powershell” doesn’t count. You should know how to navigate, run programs in the languages you’ve learned, make and delete files, etc. all via the terminal. It’s terribly embarrassing seeing people opening up “finder” or some equivalent program even early in their career. The below tutorials are good and fairly short:

* [“Learn Enough” tutorial](https://www.learnenough.com/command-line-tutorial/basics)

* [linuxcommands.org](http://linuxcommand.org/lc3_learning_the_shell.php)

If you want to kill two birds with one stone, do the [Learn the Hard Way ](https://learnpythonthehardway.org/python3/)series I recommended in the basic theory section. In it, the author forces you to run programs in the terminal instead of in the browser or with an IDE (IDEs are basically a fancy editor). In practice you won’t write your code in the browser often, so don’t make it a crutch longer than you need to.

You’ll want your own computer to learn about the terminal. I wouldn’t recommend something browser-based here, but if you have to use the browser, for the time being, code academy has a tutorial [here](http://You'll want your own computer to learn about the terminal. I wouldn't recommend something browser-based here, but if you have to use the browser for the time being, code academy). You’d have to sign up for their free trial to use it, which only lasts 7 days. The tutorial is definitely short enough to complete by then.

A part of using the terminal is understanding how to write scripts that can be run quickly in the terminal. A script is a term for a simple, one-off program (as opposed to something long-lived, like a web server, or something larger, like a video game). An example of a script might be something that cleans up your desktop by moving files away from your desktop directory; notice how this is something you could do by hand, but that by writing a computer program to do it, you make the task far faster.

Exit Criteria:

* Understand directories, files, and basic Unix commands like “[ls](https://en.wikipedia.org/wiki/Ls)” and “[PWD](https://en.wikipedia.org/wiki/Pwd)”, “[cat](https://en.wikipedia.org/wiki/Cat_(Unix))”. Understand how Unix commands can be chained together with pipes and how you can pass options to scripts.

* Modify your bubble sort program to take input from the terminal.

* Write a script that takes in as input a user’s name and writes an HTML page to a file with that name in an “<h1>” tag.

* Write a script to search your computer for files larger than 1 gigabyte in size and print their absolute paths. First, write the script in a language like Python or Javascript, then write it with Unix tools like “[du](https://en.wikipedia.org/wiki/Du_(Unix))” and “[grep](https://en.wikipedia.org/wiki/Grep)”.

**HTML/CSS**

This is the easy stuff. HTML and CSS are the bread and butter of websites; they let you display text, images, etc, and style the page. You can even do animations with CSS nowadays (look ma, no javascript!).

Even if you’re not interested in building websites, and would prefer to get a job in something like cloud computing or machine learning, you’ll need to know them for your personal website. They’re also what I like to refer to as “hard knowledge” (they’re not going anywhere, so they’re not a waste of time to learn).

Courses are good for these as well. Here are some more recommendations:

* [30 days to learn HTML and CSS](https://www.youtube.com/watch?v=yTHTo28hwTQ&list=PLgGbWId6zgaWZkPFI4Sc9QXDmmOWa1v5F) (this is the one I did in high school. Still relevant!)

* [Free code camp](https://learn.freecodecamp.org). This one is entirely in the browser for your tablet/library folks. This time do the HTML/CSS section.

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/yTHTo28hwTQ" frameborder="0" allowfullscreen></iframe></center>

Exit Criteria:

* Write a static personal website. Websites with only HTML/CSS and Javascript are considered “static” because they display the same information to every user. Javascript is not required, but you’ll at least need HTML and CSS.
> # “You need to walk away with basic programming concepts at the college freshman level”

## 2. Personal Projects

Once you’re comfortable with the above, you need to start increasing the scope of your projects. We’re shifting the focus from simple scripts and algorithms to whole projects that require writing more code and organizing that code with abstractions like Object-Oriented Programming. The other aim of this section is to get you exposure to libraries and APIS: these allow you to leverage code others have written.

You’ll want to be sure these projects are interesting because you’ll put some of them up on your personal website in part 3.

You can write anything you want for this section, but you’ll need a minimum of 5 projects. Taking an idea from conception to is much harder than a well-defined problem, so this is where I’m expecting you to really struggle [5]. The difficulty is why it’s so important that the projects are interesting to you. You’ll only really struggle through if you *want* to build the thing you’re building. If you have a background in something other than software, now is the time to show that off.

The 5 projects are up to you, but here are 5 I built before I went to college that can serve as inspiration:

* Write PacMan. You could do this in the browser with Javascript, or as a local application using something like Python. When I wrote this I wrote a local version using C# [6]. I did this without any game dev-libraries, and I’d recommend you do the same. It’s more educational that way.

* Build a burglar detector with a microcontroller like [Arduino](https://www.arduino.cc) or a [Raspberry pi](https://www.raspberrypi.org). This one will require interfacing with hardware, which is really fun. There are some tutorials around this one, but try to make yours special.

* Build a blogging website with a database. Users perform [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations on posts. No Javascript necessary here. Note that by this point you may have come across some *frameworks* for web development. I remember being very confused by frameworks at this point. I’d probably stick away from them at this point in your web-development experience unless they’re small, like [Flask](https://www.fullstackpython.com/flask.html).

* Create a few audio visualizers. I built a few of these for a Coursera class that’s not around anymore. It should be able to run locally and in the browser.

* Write a text-based mobile app. I wrote a[ Myers Briggs test](https://www.16personalities.com/free-personality-test) for this.

Another concept to look into if you’re hunting for projects are public APIs. Companies like Twitter and Soundcloud offer APIs for third-party developers to use their data. Get creative with these!

* [Soundcloud API](https://developers.soundcloud.com/docs/api/guide)

* [Twitter API](https://developer.twitter.com/en/docs)

The only one of these I wouldn’t do without a mentor might be the mobile app. I was lucky enough to have a physics teacher I could ask questions about mobile development. Not everybody has mentors like that.

Also, be sure you’re thinking of ways to display these projects on your personal website. Your projects don’t need to be live or serving real users for this section of the curriculum, but keep how you’ll present the project in mind.

One last note here: Whatever you write, push it to [Github](https://github.com). Github is a version control website that will allow you to share your work with other developers. Do this even if you’re working by yourself. If you can, get a partner to work with, and learn to share code with one another using Git.

Just don’t push any secret information like your password to the database to Github. A friend and I made this mistake once early on. It’s embarrassing.

* [Here’s an introduction to using “git”.](http://rogerdudler.github.io/git-guide/) You can find plenty of these online.

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/u1L0NpA6voI" frameborder="0" allowfullscreen></iframe></center>

## 3. Live Projects

The final step brings your personal projects in contact with the rest of the world. Ideally, users will be able to interact with it directly on your personal website, on a separate website, or via an app, you get published, but if it’s something like a hardware project a blog post or video will suffice.

This includes a lot of miscellaneous but critical skills like cloud services, deployments, version control, browser differences, setting up certificates and domain names, and documentation. You’d be surprised how much of the job these kinds of tasks are. For a lot of people, myself included, they’re most of the job.

Exit criteria:

* All your personal projects should be linked to or presented on the website in some fashion. Get creative with how you present the projects. An in-browser video game or audio visualizer is a great place to start. If you have a non-static standalone website outside of your blog, figure out how to deploy it on a service like [AWS](https://aws.amazon.com) or [Heroku](https://www.heroku.com/)!

* Several — at least 3 — projects should be “live” in the sense that users interact with them in their browser, or download them and use them.

* At least one project should include documentation or a tutorial on how you built it.

* At least one of your projects should involve a server that you [ssh](https://en.wikipedia.org/wiki/Secure_Shell) into. Examples would be projects on a [raspberry pi](https://www.raspberrypi.org), or websites.

* All code for your projects published to Github.

* Deploy your static personal website via [Github pages](https://pages.github.com) (this is comically easy nowadays, and it’s free!)

## Have Fun

I saw a tweet the other week that summed up my recent thoughts on learning really well:

<blockquote class="twitter-tweet" data-conversation="none" data-align="center" data-dnt="true"><p>&#x200a;&mdash;&#x200a;<a href="https://twitter.com/paulportesi/status/1178451263798726656">@neiltyson</a></p></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Like woodworking or other crafts, you can make coding fun by building real projects all by yourself. Seeing the results of your work first hand is addictive and provides an emotional driver that pushes you to work more. My hope is that this curriculum can help you see code as a craft. Once you’re there, you won’t need a curriculum, your interests will tell you what you need to learn next.

## Notes

[1] Whether or not this feeling is just the [Dunning Kruger effect](https://en.wikipedia.org/wiki/Dunning%E2%80%93Kruger_effect) or not isn’t really important.

[2] This shows employees you actually care about programming. I’m pretty sure it’s how I got work as young as I did.

[3] I understand some versions of Windows can run a Unix shell now, but I haven’t tried this and I’m skeptical. Besides, if you get a job, or need to make changes on a server, you’ll probably use a Unix machine, so it’s best to start as soon as you can.

[4] The importance of computer science theory for practical programming is contentious. That being said, I think it’s best taught in a university setting, which isn’t free. If you’re interested in theory, consider working part-time as a programmer to pay for college (this is what I did all 4 years). The university system will also make it much easier for you to find work.

If you’re wondering if studying theory is worth it as a career move, I can’t tell you for sure. That being said, I’ve had the pleasure of meeting a hand full of principal engineers at my time at Amazon. Out of the ones who’s background I’ve asked about — 3 so far — all have had Ph.Ds. I don’t think that’s a coincidence.

Ps. I love theory, so I may be biased in this discussion.

[5] It might seem like doing things from scratch is very impressive, but it’s not. Starting from scratch is actually a clutch in most cases; building on top of an existing structure is typically more difficult. Things will be even harder in the workplace where you’ll need to coordinate with others and use poorly-documented technologies.

[6] This was the project that convinced me I could be a programmer for a living. I woke up in the middle of the night thinking about how I’d write different parts of this program, like the logic for the ghosts (did you know each color of ghost follows a different algorithm?)

**Credits**:

* The banner at the top was built with [Fotor](https://banner.fotor.com).
