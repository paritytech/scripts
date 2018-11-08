if [[ "$OSTYPE" == "linux-gnu" ]]; then
        if [ -f /etc/redhat-release ] ; then
		echo "Redhat Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
        elif [ -f /etc/SuSE-release ] ; then
		echo "Suse Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
        elif [ -f /etc/arch-release ] ; then
		echo "Arch Linux detected."
		if [[ `whoami` == "root" ]]
		then
			pacman -S cmake gcc openssl-1.0 pkgconf git
		else
			sudo pacman -S cmake gcc openssl-1.0 pkgconf git
		fi
		export OPENSSL_LIB_DIR="/usr/lib/openssl-1.0";
    		export OPENSSL_INCLUDE_DIR="/usr/include/openssl-1.0"
        elif [ -f /etc/mandrake-release ] ; then
		echo "Mandrake Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
        elif [ -f /etc/debian_version ] ; then
		echo "Ubuntu/Debian Linux detected."
		if [[ `whoami` == "root" ]]
		then
			apt install -y cmake pkg-config libssl-dev git gcc build-essential
		else
			sudo apt install -y cmake pkg-config libssl-dev git gcc build-essential
		fi
	else
		echo "Unknown Linux distribution."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
        fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Mac OS (Darwin) detected."

	if ! which brew >/dev/null 2>&1
	then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	brew install openssl cmake
elif [[ "$OSTYPE" == "freebsd"* ]]; then
	echo "FreeBSD detected."
	echo "This OS is not supported with this script at present. Sorry."
	echo "Please refer to https://github.com/paritytech/substrate for setup information."
else
	echo "Unknown operating system."
	echo "This OS is not supported with this script at present. Sorry."
	echo "Please refer to https://github.com/paritytech/substrate for setup information."
fi

if ! which rustup >/dev/null 2>&1; then
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	source ~/.cargo/env
else
	rustup update
fi
cargo install --git https://github.com/paritytech/substrate subkey
cargo install --git https://github.com/paritytech/substrate substrate

f=`mktemp -d`
git clone https://github.com/paritytech/substrate-up $f
cp -a $f/substrate-* ~/.cargo/bin

echo "Run source ~/.cargo/env now to update environment"
