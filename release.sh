#!/usr/bin/env bash

set -e

ANSI_YELLOW="\033[33m"
ANSI_RED="\033[31m"
ANSI_RESET="\033[0m"
PROJECT_NAME=datainsight-qa-collector

export VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "USAGE: release.sh <version-hash>"
  exit 1
fi

if [ $VERSION = '-p' ]; then
  VERSION=$(./package.sh | tail -n 1 | tr -d '\n')
fi

#HOST="deploy@datainsight"
HOST="deploy@datainsight.alphagov.co.uk"

scp $PROJECT_NAME-$VERSION.zip $HOST:/srv/$PROJECT_NAME/packages
# deploy
echo -e "${ANSI_YELLOW}Deploying package${ANSI_RESET}"
ssh $HOST "mkdir /srv/$PROJECT_NAME/release/$VERSION; unzip -o /srv/$PROJECT_NAME/packages/$PROJECT_NAME-$VERSION.zip -d /srv/$PROJECT_NAME/release/$VERSION;"
# link
echo -e "${ANSI_YELLOW}Linking package${ANSI_RESET}"
ssh $HOST "rm /srv/$PROJECT_NAME/current; ln -s /srv/$PROJECT_NAME/release/$VERSION/ /srv/$PROJECT_NAME/current;"
# restart
echo -e "${ANSI_YELLOW}Updating crontab${ANSI_RESET}"
ssh $HOST "cd /srv/$PROJECT_NAME/current; ./start.sh"
