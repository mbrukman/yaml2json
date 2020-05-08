#!/bin/bash -u
#
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Runs all the YAML -> JSON tests in Python.

declare -i py_passed=0
declare -i py_total=0

for yaml in testdata/*.yaml; do
  json="${yaml/%.yaml}.json"

  echo "Testing: ${yaml} in Python ..."
  diff -u <(./python/yaml2json.py < "${yaml}") "${json}"
  if [ $? -eq 0 ];  then
    (( py_passed += 1 ))
  else
    echo
  fi
  (( py_total += 1 ))
done

echo "Python: ${py_passed} / ${py_total} passed"

if [ ${py_passed} -ne ${py_total} ]; then
  exit 1
fi
