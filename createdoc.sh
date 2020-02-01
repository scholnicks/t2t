#!/bin/bash

# simple shell script to generate the man page
# ant just calls this script instead of trying to use ant's exec

html2pod manual.html | grep -v "^#" | pod2man -name "T2T" > t2t.1
exit 0
