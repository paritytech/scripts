if [[ "$OSTYPE" == "linux-gnu" ]]; then
	if [[ `whoami` == "root" ]]; then
		MAKE_ME_ROOT=
	else
		MAKE_ME_ROOT=sudo
	fi

	if [ -f /etc/redhat-release ]; then
		echo "Redhat Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
	elif [ -f /etc/SuSE-release ]; then
		echo "Suse Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
	elif [ -f /etc/arch-release ]; then
		echo "Arch Linux detected."
		$MAKE_ME_ROOT pacman -Sy cmake gcc openssl-1.0 pkgconf git clang
		export OPENSSL_LIB_DIR="/usr/lib/openssl-1.0";
		export OPENSSL_INCLUDE_DIR="/usr/include/openssl-1.0"
	elif [ -f /etc/mandrake-release ]; then
		echo "Mandrake Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
	elif [ -f /etc/debian_version ]; then
		echo "Ubuntu/Debian Linux detected."
		echo "Updating database of available packages ..."
		$MAKE_ME_ROOT apt update
		echo "Upgrading installed packages to newer versions ..."
		$MAKE_ME_ROOT apt upgrade
		echo "Installing clang, CMake, build-essential, GCC, Git, libclang-dev, libssl-dev, pkg-config ..."
		$MAKE_ME_ROOT apt install -y clang cmake build-essential gcc git libclang-dev libssl-dev pkg-config
	else
		echo "Unknown Linux distribution."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
	fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Mac OS (Darwin) detected."

	APP="Xcode Command Line Tools"
	if xcode-select --install 2>&1 | grep "installed"; then
		echo -e "Skipping, $APP already installed";
	else
		echo -e "Installing $APP ...";
		xcode-select --install;
	fi

	APP="Homebrew"
	if brew 2>&1 | grep "command not found"; then
		echo "Installing $APP ..."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		echo -e 'export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"' >> ~/.bash_profile;
		source ~/.bash_profile;
	else
		echo "Updating $APP ..."
		brew doctor --verbose;
		brew update --verbose;
	fi

	APP="RBenv"
	if ! rbenv 2>&1 | grep "command not found"; then
		echo -e "Skipping, $APP already installed";
	else
		echo -e "Installing $APP ...";
		brew install rbenv;
		rbenv init;
		echo -e 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile;
		source ~/.bash_profile;
		echo -e "Installing Ruby latest version: $(rbenv install -l | grep -v - | tail -1)"
		rbenv install $(rbenv install -l | grep -v - | tail -1);
		echo -e "Switching to use Ruby latest version";
		rbenv global $(rbenv install -l | grep -v - | tail -1);
	fi

	APP="Node Version Manager (NVM)"
	if ! nvm 2>&1 | grep "command not found"; then
		echo -e "Skipping, $APP already installed";
	else
		echo -e "Installing $APP ...";
		curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash;
		export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
		echo -e "Installing Node.js latest LTS version";
		nvm install --lts
		echo -e "Switching to use Node.js latest LTS version";
		nvm use --lts;
	fi

	APP="Yarn"
	if ! yarn 2>&1 | grep "command not found"; then
		echo -e "Skipping, $APP already installed";
	else
		echo -e "Installing $APP latest version ...";
		brew install yarn --without-node;
	fi

	APP="Git"
	if ! git 2>&1 | grep "command not found"; then
		echo "Upgrading $APP ..."
		brew upgrade git --verbose
	else
		echo "Installing $APP ..."
		brew install git --verbose
	fi

	APP="Docker"
	if ! docker 2>&1 | grep "command not found"; then
		echo -e "Skipping, $APP already installed";
	else
		echo -e "Installing Homebrew Cask";
		brew tap caskroom/cask;
		echo -e "Installing $APP latest version ...";
		CASKS=(
			docker
		);
		brew cask install --appdir="/Applications" ${CASKS[@]}
	fi

	APP="Cmake"
	if ! cmake 2>&1 | grep "command not found"; then
		echo "Upgrading $APP ..."
		brew upgrade cmake --verbose
	else
		echo "Installing $APP ..."
		brew install cmake --verbose
	fi

	APP="LLVM"
	if ! llvm 2>&1 | grep "command not found"; then
		echo "Upgrading $APP ..."
		brew upgrade llvm --verbose
	else
		echo "Installing $APP ..."
		brew install llvm --verbose
	fi

	APP="OpenSSL"
	if ! openssl 2>&1 | grep "command not found"; then
		echo "Upgrading $APP ..."
		brew upgrade openssl --verbose
	else
		echo "Installing $APP ..."
		brew install openssl --verbose
	fi

	APP="pkg-config"
	if ! pkg-config 2>&1 | grep "command not found"; then
		echo "Upgrading $APP ..."
		brew upgrade pkg-config --verbose
	else
		echo "Installing $APP ..."
		brew install pkg-config --verbose
	fi
elif [[ "$OSTYPE" == "freebsd"* ]]; then
	echo "FreeBSD detected."
	echo "This OS is not supported with this script at present. Sorry."
	echo "Please refer to https://github.com/paritytech/substrate for setup information."
else
	echo "Unknown operating system."
	echo "This OS is not supported with this script at present. Sorry."
	echo "Please refer to https://github.com/paritytech/substrate for setup information."
fi

APP="Rust"
if rustup 2>&1 | grep "command not found"; then
	echo "Installing $APP ..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	source ~/.cargo/env
else
	echo "Updating $APP ..."
	rustup update
fi
echo "Switching to $APP Stable";
rustup default stable;

echo "Installing WASM dependencies"
rustup target add wasm32-unknown-unknown --toolchain nightly;
cargo install --force --git https://github.com/alexcrichton/wasm-gc;
cargo install --force --git https://github.com/pepyakin/wasm-export-table.git;

if which substrate 2>&1 | grep ".cargo/bin/substrate"; then
	EXISTING_SUBSTRATE_VERSION=$(substrate --version)
	echo -e "Substrate version $EXISTING_SUBSTRATE_VERSION detected on host machine"
fi

f=`mktemp -d`
git clone https://github.com/paritytech/substrate-node-template $f
# fetch new tags from remote repo
git fetch --tags
# get latest tag on git repo across all branches
LATEST_SUBSTRATE_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)

read -p "Press 'y' to update to the latest Substrate version $LATEST_SUBSTRATE_TAG >" choice
case $choice in
	[Yy]* )
		echo -e "Updating to the latest Substrate version ...";
		cargo install --force --git https://github.com/paritytech/substrate --tag $LATEST_SUBSTRATE_TAG substrate
		;;
	* )
		;;
esac

echo "Installing latest Subkey version ..."
cargo install --force --git https://github.com/paritytech/substrate --tag $LATEST_SUBSTRATE_TAG subkey


echo "Installing binary executables from https://github.com/paritytech/substrate-up"
f=`mktemp -d`
git clone https://github.com/paritytech/substrate-up $f
cp -a $f/substrate-* ~/.cargo/bin

echo "Run source ~/.cargo/env now to update environment"
