#!/usr/bin/env bash

if [[ $1 ]]; 
then
	php -r " print_r(unserialize('$1')); echo \"\\n\";"
else
	STRING=`pbpaste`
	php -r " print_r(unserialize('$STRING')); echo \"\\n\";"
fi
