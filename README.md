# Nexus 3.x OSS Habitat Plan

This repo contains a [Habitat](https://habitat.sh) plan.sh that can build and package Nexus OSS 3.x.x

## Building the package

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

## Running the package

On Linux with Habitat installed

```bash
hab svc load trickyearlobe/nexus
```

With docker

```bash
docker run -it -p 8081:8081 trickyearlobe/nexus
```

## Contributing

The usual instructions... fork the repo... make changes... submit a pull request
