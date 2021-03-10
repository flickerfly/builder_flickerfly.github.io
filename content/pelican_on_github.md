Title: Using Pelican to Publish to a Github User Page
Date: 2021-03-10
Modified: 2021-03-10
Category: Pelican
Tags: pelican, publishing
Slug: pelican_on_github
Authors: Josiah Ritchie
Summary: Publishing a website to your github user page using Pelican is a simple way to enhance your presence and share knowledge.

These are some things I ran into when trying to setup publishing to my user page on github using Pelican.

## Repo Organization

You will need two repos. The first will be the repo with all the build configuration. The second is the location the code dumps into. If you are doing this on a project page, you will only need one repo. Your published content will be in your gh_pages branch instead of the main branch of the user page repo.

After the build process has completed, I run this to push my changes. Pages is the name of the git remote that is connected to my actual user page. 

```
git push origin gh-pages
git push pages gh-pages:main
```

I have those run outside the container, because I don't like passing my credentials into containers.

If you make any manual changes to the website repo, you may need to add the `--force` to clear out anything you manually changed in the repo like adding a README in it. Make no changes there to keep this process clean.

## Plugins and Themes

I found git submodules to be a useful way to handle plugins and themes. I simply added these to the builder repo so that I would have all the themes and plugins at hand to mess with. You may want to clean this up later. 

```
$ cat .gitmodules
[submodule "themes/pelican-bootstrap3"]
        path = themes
        url = https://github.com/getpelican/pelican-themes.git
[submodule "pelican-plugins"]
        path = plugins
        url = https://github.com/getpelican/pelican-plugins
```

## Build Environment
 
I found it useful to build a docker container for the Build Environment. Here is what I used:

```
FROM registry.access.redhat.com/ubi8/python-36

USER 0

COPY requirements.txt /website/
WORKDIR /website

# prevent writing .pyc files
ENV PYTHONDONTWRITEBYTECODE 1

RUN yum -y update && \
    yum install -y git make openssh && \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt
RUN mkdir -p /website && \
    chmod -R ug=rwx,o=rx /website && \
    chown -R 1000:1000 /website

USER 1000
```

Then I mount $PWD to the /website directory when I run the container with the docker option `-v ${PWD}:/website`. 