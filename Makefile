all: build

build: build-web

.PHONY: all build build-web run

build-web:
	DOCKER_BUILDKIT=1 docker build -f Dockerfile --progress=plain -t jimpick/lotus-fvm-localnet-web .

run:
	docker rm localnet-web
	docker run -it --entrypoint /bin/bash --name localnet-web jimpick/lotus-fvm-localnet-web
