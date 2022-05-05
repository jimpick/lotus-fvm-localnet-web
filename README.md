lotus-fvm-localnet-web
===

Builds a container image with a simple web gateway and a running
[lotus-fvm-localnet](https://github.com/jimpick/lotus-fvm-localnet)
inside a Kubernetes container, intended for use with [Knative](https://knative.dev/docs/) for
quickly spinning up "serverless" development environments for experimenting with
FVM actor development (aka. smart contracts).

## Building the Container image

The container images are built using GitHub Actions, which automatically upload the images
to the GitHub Container Registry.

* https://github.com/jimpick/lotus-fvm-localnet-web/actions
* https://github.com/jimpick/lotus-fvm-localnet-web/tree/main/.github/workflows

Because the image takes so long, it is built in several stages.

* `ghcr.io/jimpick/lotus-fvm-localnet-web-base`: Builds the Rust hello world actor example
* `ghcr.io/jimpick/lotus-fvm-localnet-web-api`: Builds the Node.js "cargo build" API service

These depend on yet another container image that builds the base Ubuntu image with
Lotus + params, which has a chain bootstrapped and ready-to-run:

* Repo: https://github.com/jimpick/lotus-fvm-localnet

## Example Deployment

This is being used to dynamically spin up Lotus localnets from this ObservableHQ notebook:

*  https://observablehq.com/@jimpick/fvm-actor-code-playground-hello-world?collection=@jimpick/filecoin-virtual-machine

## Example Knative Service Resource

```
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: fvm-1
  namespace: default
spec:
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/scale-to-zero-pod-retention-period: "3m"
    spec:
      containerConcurrency: 0
      containers:
      - name: node
        image: ghcr.io/jimpick/lotus-fvm-localnet-web-api@sha256:6c8ecebfa21883c1c4f3bc967071cf340c151d9cd333292463e99cef0eba93cd
        command: [ bash, -c ]
        args:
          - |
            lotus daemon --lotus-make-genesis=devgen.car --genesis-template=localnet.json --bootstrap=false
      - name: miner
        image: ghcr.io/jimpick/lotus-fvm-localnet-web-api@sha256:6c8ecebfa21883c1c4f3bc967071cf340c151d9cd333292463e99cef0eba93cd
        command: [ bash, -c ]
        args:
          - |
            lotus-miner run --nosync
      - name: web
        image: ghcr.io/jimpick/lotus-fvm-localnet-web-api@sha256:6c8ecebfa21883c1c4f3bc967071cf340c151d9cd333292463e99cef0eba93cd
        ports:
          - containerPort: 3000
```

## License

Apache 2 or MIT
