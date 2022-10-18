#! /bin/bash

IMAGE=ghcr.io/jimpick/lotus-fvm-localnet-web-api@sha256:28cc112ce02d3d5c1ed7c47b80f2a9635c8b35205cf4a66a3328391d2e291d5d

docker rm -f localnet-test
docker run -it -u 0 --entrypoint /bin/bash --name localnet-test $IMAGE
#docker run --detach --name localnet-test $IMAGE
echo docker exec -it localnet-test -- bash
