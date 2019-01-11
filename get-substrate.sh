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
    echo "Hallo2"
	elif [ -f /etc/mandrake-release ]; then
		echo "Mandrake Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
	elif [ -f /etc/debian_version ]; then
		echo "Ubuntu/Debian Linux detected."
		$MAKE_ME_ROOT apt update
		$MAKE_ME_ROOT apt install -y cmake pkg-config libssl-dev git gcc build-essential clang libclang-dev
	else
		echo "Unknown Linux distribution."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
	fi
  echo "Hallo3"
fi

echo "Hallo"
echo "Hallo"
if command -v rustup; then
	rustup update
else
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	source ~/.cargo/env
fi
cargo install --force --git https://github.com/paritytech/substrate subkey
cargo install --force --git https://github.com/paritytech/substrate substrate

f=`mktemp -d`
git clone https://github.com/paritytech/substrate-up $f
cp -a $f/substrate-* ~/.cargo/bin

echo "Run source ~/.cargo/env now to update environment"
