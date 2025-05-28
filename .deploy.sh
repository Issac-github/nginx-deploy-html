#!/usr/bin/env bash

SERVER="root@47.107.49.154"
DEPLOY_PATH="/var/www/onlyHtmlDir"

echo "run at: `date`"

rm -fr dist.zip
zip -r dist.zip ./dist
scp ./dist.zip ${SERVER}:${DEPLOY_PATH}/dist.zip
ssh ${SERVER} "rm -fr ${DEPLOY_PATH}/dist;
                        unzip ${DEPLOY_PATH}/dist.zip -d ${DEPLOY_PATH};
                        rm -fr ${DEPLOY_PATH}/dist.zip;"
rm -fr dist.zip

echo "deploy done"