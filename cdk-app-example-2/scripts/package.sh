#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

lambda_file_name=main

BUILD_DIR=$SCRIPT_DIR/../build
mkdir -p $BUILD_DIR

# Get Virtualenv Directory Path
if [ -z "$VIRTUAL_ENV" ]; then
  VIRTUAL_ENV="$SCRIPT_DIR/../venv"
fi

echo "Using virtualenv located in : $VIRTUAL_ENV"

# If zip artifact already exists, back it up
if [ -f $BUILD_DIR/$lambda_file_name.zip ]; then
  mv $BUILD_DIR/$lambda_file_name.zip $BUILD_DIR/$lambda_file_name.backup.zip
fi

# Add virtualenv libs in new zip file
cd $VIRTUAL_ENV/lib/python3.*/site-packages
zip -qrX $BUILD_DIR/$lambda_file_name.zip *
cd $SCRIPT_DIR

# Add python code in zip file
pushd $SCRIPT_DIR/../src
zip -gqX $BUILD_DIR/$lambda_file_name.zip *.py config.yaml -x "test*.py" -x "*.git*"
popd
