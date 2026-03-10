# MinML CLI Wrapper

This fork wraps the main MinML CLI into a containerized setup so that installing Go 1.24 on the host is not required, preventing version conflicts and simplifying setup.

A **convenience script** is also provided to use the CLI seamlessly from the terminal:

```bash
# Convert the file input.m and write the HTML to output.html
minml input.m > output.html

# Watch the file input.m and serve it in the browser at URL
# http://localhost:8080, refresh the page each time the file is modified
minml server input.m
```

## Installation

> [!WARNING]
> Windows is not natively supported. The convenience script relies on Bash/Zsh.
> To use the containerized version of the MinML CLI on Windows, please use WSL (Windows Subsystem for Linux).

> [!IMPORTANT]
> Because the whole point of this fork is to wrap the MinML CLI inside a container, some container software should be installed, such as **Podman** or **Docker**. The documentation and script assume Docker.

The simplest way to use this CLI wrapper is by adding the provided `minml.sh` script to your shell environment. This works natively on Linux and macOS.

1. The [`minml.sh`](https://github.com/MaelImhof/matchertext-container/blob/container/minml.sh) file at the root of this repository defines the `minml()` bash function. Copy and paste this function into `~/.bashrc` (or `~/.zshrc` if you are on macOS).

2. Close your terminal and open a new one for the modification to take effect.

3. Run the command without arguments to see if the setup works as expected:

    ```bash
    minml
    ```

    If this prints the help for the `minml` executable, then you're all set! Refer to the help command (`minml help`) or to the [examples section](#examples) to get started.

4. To update the script later on, simply remove the old version from your `~/.bashrc` or `~/.zshrc` file and paste the new one in.

### Using the raw container image

If you do not want to install a script, or you want to test the container before installing it, use Docker or Podman directly to run the container:

```bash
docker run --rm \
    -v "$(pwd):/data" \
    -w /data \
    --user "$(id -u):$(id -g)" \
    ghcr.io/maelimhof/minml:latest \
    input.m > output.html
```

### Building the image from source

Want to build the image yourself?

```bash
# Clone the fork with the Dockerfile
git clone https://github.com/MaelImhof/matchertext-container.git

# Build the Docker image locally
docker build -t minml-converter .

# Use the image built locally on the MinML file 'input.m' in the current working directory
docker run --rm \
    -v "$(pwd):/data" \
    -w /data \
    --user "$(id -u):$(id -g)" \
    minml-converter \
    input.m > output.html
```

## Examples

Here are some examples of commands with what they do:

```bash
# Convert a MinML file into HTML and print the HTML inside the terminal
# input.m can be any filename in the current directory
# By default, the CLI will print the output to the terminal
minml input.m

# Equivalent to the command above
# If you do not provide a command, as above, MinML CLI will default to
# the convert command, thus this version is simply more verbose
minml convert input.m

# Convert a MinML file into HTML and save the HTML to output.html
# output.html can be replaced by another filename
minml input.m > output.html

# Start a server on localhost:9000 and watch the file input.m
# When the file is modified, the page in the browser will be refreshed
# automatically, allowing for excellent UX
# If no port is specified, 8080 is the default
minml server input.m --port 9000

# Get a complete description of the existing options from both the CLI
# and the wrapper.
minml help

# Update the wrapper image (docker pull)
minml --update-image
```

Refer to the complete description of existing options provided by the CLI and the wrapper to learn more about more advanced or niche features.

## Useful links

- [`dedis/matchertext` (upstream project)](https://github.com/dedis/matchertext)
- [The matchertext paper](https://bford.info/pub/lang/matchertext/)
- [An introduction to MinML](https://bford.info/2022/12/28/minml/)
