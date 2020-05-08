# yaml2json

[![Build Status][travis-badge]][travis-url]
[![Go Report Card][go-report-card-badge]][go-report-card-url]

[travis-badge]: https://travis-ci.org/mbrukman/yaml2json.svg?branch=master
[travis-url]: https://travis-ci.org/mbrukman/yaml2json
[go-report-card-badge]: https://goreportcard.com/badge/github.com/mbrukman/yaml2json
[go-report-card-url]: https://goreportcard.com/report/github.com/mbrukman/yaml2json

This project provides a simple library and CLI for converting YAML to JSON,
written separately in Python and Go.

# Usage

Build the Go utilities:

```shell
$ go get -u github.com/mbrukman/yaml2json/cmd/yaml2json
$ go get -u github.com/mbrukman/yaml2json/cmd/json2yaml
```

Convert YAML &rarr; JSON:

```shell
# read from stdin
$ [... generate some YAML...] | yaml2json

# read from a file
$ yaml2json foo.yaml
```

Convert JSON &rarr; YAML:

```shell
# read from stdin
$ [... generate some JSON...] | json2yaml

# read from a file
$ json2yaml foo.yaml
```

# Motivation

Some programs and utilities only support JSON as their configuration input
format; however, JSON is very strict and limited (which makes it great for
computers and programs), but it's insufficient for the needs of human
developers. A number of issues result from humans directly editing JSON:

* **JSON does not support comments,** so it's not possible to add context or
  annotations for why something is the way it is
* **JSON is quite verbose,** requiring double quotes around each field name
* JSON requires commas at the end of each key/value pair, but disallows a comma
  after the last key/value in an object — this is minor, but still somewhat
  tedious to have to remember to deal with

Thus, it's easier to write simple configs in YAML, but in that case, we find
ourselves in need of having a simple YAML-to-JSON converter, and rather than
re-implement the same simple converter within each project, I wanted to have a
stand-alone project which has this already pre-built.

## Why YAML?

**Or, why not [another language] instead?**

Because YAML is (mostly) simple, readable, and well-known. It supports comments,
does not require double quotes, or commas after fields. For many use cases,
what's needed is a simple hierarchical configuration format with comments for
annotating rationale, providing context, or links to related work. In those
cases, advanced features such as computation, reuse, or overrides are
unnecessary. If you need those types of features, you can use a language such as
[Jsonnet](https://jsonnet.org/), which supports templates and overrides, and it
has its own conversion to JSON.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for details.

## License

Apache 2.0; see [`LICENSE`](LICENSE) for details.

## Disclaimer

This project is not an official Google project. It is not supported by Google
and Google specifically disclaims all warranties as to its quality,
merchantability, or fitness for a particular purpose.
