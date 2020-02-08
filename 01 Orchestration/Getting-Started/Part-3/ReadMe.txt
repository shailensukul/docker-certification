Part 3 - https://docs.docker.com/get-started/part3/

This docker-compose.yml file tells Docker to do the following:
Pull the image we uploaded in step 2 from the registry.
Run 5 instances of that image as a service called web, limiting each one to use, at most, 10% of a single core of CPU time (this could also be e.g. “1.5” to mean 1 and half core for each), and 50MB of RAM.
Immediately restart containers if one fails.
Map port 4000 on the host to web’s port 80.
Instruct web’s containers to share port 80 via a load-balanced network called webnet. (Internally, the containers themselves publish to web’s port 80 at an ephemeral port.)
Define the webnet network with the default settings (which is a load-balanced overlay network).

[Commands]

# Initialize docker swarm
docker swarm init

# run the swarm
docker stack deploy -c docker-compose.yml part3

# Get the service ID for the one service in our application:
docker service ls


# A single container running in a service is called a task. 
# Tasks are given unique IDs that numerically increment, up to the number 
# of replicas you defined in docker-compose.yml. 
# List the tasks for your service:

docker service ps part3_web

# Tasks also show up if you just list all the containers on your system, 
# though that is not filtered by service:
docker container ls -q

You can run curl -4 http://localhost:4000 several times in a row,
 or go to that URL in your browser and hit refresh a few times.

 Either way, the container ID changes, demonstrating the load-balancing; 
 with each request, one of the 5 tasks is chosen, in a round-robin fashion, to respond. 
 The container IDs match your output from the previous command (docker container ls -q).

# To view all tasks of a stack:
# docker stack ps 
# followed by your app name, as shown in the following example:
 docker stack ps part3


# You can scale the app by changing the replicas value in docker-compose.yml, 
# saving the change, and re-running the docker stack deploy command:
docker stack deploy -c docker-compose.yml part3

# Take down the app
docker stack rm part3

# Take down the swarm
docker swarm leave --force