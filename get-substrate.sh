HAD_GIT=false

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	if [[ `whoami` == "root" ]]; then
		MAKE_ME_ROOT=
	else
		MAKE_ME_ROOT=sudo
	fi

	if ! git 2>&1 | grep "command not found"; then
		HAD_GIT=true
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

	if brew 2>&1 | grep "command not found"; then
		echo "Installing Homebrew ..."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo "Updating Homebrew ..."
		brew doctor --verbose;
		brew update --verbose;
	fi

	if ! git 2>&1 | grep "command not found"; then
		HAD_GIT=true
		echo "Upgrading Git ..."
		brew upgrade git --verbose
	else
		echo "Installing Git ..."
		brew install git --verbose
	fi

	if ! cmake 2>&1 | grep "command not found"; then
		echo "Upgrading Cmake ..."
		brew install cmake --verbose
	else
		echo "Installing Cmake ..."
		brew upgrade cmake --verbose
	fi

	if ! llvm 2>&1 | grep "command not found"; then
		echo "Upgrading LLVM ..."
		brew install llvm --verbose
	else
		echo "Installing LLVM ..."
		brew upgrade llvm --verbose
	fi

	if ! openssl 2>&1 | grep "command not found"; then
		echo "Upgrading OpenSSL ..."
		brew install openssl --verbose
	else
		echo "Installing OpenSSL ..."
		brew upgrade openssl --verbose
	fi

	if ! pkg-config 2>&1 | grep "command not found"; then
		echo "Upgrading pkg-config ..."
		brew install pkg-config --verbose
	else
		echo "Installing pkg-config ..."
		brew upgrade pkg-config --verbose
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

if ! $HAD_GIT; then
	echo "Configuring Git"
	APP="Git"
	git config --global color.ui auto;
	echo -e "  Please enter your username for $APP Config:";
	read -p "    Username > " uservar
	echo -e "  Please enter your email for $APP Config:";
	read -p "    Email >" emailvar
	git config --global user.name "$uservar";
	git config --global user.email "$emailvar";
	echo
	echo -e "  $APP Config updated with your credentials";
fi

if rustup 2>&1 | grep "command not found"; then
	echo "Installing Rust ..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	source ~/.cargo/env
else
	echo "Updating Rust ..."
	rustup update
fi

echo "Switching to Rust Stable";
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
