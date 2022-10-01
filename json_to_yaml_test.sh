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

# Runs all the JSON -> YAML tests.

declare -r LANGUAGE="$1"
declare -r RUNNER="$2"

declare -i passed=0
declare -i total=0

for json in testdata/json2yaml/*.json; do
  yaml="${json/%.json}.yaml"

  echo "Testing: ${json} in ${LANGUAGE} ..."
  diff -u <(${RUNNER} < "${json}") "${yaml}"
  if [ $? -eq 0 ];  then
    (( passed += 1 ))
  else
    echo
  fi
  (( total += 1 ))
done

echo "${LANGUAGE}: ${passed} / ${total} passed"

if [ ${passed} -ne ${total} ]; then
  exit 1
fi
