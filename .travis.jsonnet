# Copyright 2019 Google Inc.
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

local goVersions = ["1.11.x", "1.12.x", "1.13.x"];

# Correspondence between XCode versions and Python versions on macOS found in this blog post:
# https://blog.travis-ci.com/2019-08-07-extensive-python-testing-on-travis-ci
local pyVersions = {
    "2.7": "xcode_9.3",
    "3.6": "xcode_9.4",
    "3.7": "xcode_10.2",
};
local oses = ["linux", "osx"];

local goSpec = function(goVer, os) {
  language: "go",
  go: goVer,
  os: os,
  env: ["GO111MODULE=on", "VERBOSE=1"],
  before_script: ["make go-build"],
  script: ["make go-test"],
};

local pySpec = function(pyVer, os) {
  language: if os == "linux" then "python" else "generic",
  python: if os == "linux" then pyVer,
  osx_image: if os == "osx" then pyVersions[pyVer],
  os: os,
  env: ["VERBOSE=1"],
  before_script: ["make py-install"],
  script: ["make py-test"],
};

# Output the parameterized config.
{
  dist: "bionic",
  # Travis CI warns about lack of a top-level "language" field, and assumes
  # "ruby".
  language: "generic",
  branches: {
    only: ["master"],
  },
  jobs: {
    include:
        [goSpec(goVer, os) for goVer in goVersions for os in oses] +
        [pySpec(pyVer, os) for pyVer in std.objectFields(pyVersions) for os in oses],
    allow_failures: {
      os: "osx"
    },
    fast_finish: true,
  }
}
