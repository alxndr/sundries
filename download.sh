download() { # i'll download $1 and give it back on stdout, using (wget|lynx|php|e?links|lwp-download) and a believable user-agent if possible
  # todo add usage
  # todo add ruby, python, perl
  # todo add UA to anything else?
  UA="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6 (.NET CLR 3.5.30729)"
  if [[ -x "$(which wget 2>/dev/null)" ]]; then
    echo "wget"
    wget -qO - "$1" -U "$UA"
  elif [[ -x "$(which lynx 2>/dev/null)" ]]; then
    echo "lynx"
    lynx -source "$1" -useragent="$UA"
  elif [[ -x "$(which php 2>/dev/null)" && -z "$(php -r 'file_get_contents(\'http://www.google.com/\');' | grep 'failed to open stream')" ]]; then # test URL here needs to be quoted with \'... \" doesn't work
    echo "php"
    php -r 'print file_get_contents("$1",FILE_TEXT,stream_context_create(array("user_agent"=>"$UA")));'
  elif [[ -x "$(which elinks 2>/dev/null)" ]]; then
    echo "elinks"
    elinks -source "$1" 
  elif [[ -x "$(which links 2>/dev/null)" ]]; then
    echo "links"
    links -source "$1" 
  elif [[ -x "$(which lwp-download 2>/dev/null)" ]]; then
    echo "lwp-download"
    lwp-download "$1" -
  else
    echo "ERROR -- couldn't find wget, lynx, php, elinks, links, or lwp-download..."
    echo "(make sure one is executable and discoverable by which)"
    echo "...dying"
    echo
    exit 1
  fi
}

