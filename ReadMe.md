## Sections

| Section | 
| --- |
| [Orchestration](/Orchestration/ReadMe.md) |
| [Image Creation, Management and Registry](/Image-Management-Registry/ReadMe.md) |
| [Installation and Configuration](/Installation-Configuration/ReadMe.md) |
| [Networking](/Networking/ReadMe.md) |
| [Security](/Security/ReadMe.md) |
| [Storage and Volumes](/Storage-Volumes/ReadMe.md) |


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