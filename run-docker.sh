#! /bin/bash

IMAGE=ghcr.io/jimpick/lotus-fvm-localnet-web-api@sha256:f7e8985827562cd1b499b6f9f1c3d313a963e5bee922a7c0f81d4eb12268c6af

docker rm -f localnet-test
#docker run -it -u 0 --entrypoint /bin/bash --name localnet-test $IMAGE
docker run --detach --name localnet-test $IMAGE
echo docker exec -it localnet-test -- bash
