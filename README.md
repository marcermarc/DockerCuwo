# DockerCuwo
A docker image for the free Cube-World Server "cuwo"

# Source Reposetorie
https://github.com/matpow2/cuwo

# Installation
Dockerimage to build yourself from the Dockerfile or to get from the Dockerhub:
https://hub.docker.com/r/marcermarc/dockercuwo/
Feel free to use the docker-compose file in this reposetorie.

The image contains 3 volumes:
* config: Download the original vonfig files from the source reposetories and put the files in it. (https://github.com/matpow2/cuwo/tree/master/config)
* data: In this folder comes 3 files of the original server-software of Cube-World:
  * Server.exe
  * data1.db
  * data2.db
* save: Cuwo saves in this folder the list of bans.

Cube-World uses the port 12345. In the original Client it is nit customizable, so make sure to expose this port to 12345
