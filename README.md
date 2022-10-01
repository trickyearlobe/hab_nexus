# Nexus 3.x OSS Habitat Plan

This repo contains a [Habitat](https://habitat.sh) plan.sh that can package and configure Nexus OSS 3.x.x with its dependencies

## Running the package

### On bare Linux with Habitat installed

Get a copy of [Habitat](https://www.habitat.sh/docs/get-habitat/)

```bash
# Download and run the package
hab pkg install trickyearlobe/nexus
hab svc load trickyearlobe/nexus
```

### With docker

```bash
docker run -it -p 8081:8081 trickyearlobe/nexus
```

## Logging in to Nexus

Browse to http://hostname:8081 and log in using the initial password. The file containing the initial password will be indicated in the login UI. It will probably be in `/hab/svc/nexus/data/sonatype-work/nexus3/admin.password`

The post install tasks (including initial login) are [described here](https://help.sonatype.com/repomanager3/installation-and-upgrades/post-install-checklist)

## Building the package from source

Get a copy of [Habitat](https://www.habitat.sh/docs/get-habitat/)

Build the package

```bash
cd hab_nexus
hab studio enter
build
```

Optional - export to a docker container

```bash
hab pkg export docker trickyearlobe/nexus
```

## Contributing

The usual instructions... fork the repo... make changes... submit a pull request
