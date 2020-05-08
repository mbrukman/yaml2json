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
	"strings"

	"github.com/ghodss/yaml"
)

const (
	prettyPrint = true
	indent      = 2
)

// YamlToJsonOptions provides settings for YAML-to-JSON conversion.
type YamlToJsonOptions struct {
	PrettyPrint bool
	Indent      int
}

// YamlToJson converts input YAML data to a JSON string.
func YamlToJson(yamlData []byte, options YamlToJsonOptions) string {
	var o interface{}
	yamlErr := yaml.Unmarshal(yamlData, &o)
	if yamlErr != nil {
		fmt.Fprintf(os.Stderr, "YAML parsing error: %v\n", yamlErr)
		os.Exit(1)
	}

	var jsonData []byte
	var jsonErr error
	if options.PrettyPrint {
		jsonData, jsonErr = json.MarshalIndent(o, "", strings.Repeat(" ", options.Indent))
	} else {
		jsonData, jsonErr = json.Marshal(o)
	}
	if jsonErr != nil {
		fmt.Fprintf(os.Stderr, "JSON marshal error: %v\n", jsonErr)
		os.Exit(2)
	}
	return string(jsonData)
}

func main() {
	var yamlData []byte
	var readErr error
	if len(os.Args) < 2 {
		yamlData, readErr = ioutil.ReadAll(os.Stdin)
	} else {
		yamlData, readErr = ioutil.ReadFile(os.Args[1])
	}
	if readErr != nil {
		fmt.Fprintf(os.Stderr, "Error reading YAML input: %v\n", readErr)
		os.Exit(1)
	}
	options := YamlToJsonOptions{
		PrettyPrint: true,
		Indent:      2,
	}
	fmt.Println(YamlToJson(yamlData, options))
}
