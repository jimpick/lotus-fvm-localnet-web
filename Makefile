all: build

build: build-web-api

.PHONY: all build build-web-base build-web-api run-base run-base-bash run-api run-api-bash exec-bash

build-web-base:
	DOCKER_BUILDKIT=1 docker build -f Dockerfile-web-base --progress=plain -t jimpick/lotus-fvm-localnet-web-base .

build-web-api:
	DOCKER_BUILDKIT=1 docker build -f Dockerfile-web-api --progress=plain -t jimpick/lotus-fvm-localnet-web-api .

run-base:
	-docker stop localnet-web
	-docker rm localnet-web
	docker run -it --name localnet-web -p 3000:3000 jimpick/lotus-fvm-localnet-web-base

run-base-bash:
	-docker stop localnet-web
	-docker rm localnet-web
	docker run -it --entrypoint /bin/bash --name localnet-web -p 3000:3000 jimpick/lotus-fvm-localnet-web-base

run-api:
	-docker stop localnet-web
	-docker rm localnet-web
	docker run -it --name localnet-web -p 3000:3000 jimpick/lotus-fvm-localnet-web-api

run-api-bash:
	-docker stop localnet-web
	-docker rm localnet-web
	docker run -it --entrypoint /bin/bash --name localnet-web -p 3000:3000 jimpick/lotus-fvm-localnet-web-api

exec-bash:
	docker exec -it localnet-web bash -i


