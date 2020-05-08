#!/usr/bin/python
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

"""Converts a YAML file or string to a JSON format."""

import json
import os
import sys


# Enable importing YAML from local install (will also try to get it from the
# system install as well, if it's available). Local install can be done easily
# via `make py-install` using the Makefile provided in this directory.
from os.path import dirname
sys.path.append(os.path.join(dirname(__file__), '..', 'third_party', 'python'))


try:
    import yaml
except:
    sys.stderr.write(
        'Unable to import the `yaml` library; '
        'install it via: `make py-install` '
        'from the directory of this script.\n')
    sys.exit(1)


def YamlToJson(yaml_str, options):
    data = yaml.safe_load(yaml_str)
    if options.pretty_print:
        return json.dumps(data, sort_keys=True, indent=2, separators=(',', ': '))
    else:
        return json.dumps(data, sort_keys=True, separators=(',', ':'))


class YamlToJsonOptions(object):
    pretty_print = True
    indent = 2


def main(argv):
    if len(argv) < 2:
        yaml_data = sys.stdin.read()
    else:
        filename = argv[1]
        with open(filename) as yaml_input:
            yaml_data = yaml_input.read()

    options = YamlToJsonOptions()
    print(YamlToJson(yaml_data, options))


if __name__ == '__main__':
    main(sys.argv)
