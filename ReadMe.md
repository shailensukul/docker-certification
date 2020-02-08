## Sections

| Section | 
| --- |
| [Orchestration](/01 Orchestration/ReadMe.md) |
| [Image Creation, Management and Registry](/02 Image-Creation-Management-Registry/ReadMe.md) |
| [Installation and Configuration](/03 Installation-Configuration/ReadMe.md) |
| [Networking](/04 Networking/ReadMe.md) |
| [Security](/05 Security/ReadMe.md) |
| [Storage and Volumes](/06 Storage-Volumes/ReadMe.md) |


# Docker Certified Associate

![Docker Certified Associate](/Images/docker-certified-associate.jpg)


My notes while preparing for the Docker Certified Associate exam.

 Links     |
 ------ |
  [Official Pdf Guide](/dca-study-guide-v1.0.1.pdf) |
  [Official Prep Guide](https://github.com/DevOps-Academy-Org/dca-prep-guide) |
  [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) |
  [Study guide](https://github.com/Evalle/DCA) |
  [Another study guide](https://github.com/suryaval/docker-certified-associate) |
  [Terminal Recorder](https://asciinema.org/) |
  [Paste to Markdown](https://euangoddard.github.io/clipboard2markdown/) |
  
# Basics

An image is a lightweight, stand-alone, executable package that includes everything needed to run a piece of software, including the code, a runtime, libraries, environment variables, and config files.

A container is a runtime instance of an image—what the image becomes in memory when actually executed. It runs completely isolated from the host environment by default, only accessing host files and ports if configured to do so.

# Digital Ocean

* Sign up for a free trial account at (Digital Ocean)[https://cloud.digitalocean.com]
* Create a Ubuntu droplet
* You will get an email with the IP address of the droplet and the root user & temporary password.
SSH into the droplet and change the root user password when prompted
```
ssh root@[droplet ip]
```
* Create another user for docker and give it sudo privileges
```
adduser dockeradmin
usermod -aG sudo dockeradmin
logout
```
* Now, you can SSH as the docker admin user
```
ssh dockeradmin@206.189.82.62
```
* Install docker by running this script
```
 wget -O - https://raw.githubusercontent.com/shailensukul/docker-certification/master/Scripts/install-docker.sh | bash
```

[![asciicast](https://asciinema.org/a/r5lXhDCESh9twcmktgVDoYdp9.svg)](https://asciinema.org/a/r5lXhDCESh9twcmktgVDoYdp9)

# Terminal Recording
Install with:
```
sudo apt-add-repository ppa:zanchey/asciinema
sudo apt-get update
sudo apt-get install asciinema
```

Record:
```
asciinema rec
```

Stop recording:
```
To finish hit Ctrl-D or type exit.
```