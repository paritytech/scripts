# Clean Ubuntu with UI
This container is no more than Ubuntu 18.10 with X-server on board.
It uses Your local **X-server (!)** to render UI from the container.

Created mainly as clean/reproduceable env for testing apps with UI.

Controllable from console you've launched it, same as every Docker instance.

### Example:
**Launch:**

`$ ./x11_docker.sh`

Once you get into contaner's bash, go install something:

`# curl -O -L -C - https://github.com/paritytech/fether/releases/download/v0.1.0-alpha/fether_0.1.0_amd64.deb`

`# apt-get install ./fether_0.1.0_amd64.deb -y`

Then you can run:

`# fether`

And observe the new window with Fether in your host system.
