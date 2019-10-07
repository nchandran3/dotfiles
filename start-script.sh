#!/bin/bash

# CONSTANTS
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'


setupNoVPN() {
  unset http_proxy https_proxy ftp_proxy no_proxy

  npm config delete registry
  npm config delete proxy
  npm config delete https-proxy

  git config --global --unset http.https://github.com.proxy
  git config --global --unset http.https://github.com.sslCAInfo
  git config --global user.email 'naveenkchandran@gmail.com'

  pip config unset global.index-url
  pip config unset search.index

  printf "Unset npm configs: registry, proxy, https-proxy\n"
  printf "Unset git proxy config and sslCAInfo\n"
  printf "Unset pip index url and search index"
  printf "Set git email to naveenkchandran@gmail.com\n\n"
}

setupForVPN() {
  # BLOOMBERG VPN Proxy Settings
  export no_proxy="mirrors.inf.bloomberg.com,cloud-yum-mirrorlist.bdns.bloomberg.com,$no_proxy"
  export CURL_CA_BUNDLE="${HOME}/WINDOWS/bb-certs/BBrootNEW.cer"

  # NPM / Yarn VPN Config
  npmProxy='http://bproxy.tdmz1.bloomberg.com'
  registry='https://artprod.dev.bloomberg.com/artifactory/api/npm/npm-repos'
  pipIndexUrl='https://artprod.dev.bloomberg.com/artifactory/api/pypi/bloomberg-pypi'
  pipSearchIndex='https://artprod.dev.bloomberg.com/artifactory/api/pypi/bloomberg-pypi'

  npm config set registry "$registry"
  npm config set proxy "$npmProxy"
  npm config set https-proxy "$npmProxy"

  # Github Config
  git config --global http.https://github.com.proxy 'http://proxy.bloomberg.com:81'
  git config --global http.https://github.com.sslCAInfo "~/WINDOWS/bb-certs/BBrootNEW.cer"
  git config --global user.email 'nchandran5@bloomberg.net'

  # Python/Pip Config
  pip config set global.index-url "$pipIndexUrl"
  pip config set search.index "$pipSearchIndex"





  printf "\n======> Modified npm config:\n\n${YELLOW}registry${NC} = $registry\n${YELLOW}proxy, https-proxy${NC} = $npmProxy\n"
  printf "\n======> Modified git config:\n\n[http https://github.com]\n\t${YELLOW}proxy${NC} = http://proxy.bloomberg.com:81\n[user]\n\t${YELLOW}email${NC} = nchandran5@bloomberg.net\n"
  printf "\n======> Modified pip config:\n\n${YELLOW}index-url${NC} = $pipIndexUrl\n${YELLOW}search.index${NC} = $pipSearchIndex\n"
}

setupCommonConfig() {
  # Add the bb-nodeproxy IP on Windows machine to the hosts file for resolution
  # It is necessary to do this regardless of VPN connection because docker config relies on 
  # windows-host to be defined
  PROXY_IP="$(tail -1 /etc/resolv.conf | cut -d' ' -f2)"
  PROXY_PORT=8888
  PROXY_HOST_NAME='windows-proxy'

  # remove existing entry and replace with new
  sudo sed -i "s/^.*$PROXY_HOST_NAME.*$//" /etc/hosts
  echo "$PROXY_IP $PROXY_HOST_NAME" | sudo tee -a /etc/hosts > /dev/null

  export http_proxy="http://$PROXY_HOST_NAME:$PROXY_PORT"
  export https_proxy="$http_proxy"
  export ftp_proxy="$http_proxy"

  printf "\n======> Added windows-proxy at ${YELLOW}${PROXY_IP}${NC} to /etc/hosts file\n"
}

printEnvironmentVariables() {
  printf "\n======> Environment Variables\n\n"
  printf "${YELLOW}http_proxy${NC} = $http_proxy \n"
  printf "${YELLOW}https_proxy${NC} = $https_proxy \n"
  printf "${YELLOW}ftp_proxy${NC} = $ftp_proxy \n"
  printf "${YELLOW}no_proxy${NC} = $no_proxy \n"
  printf "${YELLOW}CURL_CA_BUNDLE${NC} = $CURL_CA_BUNDLE \n"
  printf "\n\n"
}

runningInDocker() {
  grep -q 'docker\|lxc' /proc/1/cgroup 
}

############################
#         MAIN             #
############################

# Don't run start up script if we're in a docker container, as the container has setup configs already
if ! runningInDocker; then  

  printf "${YELLOW}Configuring for VPN connection\nPress any key within 3 seconds to cancel...${NC}\n"
  isVPN='y'
  read -t 3 -n 1 isVPN

  setupCommonConfig

  if [ "$isVPN" != "y" ] ; then
    printf "${GREEN}Disconnected from VPN. Unsetting environment variables and configs:${NC}\n\n"
    setupNoVPN
  else
    printf "${GREEN}Connected to VPN. Modifying environment variables and configs:${NC}\n\n"
    setupForVPN
  fi

  printEnvironmentVariables

  # start docker service at startup
  sudo service docker start

fi
