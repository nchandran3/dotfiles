#!/bin/bash

# CONSTANTS
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'


setupNoVPN() {
  unset http_proxy https_proxy ftp_proxy no_proxy

  npm config delete registry

  git config --global user.email 'naveenkchandran@gmail.com'

  python3 -m pip config unset global.index-url
  python3 -m pip config unset search.index

  printf "Unset npm registry config\n"
  printf "Unset pip index url and search index"
  printf "Set git email to naveenkchandran@gmail.com\n\n"
}

setupForVPN() {
  # BLOOMBERG VPN Proxy Settings
  export no_proxy="mirrors.inf.bloomberg.com,cloud-yum-mirrorlist.bdns.bloomberg.com,$no_proxy"

  # NPM / Yarn VPN Config
  registry='https://artprod.dev.bloomberg.com/artifactory/api/npm/npm-repos'
  pipIndexUrl='https://artprod.dev.bloomberg.com/artifactory/api/pypi/bloomberg-pypi/simple'
  pipSearchIndex='https://artprod.dev.bloomberg.com/artifactory/api/pypi/bloomberg-pypi'

  npm config set registry "$registry"

  # Github Config
  git config --global user.email 'nchandran5@bloomberg.net'

  # Python/Pip Config
  python3 -m pip config set global.index-url "$pipIndexUrl"
  python3 -m pip config set search.index "$pipSearchIndex"





  printf "\n======> Modified npm config:\n\n${YELLOW}registry${NC} = $registry\n"
  printf "\n======> Modified git config:\n\n[user]\n\t${YELLOW}email${NC} = nchandran5@bloomberg.net\n"
  printf "\n======> Modified pip config:\n\n${YELLOW}index-url${NC} = $pipIndexUrl\n${YELLOW}search.index${NC} = $pipSearchIndex\n"
}

setupCommonConfig() {
  PROXY_PORT=8888
  PROXY_HOST_NAME='windows-proxy'

  # Add the bb-nodeproxy IP on Windows machine to the hosts file for resolution
  # It is necessary to do this regardless of VPN connection because docker config relies on
  # windows-proxy to be defined
  sudo /home/nchandran5/.local/bin/add-windows-proxy-to-hosts.sh

  export http_proxy="http://$PROXY_HOST_NAME:$PROXY_PORT"
  export https_proxy="$http_proxy"
  export HTTP_PROXY="$http_proxy"
  export HTTPS_PROXY="$http_proxy"
  export ftp_proxy="$http_proxy"

}

printEnvironmentVariables() {
  printf "\n======> Environment Variables\n\n"
  printf "${YELLOW}http_proxy${NC} = $http_proxy \n"
  printf "${YELLOW}https_proxy${NC} = $https_proxy \n"
  printf "${YELLOW}ftp_proxy${NC} = $ftp_proxy \n"
  printf "${YELLOW}no_proxy${NC} = $no_proxy \n"
  printf "\n\n"
}

runningInDocker() {
  grep -q 'docker\|lxc' /proc/1/cgroup
}

runningTmux() {
  [[ "$TERM" =~ "screen".* ]]
}

############################
#         MAIN             #
############################

# Don't run start up script if we're in a docker container, as the container has setup configs already
# Don't run if we're in a tmux session, we've already set our variables for the session
if [[ $1 = "-f" ]] || (! runningInDocker && ! runningTmux); then

  printf "${YELLOW}Configuring for VPN connection\nPress 'n' key within 3 seconds to cancel...${NC}\n"
  isVPN='y'
  read -t 3 -n 1 isVPN

  setupCommonConfig

  if [ "$isVPN" = 'n' ] ; then
    printf "${GREEN}Disconnected from VPN. Unsetting environment variables and configs:${NC}\n\n"
    setupNoVPN
  else
    printf "${GREEN}Connected to VPN. Modifying environment variables and configs:${NC}\n\n"
    setupForVPN
  fi

  printEnvironmentVariables

fi
