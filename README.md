# Fork
This is a fork of [minostauros/duc-docker](https://github.com/minostauros/duc-docker) adapted to my needs to
 - list all available databases
 - avoid creating unneeded phantom volumes
 - based on alpine


# duc-docker
![Docker Pulls](https://img.shields.io/docker/pulls/toxic0berliner/duc-docker) [![Automated build on Github Actions](https://github.com/toxic0berliner/duc-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/toxic0berliner/duc-docker/pkgs/container/duc-docker)

Dockerized version of [duc](https://duc.zevv.nl), a disk usage analyzer.
See [docker hub](https://hub.docker.com/r/toxic0berliner/duc-docker/) to pull the images.

This image has some tweaks to achieve my personal need, but everything is straightforward (see its [github repo](https://github.com/toxic0berliner/duc-docker/)).

# Building
Run `docker build -t duc-docker .` then `docker run --rm -it --hostname duc-docker duc-docker bash` to get a shell in the container.


## References
  - Original duc: https://duc.zevv.nl
  - Reference duc-docker: https://github.com/minostauros/duc-docker/
