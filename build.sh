#!/bin/bash

###########
# CONFIGURATION
#
# website base URL
WEB_BASE="${WEB_BASE:-/copadocs/}"

# debugging
[ -n "$DEBUG" ] && set -x
set -e

# directory of this script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# web target directory
WEB="$SCRIPT_DIR"/web

# path to and options for xsltproc XSLT processor
XSLTPROC="xsltproc"

# don’t leave $DIR/*.xml as literal "*.xml" when directory is empty
shopt -s nullglob

# symlink (for XML sources and images)
DATA_LINK="$WEB"/data
[ -L "$DATA_LINK" ] && rm "$DATA_LINK"
ln -s "$SCRIPT_DIR"/data "$DATA_LINK"

# XML documentation
echo "Generating documentation ..."
for i in "$SCRIPT_DIR"/doc/*.html; do
  TARGET_FILE="$WEB"/$(basename "$i" .html).html
  $XSLTPROC --stringparam base "$WEB_BASE" --stringparam page "$(basename $i)" "$SCRIPT_DIR"/xslt/documentation.xsl "$i" > "$TARGET_FILE"
done

# document index
echo "Generating JSON document index ..."
for i in "$SCRIPT_DIR"/data/*/*.xml; do
  b=$(basename "$i" .xml)
  dir=$(basename $(dirname "$i"))
  $XSLTPROC --stringparam filename "$b" --stringparam dirname "$dir" "$SCRIPT_DIR"/xslt/list.xsl "$i"
done | \
jq -R -s 'sub("\n$";"") | split("\n") | { "data": map(split("\t")) }' > "$WEB"/list.json

# XML letters
echo "Generating HTML files of letters ..."
for i in "$SCRIPT_DIR"/data/*; do
  TARGET_DIR="$WEB"/$(basename "$i")
  mkdir -p "$TARGET_DIR"
  for j in "$i"/*.xml; do
    b=$(basename "$j" .xml)
    dir=$(basename $(dirname "$j"))
    TARGET_FILE="$TARGET_DIR"/"$b".html
    $XSLTPROC --stringparam base "$WEB_BASE" --stringparam filename "$b" --stringparam dirname "$dir" "$SCRIPT_DIR"/xslt/letter-full.xsl "$j" > "$TARGET_FILE"
  done
done
