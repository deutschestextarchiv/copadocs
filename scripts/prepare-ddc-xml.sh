#!/bin/bash

DSTAR_ROOT=/home/ddc-dstar/dstar
SOURCE=/home/wiegand/src/copadocs
TARGET="$DSTAR_ROOT"/sources/copadocs

find "$TARGET" -type f -delete

for i in $(find -L "$SOURCE"/data -name '*.xml'); do
  BASE=$(basename "$i")
  DIR=$(basename $(dirname "$i"))
  xsltproc -o "$TARGET"/"$DIR"/"$BASE" "$SOURCE"/scripts/prepare-xml.xsl "$i"
done
