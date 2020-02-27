# DockerHub's official https://hub.docker.com/_/rust
FROM parity/rust-builder:latest

# install tools and dependencies
RUN apt -y update; apt -y install curl
RUN mkdir actions-runner
WORKDIR actions-runner
RUN curl -O -L https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb; \
  dpkg -i packages-microsoft-prod.deb; \
# add-apt-repository universe; \
  apt -y update; \
  apt -y install apt-transport-https; \
  apt -y update; \
  apt -y install dotnet-runtime-3.1

RUN curl -O -L https://github.com/actions/runner/releases/download/v2.165.2/actions-runner-linux-x64-2.165.2.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.165.2.tar.gz
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
