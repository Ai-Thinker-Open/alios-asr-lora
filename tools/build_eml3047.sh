#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
cd "$REPOSITORY_ROOT"

for command_name in arm-none-eabi-gcc python perl; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "Missing required command: $command_name" >&2
        exit 1
    fi
done

MAKE=build/cmd/linux64/make
if [ ! -x "$MAKE" ]; then
    echo "Bundled GNU Make is not executable: $MAKE" >&2
    exit 1
fi

COMMON_ARGS="-f build/Makefile HOST_OS=Linux64 SHELL=/bin/sh PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin TOOLCHAIN_PATH=/usr/bin/ PYTHON=/usr/bin/python PERL=/usr/bin/perl"

# shellcheck disable=SC2086
"$MAKE" $COMMON_ARGS clean
# shellcheck disable=SC2086
"$MAKE" $COMMON_ARGS lorawan.lorawanapp@eml3047 "JOBS=${JOBS:-4}"
