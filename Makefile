all: build

build: build-web

.PHONY: all build build-web run run-bash exec-bash

build-web:
	DOCKER_BUILDKIT=1 docker build -f Dockerfile --progress=plain -t jimpick/lotus-fvm-localnet-web .

run:
	-docker stop localnet-web
	-docker rm localnet-web
	docker run -it --name localnet-web -p 3000:3000 jimpick/lotus-fvm-localnet-web

run-bash:
	-docker stop localnet-web
	-docker rm localnet-web
	docker run -it --entrypoint /bin/bash --name localnet-web -p 3000:3000 jimpick/lotus-fvm-localnet-web

exec-bash:
	docker exec -it localnet-web bash -i
