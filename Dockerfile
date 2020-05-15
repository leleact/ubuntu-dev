FROM ubuntu:rolling
LABEL maintainer.name="leleact"
LABEL maintainer.eamil="leleact@gmail.com"

ADD http://mirrors.163.com/.help/sources.list.trusty /etc/apt/sources.list

RUN apt-get update
