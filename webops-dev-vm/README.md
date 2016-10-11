How to use this Vagrantfile
===========================

This repository contains a Vagrant file to build and initialise a
VirtualBox machine for webops development.

The machine has the following features
1. Base image: Linux Mint 18
2. Docker ("vagrant" user is granted to run docker)
3. Git (major UKPDS repos are cloned to ~/abc/github)
4. Vim
5. AWS CLI
6. Keepassx
7. Terraform 0.7.4
8. Visual Studio Code

You will need to have the latest version of Vagrant installed on your
host machine.

Initialising
============
Before creating the machine, ensure that you have the following files
in place on your host machine:

 * An .aws folder in your home directory containing your AWS settings.
   This can be created by installing the AWS command line tools and
   running `aws configure`.
 * A .netrc file in your home directory containing your logins and
   passwords for GitHub and Bitbucket. For instructions see
   [this article](https://confluence.atlassian.com/bitbucketserver/permanently-authenticating-with-git-repositories-776639846.html).


These files will be copied to the VM when it is provisioned.

Next, from the root directory of this repository, run the following
command:

    vagrant up

The .vagrantfile will build the machine, install the most important
software, copy over your files as described above, and clone the public
@ukpds repositories from GitHub.

Note that it will not clone private repositories yet -- you will need to
do that separately once you have built the machine.

User name and password
======================
When prompted for a username and/or password (for example, if using `sudo`)
or the screen locks), use `vagrant` and `vagrant`.