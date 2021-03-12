# Build
To publish this you must have the built container to run the proper environment.

`docker build . -t pelican`

# Setup
This assumes that the build repo's `.git/config` has a remote setup in it called pages which is the user page flickerfly.github.io. This isn't needed for project pages that use the gh-pages branch instead.

# Preview
This makes the website available on `http://localhost:8000`.

`MSYS_NO_PATHCONV=1 docker run --rm -it -p 8000:8000 -e PORT=8000 -v ${PWD}:/website pelican make devserver`

# Publish
We push the code outside the container to avoid moving credentials into the container.

```
MSYS_NO_PATHCONV=1 docker run --rm -it -p 8000:8000 -e PORT=8000 -v ${PWD}:/website pelican make github
git push origin gh-pages && git push pages gh-pages:main
```

# Writing Pages

See https://docs.getpelican.com/en/4.5.4/content.html