#!/bin/sh
curl \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-H "Authorization: Basic a2llc2VydmVyOmJramtAMTIz" \
--data @post_body.json \
http://localhost:8234/kie-server/services/rest/server/containers/instances/test-project