Rust 1.39.0

The current version of cmake is [3.16.0](https://github.com/Kitware/CMake/tree/v3.16.0)

For installation in our images we use the version hosted on github. Check the hash sum taken from the file with [sha256 hashes](https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-SHA-256.txt) and verify the [install script](https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-Linux-x86_64.sh).
If everything is correct, continue to build the image.
```
# download cmake
ADD "https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-Linux-x86_64.sh" cmake.sh
# install cmake
RUN echo "c87dc439a8d6b1b368843c580f0f92770ed641af8ff8fe0b706cfa79eed3ac91 cmake.sh" | sha256sum -c - || exit 1; \
	chmod +x cmake.sh; \
	./cmake.sh --skip-license --prefix=/usr/ --exclude-subdir; \
  	rm cmake.sh

```

For Windows CI

```
choco install cmake --version=3.16.0
```

For macOS

```
brew install cmake
```
