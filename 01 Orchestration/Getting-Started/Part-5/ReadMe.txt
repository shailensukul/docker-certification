Link: https://docs.docker.com/get-started/part5/

Deploy the updated docker-compose.yml file:
docker stack deploy -c docker-compose.yml getstartedlab

This compose file has a visualizer service which is configured to run the mananger node.
It also accesses a file on the manager node via volume mapping:

volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"

This allows it to create a visualisation of the running services.

It also has a redis service which also runs on the manager node and has a persistent volume mapping

volumes:
      - "/home/docker/data:/data"
deploy:
    placement:
    constraints: [node.role == manager]

    