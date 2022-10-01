#!/bin/bash -eu
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

# Regenerate test outputs for test inputs (YAML -> JSON and vice versa).

if ! [ -e ./yaml2json ]; then
  echo "Missing ./yaml2json binary; run 'make go-build' first." >&2
	exit 1
fi

# Regenerate YAML -> JSON test outputs.
echo -n "Updating YAML -> JSON test outputs ... "
for yaml in testdata/yaml2json/*.yaml; do
  json="${yaml/%.yaml}.json"
  ./yaml2json < "${yaml}" > "${json}"
done
echo "done."

if ! [ -e ./json2yaml ]; then
  echo "Missing ./json2yaml binary; run 'make go-build' first." >&2
	exit 2
fi

# Regenerate JSON -> YAML test outputs.
echo -n "Updating JSON -> YAML test outputs ... "
for json in testdata/json2yaml/*.json; do
  yaml="${json/%.json}.yaml"
  ./json2yaml < "${json}" > "${yaml}"
done
echo "done."
