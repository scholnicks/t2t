#!/bin/bash

for filename in `ls /Users/scholnick/perl/t2t/test/*.sh | grep -v alltests.sh | sort`
do
	bash $filename
done

exit 0
