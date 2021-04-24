#!/bin/bash

set -e  # abort on error

echo "Running 'meltano install'..."
meltano install

echo "Running 'meltano $@'..."
meltano $@
