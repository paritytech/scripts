#!/usr/bin/env bash

usage(){
  echo "configure-poa.sh <options>"
  echo 
  echo "OPTIONS"
  echo
  echo -e "-g --generate-config PATH \t Generate a config file template"
  echo -e "-c --config PATH \t\t PoA configuration file"
  echo -e "-h --help \t\t Show usage"
  exit
}

generate_config(){
  cat > $CONFIG_TEMPLATE_PATH << EOL
AUTHORITY_ACCOUNT_PHRASE=
AUTHORITY_ACCOUNT_PASSWORD=
GENERATE_ACCOUNT=true
INSTALL_PARITY=false
PARITY_DEB_URL=
CONFIGURE_NETSTATS=false
NETSTATS_INSTALL_PATH=
NETSTATS_WS_SERVER=
NETSTATS_WS_SECRET=
EOL

}

check_var(){
  if [[ -z ${!1} ]]; then
    echo "$1 must be set"
    exit
  fi
}

check_config(){
  check_var AUTHORITY_ACCOUNT_PHRASE
  check_var AUTHORITY_ACCOUNT_PASSWORD
}

install_parity(){
  echo "Installing parity"
  check_var PARITY_DEB_URL
  
  curl -o parity.deb $PARITY_DEB_URL
  sudo dpkg -i parity.deb
}

configure_stats(){
  check_var NETSTATS_WS_SERVER
  check_var NETSTATS_WS_SECRET
  check_var NETSTATS_INSTALL_PATH
  
  cat > stats.json << EOL
[
  {
    "name"              : "stats",
    "cwd"               : "$NETSTATS_INSTALL_PATH",
    "script"            : "app.js",
    "log_date_format"   : "YYYY-MM-DD HH:mm Z",
    "merge_logs"        : false,
    "watch"             : false,
    "max_restarts"      : 10,
    "exec_interpreter"  : "node",
    "exec_mode"         : "fork_mode",
    "env":
    {
      "NODE_ENV"        : "production",
      "RPC_HOST"        : "localhost",
      "RPC_PORT"        : "8545",
      "LISTENING_PORT"  : "30303",
      "INSTANCE_NAME"   : "",
      "CONTACT_DETAILS" : "",
      "WS_SERVER"       : "$NETSTATS_WS_SERVER",
      "WS_SECRET"       : "$NETSTATS_WS_SECRET",
      "VERBOSITY"       : 2
    
    }
  }
]
EOL

	echo "To run netstats, make sure you have nodejs and pm2 installed, then run 'pm2 stats.json'."
}

generate_account(){
  sleep 1
  n=0
  until [ $n -ge 10 ]
  do
    echo "generating account from phrase"
    curl --data "{\"jsonrpc\":\"2.0\",\"method\":\"parity_newAccountFromPhrase\",\"params\":[\"$AUTHORITY_ACCOUNT_PHRASE\", \"$AUTHORITY_ACCOUNT_PASSWORD\"],\"id\":0}" -H "Content-Type: application/json" -X POST localhost:8545 && break 
    n=$[$n+1]
    sleep 1
  done
}

configure_poa(){
  source $CONFIG_PATH
  check_config

  if $INSTALL_PARITY; then
    install_parity
  fi

  sudo apt-get install -y curl

  if $GENERATE_ACCOUNT; then
    parity --chain kovan --jsonrpc-apis parity_accounts &
    generate_account
    kill -9 $!
  fi

  

  if $CONFIGURE_NETSTATS; then
    configure_stats
  fi

  # echo "Run parity on the Kovan network with 'parity --chain kovan'
}

while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -g|--generate-config)
      CONFIG_TEMPLATE_PATH=$2
      shift # past argument
      ;;
    -c|--config)
      CONFIG_PATH=$2
      shift
      ;;
    -h|--help)
      HELP=true
      shift # past argument
      usage
      ;;
    *)
      # unknown option
      echo "Unknown option: $1"
      usage
      ;;
  esac
  shift # past argument or value
done

if [[ -n $CONFIG_TEMPLATE_PATH ]]; then
  generate_config
elif [[ -n $CONFIG_PATH ]]; then
  configure_poa
else
  usage
fi

