#!/bin/bash

nf=$(grep 'failure' `find data -name 'label'` | wc -l)
ns=$(grep 'success' `find data -name 'label'` | wc -l)

echo "# inputs of success: $ns"
echo "# inputs of failure: $nf"

if [ $ns -gt 1 ]; then
	if [ $nf -gt 1 ]; then
		cd analysis
		make > log 2>&1
	else
		echo "There should be at least two inputs causing a failure."
		exit 0
	fi
else
	echo "There should be at least two inputs leading to a normal termination."
	exit 0
fi
	
if [ ! -f summary.xml ]; then 
	echo "Failed to generate a CBI report. Please see analysis/log."
fi
