function cargoenvhere {
  dirname="$(basename $(pwd))"
  user=$(whoami)
  echo "Cargo as a virtual environment in" "$dirname" "dir"
  mkdir -p /home/"$user"/cache/"$dirname"
  podman run --rm -it -w /shellhere/"$dirname" \
                      -v "$(pwd)":/shellhere/"$dirname" \
                      -v /home/"$user"/cache/"$dirname"/:/cache/ \
                      -e CARGO_HOME=/cache/cargo/ \
                      -e SCCACHE_DIR=/cache/sccache/ \
                      -e CARGO_TARGET_DIR=/cache/target/ "$@"
}
