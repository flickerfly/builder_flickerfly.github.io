Title: Hyper-Modern Bash
Date: 2021-03-10
Modified: 2021-03-10
Category: Bash
Tags: bash,pipeline
Slug: hyper_modern_bash
Authors: Josiah Ritchie
Status: Draft

Bash has been around for a long time and for better-or-worse it has resulted in some perhaps awkwardly complex programs. The initial project was probably just "a quick script to glue together" something. It turned out to be so useful that it began to attract more bits and pieces like a black hole and now you must figure out how to manage this monstrosity that can no longer be accurately called a "script". What can you do to keep it under control? 

It turns out that many of the same opportunities afforded to proper development languages like linting and unit tests are at the finger tips of the humble system administrator accidentally become system and platform developer.

As you likely are not afforded the time to simply rewrite this whole thing in Python or some other language, these practices can be used to slowly clean up your script, give you more confidence in your changes and reduce the fear of making changes. Developers talk about "The Strangler Pattern". Basically, when you go in to make a change, keeping these ideas in mind and slowly making iterations moving towards better code will reduce your technical debt slowly, but surely over time and maybe even reduce alert fatique, stress, mental breakdown and divorce. We're all pulling for ya.

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