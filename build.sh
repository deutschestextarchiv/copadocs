#!/bin/bash

###########
# CONFIGURATION
#
# website base URL
WEB_BASE="/copadocs/"
# END OF CONFIGURATION

# debugging
[ -n "$DEBUG" ] && set -x

# directory of this script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# web target directory
WEB="$SCRIPT_DIR"/web

# path to and options for Saxon XSLT processor
SAXONB="saxonb-xslt -ext:on"

# XML documentation
for i in $SCRIPT_DIR/doc/*.html; do
  TARGET_FILE="$WEB"/`basename $i .html`.html
  $SAXONB -s:"$i" -xsl:"$SCRIPT_DIR"/xslt/documentation.xsl base="$WEB_BASE" page="`basename $i`" > "$TARGET_FILE"
done

# XML letters
for i in $SCRIPT_DIR/data/*; do
  TARGET_DIR="$WEB"/`basename "$i"`
  mkdir -p "$TARGET_DIR"
  for j in "$i"/*.xml; do
    TARGET_FILE="$TARGET_DIR"/`basename $j .xml`.html
    if [ "$TARGET_FILE" -ot "$j" ]; then
      $SAXONB -s:"$j" -xsl:"$SCRIPT_DIR"/xslt/letter-full.xsl base="$WEB_BASE" > "$TARGET_FILE"
    fi
  done
done
