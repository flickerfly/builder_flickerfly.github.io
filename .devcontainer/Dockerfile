FROM registry1.dso.mil/ironbank/redhat/python/python36:3.6

USER 0

COPY requirements.txt /website/
WORKDIR /website

# prevent writing .pyc files
ENV PYTHONDONTWRITEBYTECODE 1

RUN yum -y update && \
    yum install -y git make openssh && \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt
RUN mkdir -p /website