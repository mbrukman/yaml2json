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

VERB = @
ifeq ($(VERBOSE),1)
	VERB =
endif

THIRD_PARTY_PYTHON = third_party/python

.PHONY default:
	$(VERB) echo "Available targets: py-install, clean, build, test, regen"

py-install:
	$(VERB) python -m pip install -r requirements.txt -t "$(THIRD_PARTY_PYTHON)"

go-build: yaml2json json2yaml

yaml2json: cmd/yaml2json/yaml2json.go
	$(VERB) echo "Building Go binary ..."
	$(VERB) go build ./cmd/yaml2json

json2yaml: cmd/json2yaml/json2yaml.go
	$(VERB) go build ./cmd/json2yaml

clean:
	$(VERB) rm -rf "$(THIRD_PARTY_PYTHON)"/*
	$(VERB) rm -f yaml2json

go_json_to_yaml_test:
	$(VERB) echo "Go JSON -> YAML tests"
	$(VERB) ./json_to_yaml_test.sh Go ./json2yaml
	$(VERB) echo

go_yaml_to_json_test:
	$(VERB) echo "Go YAML -> JSON tests"
	$(VERB) ./yaml_to_json_test.sh Go ./yaml2json
	$(VERB) echo

py_json_to_yaml_test:
	$(VERB) echo "Python JSON -> YAML tests"
	$(VERB) ./json_to_yaml_test.sh Python "python python/json2yaml.py"
	$(VERB) echo

py_yaml_to_json_test:
	$(VERB) echo "Python YAML -> JSON tests"
	$(VERB) ./yaml_to_json_test.sh Python "python python/yaml2json.py"
	$(VERB) echo

gofmt:
	$(VERB) gofmt -s -w `find . -name '*.go'`

gofmt_test:
	$(VERB) echo "gofmt test"
	$(VERB) ./gofmt_test.sh
	$(VERB) echo

go_mod_tidy_test:
	$(VERB) echo "go mod tidy test"
	$(VERB) ./go_mod_tidy_test.sh
	$(VERB) echo

go-test: go-build go_json_to_yaml_test go_yaml_to_json_test gofmt_test go_mod_tidy_test

py-test: py_json_to_yaml_test py_yaml_to_json_test

test: go-test py-test

regen: go-build
	$(VERB) ./regen.sh
