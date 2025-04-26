#!/bin/bash

SOURCE_DIR="/opt/sourcedir"
TARGET_DIR="/opt/targetdir"

TODAY=$(date +%Y-%m-%d)

find "$SOURCE_DIR" -maxdepth 1 -type f -name "*.jpg" -newermt "$TODAY" ! -newermt "$TODAY +1 day" -exec mv {} "$TARGET_DIR" \;
