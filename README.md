sample-pkg-debian
=================

[![Build Status](https://travis-ci.org/Nasga/sample-pkg-debian.svg?branch=master)](https://travis-ci.org/Nasga/sample-pkg-debian)

A dummy package build by travis and hosted by github

`````bash
echo 'deb http://nasga.github.io/sample-pkg-debian/apt/debian/ wheezy main' >> \
  /etc/apt/sources.list
apt-get update -qq
apt-get install sample-pkg-debian
`````
