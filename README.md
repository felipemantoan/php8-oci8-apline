# Alpine + PHP 8 + OCI 8 + ADBBW (Autonomous Database)

A simple docker image with php 8 and Oracle DB Driver

## Requirements
- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [OCI ADBBW](https://docs.oracle.com/en/cloud/paas/autonomous-database/adbbw/#ADBBW-GUID-F6EC7814-5C62-4BA9-AE9C-F5DC21AD5FF1)

## How to use

```bash
docker-compose up --build
```
or
```bash
docker-compose build --no-cache .
```
or
```bash
docker build . --no-cache
```