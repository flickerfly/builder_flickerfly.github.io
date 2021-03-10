FROM python:3.8.0-alpine

RUN apk update && apk add \
	bash \
	git \
	git-fast-import \
	make \
	openssh
# TODO: Need to clean up apk

RUN mkdir /website && chmod 777 /website
COPY requirements.txt /website/
WORKDIR /website

# prevent writing .pyc files
ENV PYTHONDONTWRITEBYTECODE 1

RUN pip install --upgrade pip && \
	pip install -r requirements.txt

WORKDIR /website 