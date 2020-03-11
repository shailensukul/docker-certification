# Networking > Configure ​​Docker ​​to ​​use​ ​external​ ​DNS

[Back](./ReadMe.md)

```
Either via 
$ docker run --dns 10.0.0.2 busybox nslookup google.com

or edit your /etc/docker/daemon.json to have something like:

{
    "dns": ["10.0.0.2", "8.8.8.8"]
}

then restart docker service  
$ sudo systemctl docker restart
```