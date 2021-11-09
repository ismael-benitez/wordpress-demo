## Overview

Containerized stack for WordPress automatized with **Makefile**.

- Local development environment with Docker
- Demo data for testing

## Requirements

Make sure all dependencies have been installed before moving on:

- [Docker](https://docs.docker.com/get-docker/). In **linux**, you have to install [Docker Compose](https://docs.docker.com/compose/install/) too.
- Makefile:
    - For **OS X** `brew install make`,  more info [here](https://formulae.brew.sh/formula/make).
    - For **Windows** you have multiple options: WSL 2, [Cygwin](https://livezingy.com/install-cygwin-on-win10-for-makefile-2/), Chocolatey.
    - For **Linux**, you are ready! :) 

## Local development setup

### Setup using `bash`

```bash
$ cp docker-compose.dist.yml docker-compose.yml
$ docker-compose --env-file=./config/local.env build
$ docker-compose --env-file=./config/local.env up -d
$ docker-compose --env-file=./config/local.env exec wordpress demo 
$ docker-compose --env-file=./config/local.env stop
```

Finally, depending of your OS:

- **Linux**: open http://localhost:8000/
- **Windows**: start http://localhost:8000/
- **Windows WSL**: cmd.exe /C start http://localhost:8000/
- **Mac OS**: xdg-open http://localhost:8000/

### Setup using `make`

The main commans for start or stop your local environment are:

```bash
$ make start
$ make stop
```

But other useful commands would be:


```bash
$ make bash
$ make mysql
$ make logs
```

Finally, using the `c=` option we can limit the command to only one container when it supports it:

```bash
$ make logs c=wordpress
$ make logs c=wordpress t=5
$ make start c=wordpress
$ make stop c=wordpress
```

Enjoy!