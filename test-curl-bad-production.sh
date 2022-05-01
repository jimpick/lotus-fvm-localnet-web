#! /bin/bash

(cd fil-hello-world-actor; git checkout src/lib.rs)
mkdir -p tmp
cp -f fil-hello-world-actor/src/lib.rs tmp/lib.rs
perl -pi -e 's/state.count \+= 1;/state.count += "1";/' tmp/lib.rs
echo Patched code to cause error:
diff -u fil-hello-world-actor/src/lib.rs tmp/lib.rs
node -e 'd=require("fs").readFileSync("tmp/lib.rs", "utf8");console.log(JSON.stringify({ "lib.rs": d }))' > tmp/request.json
set -x
curl -v -H 'Content-Type: application/json' --data @tmp/request.json https://fvm-1.default.knative.hex.camp/compile > tmp/reply.json
cat tmp/reply.json | jq '.. |= (if type == "string" then .[0:1000] else . end)'

