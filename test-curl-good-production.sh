#! /bin/bash

(cd fil-hello-world-actor; git checkout src/lib.rs)
mkdir -p tmp
node -e 'd=require("fs").readFileSync("fil-hello-world-actor/src/lib.rs", "utf8");console.log(JSON.stringify({ "lib.rs": d }))' > tmp/request.json
set -x
curl -v -X POST -H 'Content-Type: application/json' --data @tmp/request.json https://fvm-1.default.knative.hex.camp/compile > tmp/reply.json
cat tmp/reply.json | jq '.. |= (if type == "string" then .[0:1000] else . end)'

