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
		echo "Installing apt-utils, clang, CMake, CMake-data, build-essential, GCC, Git, libclang-dev, libclang-3.8-dev libssl-dev, pkg-config ..."
		$MAKE_ME_ROOT apt install -y apt-utils clang cmake cmake-data build-essential gcc git libclang-dev libclang-3.8-dev libssl-dev pkg-config
		echo "Instaling cURL, Node.js"
		$MAKE_ME_ROOT apt install -y curl nodejs
		curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
		sudo apt-get install -y nodejs
		sudo ln -s /usr/bin/nodejs /usr/bin/node;
		echo "Instaling Yarn"
		curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -;
		echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list;
		sudo apt-get update && sudo apt-get install yarn;
		sudo ln -s /usr/bin/yarn /usr/local/bin/yarn;
	else
		echo "Unknown Linux distribution."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
	fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Mac OS (Darwin) detected."

	APP="Xcode Command Line Tools"
	if ! [ -x "$(command -v xcode-select --install)" ]; then
		echo -e "Installing $APP ...";
		xcode-select --install;
	else
		echo -e "Skipping, $APP already installed";
	fi

	APP="Homebrew"
	if ! [ -x "$(command -v brew)" ]; then
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
	if ! [ -x "$(command -v rbenv)" ]; then
		echo -e "Installing $APP ...";
		brew install rbenv;
		rbenv init;
		echo -e 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile;
		source ~/.bash_profile;
		echo -e "Installing Ruby latest version: $(rbenv install -l | grep -v - | tail -1)"
		rbenv install $(rbenv install -l | grep -v - | tail -1);
		echo -e "Switching to use Ruby latest version";
		rbenv global $(rbenv install -l | grep -v - | tail -1);
	else
		echo -e "Skipping, $APP already installed";
	fi

	APP="Node Version Manager (NVM)"
	if ! [ -x "$(command -v nvm)" ]; then
		echo -e "Installing $APP ...";
		curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash;
		export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
		echo -e "Installing Node.js latest LTS version";
		nvm install --lts
		echo -e "Switching to use Node.js latest LTS version";
		nvm use --lts;
	else
		echo -e "Skipping, $APP already installed";
	fi

	APP="Yarn"
	if ! [ -x "$(command -v yarn)" ]; then
		echo -e "Installing $APP latest version ...";
		brew install yarn --without-node;
	else
		echo -e "Skipping, $APP already installed";
	fi

	APP="Git"
	if ! [ -x "$(command -v git)" ]; then
		echo "Installing $APP ..."
		brew install git --verbose
	else
		echo "Upgrading $APP ..."
		brew upgrade git --verbose
	fi

	APP="Docker"
	if ! [ -x "$(command -v docker)" ]; then
		echo -e "Installing Homebrew Cask";
		brew tap caskroom/cask;
		echo -e "Installing $APP latest version ...";
		CASKS=(
			docker
		);
		brew cask install --appdir="/Applications" ${CASKS[@]}
	else
		echo -e "Skipping, $APP already installed";
	fi

	APP="Cmake"
	if ! [ -x "$(command -v cmake)" ]; then
		echo "Installing $APP ..."
		brew install cmake --verbose
	else
		echo "Upgrading $APP ..."
		brew upgrade cmake --verbose
	fi

	APP="LLVM"
	if ! [ -x "$(command -v llvm)" ]; then
		echo "Installing $APP ..."
		brew install llvm --verbose
	else
		echo "Upgrading $APP ..."
		brew upgrade llvm --verbose
	fi

	APP="OpenSSL"
	if ! [ -x "$(command -v openssl)" ]; then
		echo "Installing $APP ..."
		brew install openssl --verbose
	else
		echo "Upgrading $APP ..."
		brew upgrade openssl --verbose
	fi

	APP="pkg-config"
	if ! [ -x "$(command -v pkg-config)" ]; then
		echo "Installing $APP ..."
		brew install pkg-config --verbose
	else
		echo "Upgrading $APP ..."
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

APP="Rust"
if ! [ -x "$(command -v rustup)" ]; then
	echo "Installing $APP ..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y;
	source ~/.cargo/env
else
	echo "Updating $APP ..."
	rustup update
fi
rustup install nightly
echo "Switching to $APP Stable";
rustup default stable;

echo "Installing WASM dependencies"
rustup target add wasm32-unknown-unknown --toolchain nightly;
cargo install --force --git https://github.com/alexcrichton/wasm-gc;
cargo install --force --git https://github.com/pepyakin/wasm-export-table.git;

if [ -x "$(command -v substrate)" ]; then
	EXISTING_SUBSTRATE_VERSION=$(substrate --version)
	echo -e "Substrate version $EXISTING_SUBSTRATE_VERSION detected on host machine"
fi

f=`mktemp -d`
echo -e "Cloning the Substrate repository into a temporary directory"
cd $f
git clone https://github.com/paritytech/substrate
cd substrate
# Fetch all new tags from the Substrate remote repo
git fetch --tags
# Get just the latest tag from the Substrate git repo across all branches
LATEST_SUBSTRATE_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
SUBSTRATE_TAGS=",$(git tag | tr '\n' ',' | sed 's/.$//')"
echo -e "Substrate versions currently available: \n\n"
git tag
REQUEST="Press 'y' to update to the latest Substrate version $LATEST_SUBSTRATE_TAG
or specify a version number (i.e. 'v0.x.x') > "

choose_version () {
  while true; do
		echo
		read -p "$REQUEST" CHOICE

		case $CHOICE in
			[Yy]* )
				echo -e "Updating to the latest Substrate version $LATEST_SUBSTRATE_TAG ...";
				cargo install --force --git https://github.com/paritytech/substrate --tag $LATEST_SUBSTRATE_TAG substrate

				echo -e "Installing Subkey ..."
				cargo install --force --git https://github.com/paritytech/substrate subkey

				return 1
				;;
			* )
				if [[ -n "$CHOICE" ]] && [[ $SUBSTRATE_TAGS =~ (^|,)"$CHOICE"(,|$) ]]; then
					echo -e "Updating to specific Substrate version $CHOICE ...";
					cargo install --force --git https://github.com/paritytech/substrate --tag $CHOICE substrate

					echo -e "Installing Subkey ..."
					cargo install --force --git https://github.com/paritytech/substrate subkey

					return 1
				fi

				echo
				echo -e "Try again. Invalid input"
				;;
		esac

  done
}

choose_version

echo "Installing binary executables from https://github.com/paritytech/substrate-up"
f=`mktemp -d`
git clone https://github.com/paritytech/substrate-up $f
cp -a $f/substrate-* ~/.cargo/bin

NEW_SUBSTRATE_VERSION=$(substrate --version)
echo -e "Finished installing Substrate version: $NEW_SUBSTRATE_VERSION\n"
echo "Run \`source ~/.cargo/env\` now to update environment"
