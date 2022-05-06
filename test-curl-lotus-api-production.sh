#! /bin/bash

#URL=http://127.0.0.1:3000
URL=https://fvm-2.default.knative.hex.camp

set -x
curl -v -X POST   -H "Content-Type: application/json"   --data '{ 
      "jsonrpc": "2.0", 
      "method": "Filecoin.Version", 
      "params": [], 
      "id": 1 
    }'  $URL/rpc/v0 

