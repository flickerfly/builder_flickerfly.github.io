Title: Hyper-Modern Bash
Date: 2021-03-10
Modified: 2021-03-10
Category: Bash
Tags: bash,pipeline
Slug: hyper_modern_bash
Authors: Josiah Ritchie
Status: Draft

Bash has been around for a long time and for better-or-worse it has resulted in some perhaps awkwardly complex programs. The initial project was probably just "a quick script to glue together" something. It turned out to be so useful that it began to attract more bits and pieces like a black hole and now you must figure out how to manage this monstrosity that can no longer be accurately called a "script". What can you do to keep it under control? 

It turns out that many of the same opportunities afforded to proper development languages like linting and unit tests are at the finger tips of the humble system administrator accidentally become system and platform developer. Adding these to the general practice of "clean code" and we can start to recover the ability to manage the project.

As you likely are not afforded the time to simply rewrite this whole thing in Python or some other language, these practices can be used to slowly clean up your script, give you more confidence in your changes and reduce the fear of making changes. Developers talk about _"The Strangler Pattern"_. Basically, when you go in to make a change, keeping these ideas in mind and slowly making iterations moving towards better code will reduce your technical debt slowly, but surely over time and maybe even reduce alert fatique, stress, mental breakdown and divorce. We're all pulling for ya.

## Syntax Checking

Syntax checking is something that any decent bash scripter is likely familiar with as it is built right into bash. `bash -n script` is the most accessible way to scan your script and will catch many of the basic issues without actually setting up a test environment, but you can do better. 

This is something you can do NOW. Before you commit that code to your code repo, I'm going to assume you are using something like git. If not, go figure that out pronto!\

Simply setup a git pre-commit hook that will check your syntax before each commit. Something like this will work.

```
-   repo: local
    hooks:
    -   id: check-bash-syntax
        name: Check Shell scripts syntax correctness
        language: system
        entry: bash -n
        files: \.sh$
```

Have you heard of a linter? More on that later.

## Functions

Writing your bash script in simple logical chunks help with the concept of DRY (Don't Repeat Yourself). Programmers like DRY because it means that when they have a bug in a piece of code, it is consistent across all the places that do the same thing and so creates dependability. This eases maintenance in because you can fix all those failures in each area something is done with a single change.

Functions also help make scripts more readable. You can give a whole hunk of code a single name so as you are reading over the logic of the script at a high level you've essentially documented that hunk of code with a name helping yourself when you come back in six months to remember why that hunk was important.

The ability to group like functions together is also pretty handy. All your functions having to do with adding, setting, deleting and other verbs on widget can be in the functions/widget.sh file and then at the top of your main script simply run `source functions/widget.sh` promoting layers of depth when trying to understand it. Your first pass at the script will help give context, but once you have the context to ask deeper questions you can start heading into those sourced functions. The functions then also have a context.

You will also really appreciate having simple chunks of code when it comes to unit testing, but we're not there yet.

## Naming scheme

A bash style guide will encourage consistency in things like variable and function names. Consider if you will use camelCase, PascalCase, MACRO_CASE, snake_case, kebab-case or other options and in which contexts. Perhaps local and global variables should differ. Function names ofter have an object they act on so an object_verb() syntax may be appropriate or you may prefer verb_object(). Either way, be consistent and predictable.

You'll likely find other ways you'd like to formalize your syntax. Does `then` go on a line by itself or at the end of the previous line, similarly `when true; do`?

## Linting

Linting does the job of syntax checking by nature, but also looks at the style and quality of the code. It will find things like the potential for a simple mistake to become a big bug. Consider this bit of code, `rm -rf /$nefarious`. What would happen if someone set `nefarious="appdir /"`? The eagle eye among us is shivering from the sheer thought of a force recursive remove of the entire file system. A linting tool, like [ShellCheck](https://github.com/koalaman/shellcheck) could save you from that user error that wipes your system because it will encourage you to put your variable in quotes resulting in the much safer `rm -rf "/$nefarious"`.

## Unit Tests

Modern development practice encourage the use of "Unit Testing". This concept has the goal of writing tests that exercise each of your lines of bash.

## Code Coverage

Code coverage is a great way to quickly get a metric of the quality of your code. [kcov](https://github.com/SimonKagstrom/kcov) will help identify which lines of your code have a test running against them and identify the total percentage of your code that is tested with each build. This can help target where your code is insufficiently tested and bugs are likely to crop up despite your unit tests.

## Inline Documentation

### What to Document
Generally speaking, code should speak for itself regarding what it does, but sometimes why we do something in a specific way, especially one that seems awkward and round-about, may be an important thing to record. Sometimes, things just aren't as simple as they appear and we may save ourselves the hour of spinning our wheels if we just write a sentence about it.

Therefore, generally speaking, don't write comemnts for the sake of writing comments. If the code says the same thing, your redundancy doesn't provide any help. If you think about the next person looking at this code with the skill you had before you wrote it and they're likely to be confused for any reason then that's a point to write a comment. Often this has to do with why you accomplished the task in the specific way you did. Also, having some basic details about the script at the top can be a helpful way to give a reader context.

### Auto Documentation

As your collection of scripts grows into something bigger, it can become helpful to formalize the documentation a bit. If each script places information about itself in the same place and the same way it becomes more approachable and faster to discover what is going on. Also, generally speaking, documentation that lives with the code tends to be somewhat easier to maintain. The ones making the changes are more likely to find new info.

Also, by standardizing your documentation in the scripts you open up opportunity for automation and publishing that documentation. [`shdoc`](https://github.com/reconquest/shdoc) provides a very simply way to generate Markdown documentation from your documents. You create a simple comment block with certain tagged keywords that identify information about the function that follows. 

These tagged comments would include a simple `# @description`, `# @arg`, `# @example` or `# @exitcode` note. These are very readable in the code, but also can be turned into Markdown documents that are easily created as part of the publish process. It is very likely that your git server already displays Markdown documents nicely.

### Usage Hints (-h)

We're all familiar with the -h option. This is real handy for anyone using your script and the simplest way to get some quick exposure to the scripts basic use. It can be as simple as right at the top checking for `-h` as an argument in `$@` and dumping out a `usage()` function or a more complex `getopts` based workflow, but general convention encourages a function called `usage()` to be what is output when your users request help.

## Development Environment

A formalize development environment can help get someone up and running quickly by reducing the work of getting dependencies resolved for each part of the process. Especially when you have setup many of these tools for maintaining code quality, it can become a problem to keep everyone properly equipped for code management.

One of the easiest ways to manage this is  through the use of Docker containers. You can publish your various test tools as separate Docker containers that the person developing can run to check the various aspects of your code. These containers then also become a foundation for your continuous integration pipeline, a natural expansion of your development environment.

## Continuous Integration

As all these quality improvements come into place, it can become daunting to actually make use of all these tools. This is where pipelines come into play. A continuous integration pipeline can be triggered on each new commit to run all your tools and complain if any problems arise. If problems don't arise, you can automatically merge the changes into your `main` code branch with confidence that your code is going to work. 