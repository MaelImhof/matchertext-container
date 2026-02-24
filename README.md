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

You can simplify your life and shorten the command by adding this the following your `~/.bashrc` file (or `~/.zshrc` for Mac/Zsh users):

```bash
minml() {
    # 1. Get the absolute path and directory of the input file
    local input_path="$1"

    if [ -z "$input_path" ]; then
        echo "Usage: minml <file.m> [output.html]"
        return 1
    fi

    # Determine the directory, filename, and base name
    local absolute_dir=$(cd "$(dirname "$input_path")" && pwd)
    local filename=$(basename "$input_path")
    local basename="${filename%.*}"

    # 2. Handle the output target
    # If a second argument is provided, use it. 
    # Otherwise, default to the same name with .html extension
    local output_file="${2:-$basename.html}"

    # 3. Run the container
    # We pipe the output to the output_file
    docker run --rm \
        -v "$absolute_dir:/data" \
        ghcr.io/maelimhof/minml:latest \
        "/data/$filename" > "$output_file"

    # 4. Success message
    if [ $? -eq 0 ]; then
        echo "Successfully transformed $filename -> $output_file"
    else
        echo "Error: Failed to transform the file."
    fi
}
```

You can then use the command seamlessly:

```bash
# Usage: minml <file.m> [output.html]
minml input.m
```

Make sure to close the terminal and re-open a new one after modifying `~/.bashrc` otherwise your changes won't take effect.