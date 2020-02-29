# Image Creation, Management and Registry > Modify​​ an ​​image ​​to ​​a ​​single ​​layer

[Back](./ReadMe.md)

### Minimize the number of layers[](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#minimize-the-number-of-layers#minimize-the-number-of-layers)

In older versions of Docker, it was important that you minimized the number of layers in your images to ensure they were performant. The following features were added to reduce this limitation:

-   Only the instructions `RUN`, `COPY`, `ADD` create layers. Other instructions create temporary intermediate images, and do not increase the size of the build.

-   Where possible, use [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/), and only copy the artifacts you need into the final image. This allows you to include tools and debug information in your intermediate build stages without increasing the size of the final image.