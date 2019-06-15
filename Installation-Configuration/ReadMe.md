# Installation and Configuration (15%)

[Back](../ReadMe.md)

<details>
  <summary>
    Click to expand content summary:
  </summary>
  
+ Demonstrate​​ the​ ​ability​​ to​ ​upgrade ​​the ​​Docker ​​engine
+ Complete​​ setup ​​of ​​repo,​​select ​​a ​​storage​​driver, ​​and ​​complete​​ installation​​ of ​​Docker engine ​​on ​​multiple ​​platforms
+ [Configure ​​logging ​​drivers ​​(splunk,​ ​journald, ​​etc)](./Logging.md)
+ Setup ​​swarm,​​ configure ​​managers,​ ​add ​​nodes, ​​and ​​setup ​​backup ​​schedule
+ Create​​ and ​​manager ​​user​ ​and ​​teams
+ Interpret​​ errors​ ​to ​​troubleshoot ​​installation ​​issues​ ​without ​​assistance
+ Outline ​​the​​ sizing​​ requirements ​​prior ​​to ​​installation
+ Understand ​​namespaces,​ ​cgroups,​ ​and​ ​configuration ​​of ​​certificates
+ Use​​ certificate-based ​​client-server​ ​authentication​​ to​ ​ensure​​ a ​​Docker​​ daemon​​ has​​ the rights​ ​to ​​access ​​images​​ on ​​a ​​registry
+ Consistently​​ repeat​​ steps ​​to ​​deploy ​​Docker ​​​​engine, ​​UCP, ​​and ​​DTR ​​on ​​AWS ​​and ​​on premises ​​in ​​an​ ​HA ​​config
+ Complete​​ configuration ​​of ​​backups ​​for ​​UCP ​​and ​​DTR
+ Configure​​ the​ ​Docker​​ daemon​​ to​​ start​​ on​ ​boot
 </details>

## Install Docker on Digital Ocean droplet
```
wget -O - https://raw.githubusercontent.com/shailensukul/docker-certification/master/Scripts/install-docker.sh | bash
```