## Sections

| Section | 
| --- |
| [01 Orchestration](/01%20Orchestration/ReadMe.md) |
| [02 Image Creation, Management and Registry](/02%20Image-Creation-Management-Registry/ReadMe.md) |
| [03 Installation and Configuration](/03%20Installation-Configuration/ReadMe.md) |
| [04 Networking](/04%20Networking/ReadMe.md) |
| [05 Security](/05%20Security/ReadMe.md) |
| [06 Storage and Volumes](/06%20Storage-Volumes/ReadMe.md) |


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
  [Another another study guide](https://github.com/mrreyes512/DCA_Study_Guide) |
  [Terminal Recorder](https://asciinema.org/) |
  [Paste to Markdown](https://euangoddard.github.io/clipboard2markdown/) |
  
# Basics

An image is a lightweight, stand-alone, executable package that includes everything needed to run a piece of software, including the code, a runtime, libraries, environment variables, and config files.

A container is a runtime instance of an image—what the image becomes in memory when actually executed. It runs completely isolated from the host environment by default, only accessing host files and ports if configured to do so.

# VS Code on Headless Pi

[Edit files on Pi from PC](https://www.hanselman.com/blog/VisualStudioCodeRemoteDevelopmentOverSSHToARaspberryPiIsButter.aspx)

# Troubleshooting

* When getting EACCESS permission denied, saving files with Visual Studio Code on host
```
sudo chown -vhR dockeradmin /home/dockeradmin
```

* SSH from VSCode is repeatedly failing:

Enable root login on the pi so you can run commands without sudo

Login, and edit this file: `sudo nano /etc/ssh/sshd_config`
Find this line: P`ermitRootLogin without-password`
Edit: `PermitRootLogin yes`
Close and save file
reboot or restart sshd service using: `/etc/init.d/ssh restart`
Set a root password if there isn't one already: `sudo passwd root`

For this message when service starts: 
```
NanoCPUs can not be set, as your kernel does not support CPU cfs period/quota or the cgroup is not mounted
```

This is because you cannot control cpu limits on a Pi.
Remvove this from the docker compose file:
```
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
```

Ref: https://github.com/microsoft/vscode/issues/48659
C:\Users\shail\.vscode\extensions\ms-vscode-remote.remote-ssh-0.50.1\out

I did some more experimenting and I've found a way that works. -o RemoteCommand=none is not the only thing in this extension that prevents VS Code from establishing a working ssh session after calling sudo -u newuser -i, we also need to remove bash so that VS Code does not start an additional shell session on the remote host.

Here's a HOWTO:

make sure that sudo -u newuser -i works in a regular ssh session without requesting a password
remove "-o RemoteCommand=none" and "bash" from extension.js like so
sed -i s/"-o RemoteCommand=none"/""/ ~/.vscode/extensions/ms-vscode-remote.remote-ssh-*/out/extension.js
sed -i s/"bash"/""/ ~/.vscode/extensions/ms-vscode-remote.remote-ssh-*/out/extension.js


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