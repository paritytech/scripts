function cargoenvhere {
  dirname="$(basename $(pwd))"
  echo "Cargo as a virtual environment in" "$dirname" "dir"
  docker volume inspect cargo-cache > /dev/null || docker volume create cargo-cache
  docker run --rm -it -w /shellhere/"$dirname" \
                    -v "$(pwd)":/shellhere/"$dirname" \
                    -v cargo-cache:/cache/ \
                    -e CARGO_HOME=/cache/cargo/ \
                    -e SCCACHE_DIR=/cache/sccache/ "$@"
}
