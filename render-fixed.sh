#!/bin/bash
set -e

supported_versions=(
  "1.21.3"
  "1.21.4"
  "1.21.5"
  "1.21.6"
)

render() {
  sedStr="s!%%NGINX_VERSION%%!$1!g;"
  sed -r "$sedStr" $2
}

generate() {
  local versions=$@
  echo "Rendering fixed builds..."

  for version in ${versions[*]}; do
    local context="versions/fixed/${version}"
    echo
    echo " ==> Genetating nginx:${version} build..."

    If exist, skip
    if [ -d "$context" ]; then
      echo " ==> [Skip] Template for nginx:${version} already exists!"
      continue;
    fi

    mkdir -p "$context"
    cp -r rootfs "$context"
    render ${version} Dockerfile.template > "$context/Dockerfile"
    echo " ==> [Done] nginx:${version} generated!"
  done
}

generate_alpine() {
  local versions=$@
  for version in ${versions[*]}; do
    local ver=${version}-alpine
    local context="versions/fixed/$ver"
    echo " ==> Genetating nginx:$ver build..."

    If exist, skip
    if [ -d "$context" ]; then
      echo " ==> [Skip] Template for nginx:$ver already exists!"
      echo
      continue;
    fi

    mkdir -p "$context"
    cp -r rootfs "$context"
    render $ver Dockerfile.template > "$context/Dockerfile"
    echo " ==> [Done] nginx:$ver generated!"
    echo
  done
}

if [[ -z "${supported_versions[@]}" ]]; then
    echo "Please specify versions to render."
    exit 1
fi

generate ${supported_versions[@]}
generate_alpine ${supported_versions[@]}
