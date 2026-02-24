This repository contains a draft paper and experimental code
related to matchertext, a syntactic discipline that allows
strings in one compliant language to be embedded verbatim without escaping
(e.g., via cut-and-paste) into itself or another compliant language.

For an overview of the matchertext idea please see
[the matchertext paper](https://bford.info/pub/lang/matchertext/).

The main contents of this repository are currently:

* [doc](doc): the LaTeX source for the in-progress matchertext paper.
* [go](go): experimental Go code for parsing and converting matchertext.

For quick testing using Docker:

```bash
# Pulls the pre-built image from GitHub Registry and runs it locally to
# convert a file in the current working directory.
#
# - --rm means the Docker container gets deleted once done, to prevent bloat
# - -v mounts the current working directory as a volume in the container so
#   that the CLI has access to the file to convert
# - /data/input.m is the name of the file. If you want to convert a file named
#   filename.m, use /data/filename.m instead
# - output.html is the name of the output file
docker run --rm -v "$(pwd):/data" ghcr.io/maelimhof/minml:latest /data/input.m > output.html
```

If you prefer building the image locally from source:

```bash
# Clone the fork with the Dockerfile
git clone https://github.com/MaelImhof/matchertext-container.git

# Build the Docker image locally
docker build -t minml-converter .

# Use the image built locally on the MinML file 'input.m' in the current working directory
docker run --rm -v "$(pwd):/data" minml-converter /data/input.m > output.html
```