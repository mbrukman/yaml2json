// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/ghodss/yaml"
)

const (
	prettyPrint = true
	indent      = 2
)

// JsonToYamlOptions provides settings for YAML-to-JSON conversion.
type JsonToYamlOptions struct {
	PrettyPrint bool
	Indent      int
}

// JsonToYaml converts input JSON data to a YAML string.
func JsonToYaml(jsonData []byte, options JsonToYamlOptions) string {
	var o interface{}
	jsonErr := json.Unmarshal(jsonData, &o)
	if jsonErr != nil {
		fmt.Fprintf(os.Stderr, "JSON parsing error: %v\n", jsonErr)
		os.Exit(1)
	}

	var yamlData []byte
	var yamlErr error
	yamlData, yamlErr = yaml.Marshal(o)
	if yamlErr != nil {
		fmt.Fprintf(os.Stderr, "JSON marshal error: %v\n", yamlErr)
		os.Exit(2)
	}
	return string(yamlData)
}

func main() {
	var jsonData []byte
	var readErr error
	if len(os.Args) < 2 {
		jsonData, readErr = ioutil.ReadAll(os.Stdin)
	} else {
		jsonData, readErr = ioutil.ReadFile(os.Args[1])
	}
	if readErr != nil {
		fmt.Fprintf(os.Stderr, "Error reading JSON input: %v\n", readErr)
		os.Exit(1)
	}
	options := JsonToYamlOptions{
		PrettyPrint: true,
		Indent:      2,
	}
	fmt.Println(JsonToYaml(jsonData, options))
}
