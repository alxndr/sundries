#!/bin/bash

# todo add ruby, python, perl

if [[ $# -ne 1 ]]; then
  echo "Usage: $(basename $0) url"
  echo -e "\tDownloads url and spits it out on STDOUT."
  echo -e "\tUses wget, lynx, php, (e?)links, or lwp-download, whichever is available"
  echo -e "\tUser agent defaults to Firefox 3.6; override by setting \$USERAGENT"
  echo
  exit 1
fi

is_available() {
  [[ $# -ne $1 ]] && echo "is_available missing param" && exit 1
  [[ -x "$(which $1 2>/dev/null)" ]] && echo "available"
}

if [[ -z "$USERAGENT" ]]; then
  echo "using default useragent" 1>&2
  USERAGENT="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6 (.NET CLR 3.5.30729)"
fi

if [[ "$(is_available wget)" ]]; then
  echo "using wget" 1>&2
  wget -qO - "$1" -U "$USERAGENT"
elif [[ "$(is_available lynx)" ]]; then
  echo "using lynx" 1>&2
  lynx -source "$1" -useragent="$USERAGENT"
elif [[ "$(is_available php)" && -z "$(php -r 'file_get_contents(\'http://www.google.com/\');' | grep 'failed to open stream')" ]]; then # test URL here needs to be quoted with \'... \" doesn't work
  echo "using php" 1>&2
  php -r 'print file_get_contents("$1",FILE_TEXT,stream_context_create(array("user_agent"=>"$USERAGENT")));'
elif [[ "$(is_available elinks)" ]]; then
  echo "using elinks" 1>&2
  elinks -source "$1"
elif [[ "$(is_available links)" ]]; then
  echo "using links" 1>&2
  links -source "$1" -http.fake-user-agent="$USERAGENT"
elif [[ "$(is_available lwp-download)" ]]; then
  echo "using lwp-download" 1>&2
  lwp-download "$1" -
else
  echo "ERROR -- couldn't find wget, lynx, php, elinks, links, or lwp-download..." 1>&2
  echo "(make sure one is executable and discoverable by which)" 1>&2
  echo "...dying" 1>&2
  echo 1>&2
  exit 1
fi

