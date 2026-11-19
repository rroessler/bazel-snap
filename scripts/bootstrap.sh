#!/bin/bash
set -euo pipefail

# define some common options now
SOURCE_VERSION="${SOURCE_VERSION:-$1}"
SOURCE_PLATFORM="${SOURCE_PLATFORM:-amd64}"
SOURCE_WORKDIR="${SOURCE_WORKDIR:-bazel-dist}"
SOURCE_PATCHES="${SOURCE_PATCHES:-$PWD/patches/${SOURCE_VERSION%%.*}}"

# redefine missing items if necessary
SOURCE_KEYRING="${SOURCE_KEYRING:-snap/keyring.gpg}"

# prepare some additional source properties
SOURCE_ZIP="bazel-$SOURCE_VERSION-dist.zip"
SOURCE_URL="https://github.com/bazelbuild/bazel/releases/download/$SOURCE_VERSION/$SOURCE_ZIP"
SOURCE_SIG="https://github.com/bazelbuild/bazel/releases/download/$SOURCE_VERSION/$SOURCE_ZIP.sig"

# pull the source and signature file
curl -fsSL "$SOURCE_URL" -o "$SOURCE_ZIP"
curl -fsSL "$SOURCE_SIG" -o "$SOURCE_ZIP.sig"

# verify the source matches the checksum
gpgv --keyring "$SOURCE_KEYRING" "$SOURCE_ZIP.sig" "$SOURCE_ZIP"

# bootstrapping of Bazel has no version information, so we need to fix this
export EMBED_LABEL="$SOURCE_VERSION"
export BAZEL_DEV_VERSION_OVERRIDE="$SOURCE_VERSION"

# unzip the contents of the incoming bootstrap distribution
unzip "$SOURCE_ZIP" -d "$SOURCE_WORKDIR" && cd "$SOURCE_WORKDIR"

# apply any patches that we may have available now
cp $SOURCE_PATCHES/*.patch "third_party/" 2>/dev/null || :
[ -f "$SOURCE_PATCHES/_apply.py" ] && python3 "$SOURCE_PATCHES/_apply.py"

# actually attempt bootstrapping now!
env EXTRA_BAZEL_ARGS="--tool_java_runtime_version=local_jdk" bash ./compile.sh

# show the current version of our bootstrapped instance now
./output/bazel --version
