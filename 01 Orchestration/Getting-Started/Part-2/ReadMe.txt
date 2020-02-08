Url : https://docs.docker.com/get-started/part2/

# build the image
docker build --tag=getting-started .

# list the image
docker image ls

#run the image
docker run -p 4000:80 getting-started
store
# browse to the url
curl http://localhost:4000

# run the app in the background, in detached mode
docker run -d -p 4000:80 getting-started

# You get the long container ID for your app and then are kicked back to your terminal. 
# Your container is running in the background. 
# You can also see the abbreviated container ID with 

docker container ls 

# Now use docker container stop to end the process, using the CONTAINER ID
docker container stop 1fa4ab2cf395

# login to Docker
 docker login

 # tag the image
 docker tag getting-started shailensukul/getting-started:part2

 # see your tagged image
 docker image ls

# publish the image
docker push shailensukul/getting-started:part2

# pull and run image from repository
docker run -p 4000:80 shailensukul/getting-started:part2