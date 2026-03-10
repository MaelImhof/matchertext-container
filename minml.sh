# Convenience script for using the MinML CLI in a containerized way, preventing
# conflicts with versions of Go installed on the host.
# See https://github.com/MaelImhof/matchertext-container for more information.
minml() {
    local SCRIPT_VERSION="2026.03.10-rev1"
    local IMAGE="ghcr.io/maelimhof/minml:latest"
    
    # Provide an easy way to update the MinML image without needing to know
    # the full docker pull command.
    if [[ "$1" == "--update-image" ]]; then
        docker pull "$IMAGE"
        return $?
    fi
    
    # Detect when the user is asking to see the help message from the CLI. In such
    # a case, the CLI will display its own help message, but we want to append
    # additional information about the wrapper.
    local REQUESTED_HELP=false
    if [[ $# -eq 0 ]]; then
        REQUESTED_HELP=true
    else
        for arg in "$@"; do
            if [[ "$arg" == "help" ]]; then
                REQUESTED_HELP=true
                break
            fi
        done
    fi

    # The CLI supports a server mode where it watches for file changes, transforms
    # them into HTML on the fly, and serves them on a local web server. The
    # container needs to forward the appropriate port to allow access to this server
    # from the host.
    local PORT_FLAGS=""
    local DEFAULT_PORT=8080
    local IS_SERVER=false

    # Only look for the port value if the server mode is actually used.
    for arg in "$@"; do
        if [[ "$arg" == "server" ]]; then IS_SERVER=true; fi
    done

    # Port can be set by providing argument --port XXX to the CLI.
    if [ "$IS_SERVER" = true ]; then
        local DETECTED_PORT=$DEFAULT_PORT
        for ((i=1; i<=$#; i++)); do
            if [[ "${!i}" == "--port" ]]; then
                next_val=$((i+1))
                DETECTED_PORT="${!next_val}"
            fi
        done
        PORT_FLAGS="-p $DETECTED_PORT:$DETECTED_PORT"
        echo "[WRAPPER] Server mode detected. Mapping port $DETECTED_PORT..."
    fi

    # Run the actual CLI.
    # Forward the port if server mode is detected.
    # Map the current directory to the working directory inside the container.
    # Use the same user ID to avoid permission issues with generated files.
    # Pass all arguments ($@) to the CLI as-is.
    docker run --rm -it \
        $PORT_FLAGS \
        -v "$(pwd):/data" \
        -w /data \
        --user "$(id -u):$(id -g)" \
        "$IMAGE" \
        "$@"

    # Append our own help message if the user requested help from the CLI, to provide
    # additional context about this wrapper script.
    if [ "$REQUESTED_HELP" = true ]; then
        # Get the image ID (sha256 hash) and shorten it to the first 12 characters for display.
        local IMG_ID=$(docker inspect --format='{{.Id}}' "$IMAGE" 2>/dev/null | cut -c8-18)

        # \033[1m and \033[0m are ANSI escape codes for bold text formatting in the terminal.
        echo -e ""
        echo -e "\033[1mWRAPPER\033[0m"
        echo -e "    You are using an unofficial convenience wrapper for the MinML CLI."
        echo -e "    More details available at https://github.com/MaelImhof/matchertext-container"
        echo -e "    \033[1mWrapper Script Version:\033[0m $SCRIPT_VERSION"
        echo -e "    \033[1mImage Version         :\033[0m $IMG_ID"
        echo -e ""
        echo -e "WRAPPER OPTIONS"
        echo -e "    --update-image    Pull the latest version of the container"
    fi
}