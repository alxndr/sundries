#!/bin/bash
# view unique active incoming and outgoing connections as reported by netstat -an
netstat -an |
 grep :80 |
  sed 's/:[0-9]*//2' |
   sort |
    uniq 
