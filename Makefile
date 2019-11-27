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
	VER =
endif

THIRD_PARTY_PYTHON = third_party/python

.PHONY default:
	$(VERB) echo "Available targets: py-install, clean, build, test, regen"

py-install:
	$(VERB) pip install -r requirements.txt -t "$(THIRD_PARTY_PYTHON)"

build: yaml2json

# For now, our binary only includes a single Go file; if this were to change, we
# would need to dynamically discover the full set of local dependencies to
# include here.
yaml2json: yaml2json.go
	$(VERB) echo "Building Go binary ..."
	$(VERB) go build ./...

clean:
	$(VERB) rm -rf "$(THIRD_PARTY_PYTHON)"/*
	$(VERB) rm -f yaml2json

yaml_to_json_tests:
	$(VERB) echo "YAML -> JSON tests"
	$(VERB) ./run_tests.sh
	$(VERB) echo

gofmt_test:
	$(VERB) echo "gofmt test"
	$(VERB) ./gofmt_test.sh
	$(VERB) echo

go_mod_tidy_test:
	$(VERB) echo "go mod tidy test"
	$(VERB) ./go_mod_tidy_test.sh
	$(VERB) echo

test: build yaml_to_json_tests gofmt_test go_mod_tidy_test

regen: build
	$(VERB) ./regen.sh
