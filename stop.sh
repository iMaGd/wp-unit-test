#!/bin/bash

docker compose --env-file ci/docker/.env.testing -f ci/docker/compose.yml down --remove-orphans

rm -rf ./ci/docker/tmp_build/
