#! /bin/bash

mkdir -p tmp
node -e 'd=require("fs").readFileSync("testdata/simplecoin.sol", "utf8");console.log(JSON.stringify({ "contract.sol": d }))' > tmp/request.json
set -x
curl -v -H 'Content-Type: application/json' --data @tmp/request.json http://127.0.0.1:4000/compile-evm > tmp/reply.json
cat tmp/reply.json | jq '.. |= (if type == "string" then .[0:1000] else . end)'

