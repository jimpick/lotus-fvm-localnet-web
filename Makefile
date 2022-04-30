all: build

build: build-web-base

.PHONY: all build build-web-base run-base run-bash-base exec-bash-base

build-web-base:
	DOCKER_BUILDKIT=1 docker build -f Dockerfile --progress=plain -t jimpick/lotus-fvm-localnet-web-base .

run-base:
	-docker stop localnet-web
	-docker rm localnet-web
	docker run -it --name localnet-web -p 3000:3000 jimpick/lotus-fvm-localnet-web-base

run-bash-base:
	-docker stop localnet-web
	-docker rm localnet-web
	docker run -it --entrypoint /bin/bash --name localnet-web -p 3000:3000 jimpick/lotus-fvm-localnet-web-base

exec-bash-base:
	docker exec -it localnet-web bash -i
