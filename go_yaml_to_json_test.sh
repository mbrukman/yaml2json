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

# Runs all the YAML -> JSON tests in Go.

declare -i go_passed=0
declare -i go_total=0

for yaml in testdata/yaml2json/*.yaml; do
  json="${yaml/%.yaml}.json"

  echo "Testing: ${yaml} in Go ..."
  diff -u <(./yaml2json < "${yaml}") "${json}"
  if [ $? -eq 0 ];  then
    (( go_passed += 1 ))
  else
    echo
  fi
  (( go_total += 1 ))
done

echo "Go:     ${go_passed} / ${go_total} passed"

if [ ${go_passed} -ne ${go_total} ]; then
  exit 1
fi
