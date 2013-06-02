#!/bin/bash

echo -n "TestUnit Tests - "

/Users/scholnick/perl/t2t/test/runTests.pl > /dev/null 2>&1

if [ $? == 0 ]; then
  echo "Success"
  returnCode=0
else
  echo "Failure"
  echo $results
  returnCode=1
fi

exit $returnCode
