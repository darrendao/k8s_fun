#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$VIRTUAL_ENV" ]; then
  echo "Please enable a python 3 virtual env"
  exit 1
fi

echo "Using virtualenv located in : $VIRTUAL_ENV"

echo -e "\n| --------------------- Running unit tests ------------------------- |"
pushd "$DIR/../src"
coverage run -m unittest discover -s test
result=$?
coverage report
popd

if [ $result -ne 0 ]; then
  exit $result
fi

echo -e "| -------------------- Unit tests completed ------------------------ |\n"

if [ "$INTU_CUSTOM_RESOURCE_INTEGRATION_TEST" == "" ];then 
  echo "'INTU_CUSTOM_RESOURCE_INTEGRATION_TEST' not set, not running integration tests."
  exit $result
fi

echo -e "\n| ----------------- Running integration tests ---------------------- |"
pushd "$DIR/../src"
coverage run -m unittest discover -s integration_test
result=$?
coverage report
popd

echo -e "\n| ------------------ Integration tests complete -------------------- |"
exit $result
