#!/bin/bash
set -e

tags=(latest mainline stable alpine mainline-alpine stable-alpine)
vers=$@

render() {
  sedStr="s!%%NGINX_VERSION%%!$1!g;"
  sed -r "$sedStr" $2
}

generate() {
  local versions=$@
  for version in ${versions[*]}; do
    echo " ==> Genetating nginx:$version build..."

    # If exist, skip
    if [ -d "builds/$version" ]; then
      echo " ==> [Skip] Template for nginx:$version already exists!"
      echo
      continue;
    fi

    mkdir -p "builds/$version"
    # cp -r rootfs "builds/$version"
    render $version Dockerfile.template > "builds/$version/Dockerfile"
    echo " ==> [Done] nginx:$version generated!"
    echo
  done
}

generate_alpine() {
  local versions=$@
  for version in ${versions[*]}; do
    local ver=$version-alpine
    echo " ==> Genetating nginx:$ver build..."

    # If exist, skip
    if [ -d "builds/$ver" ]; then
      echo " ==> [Skip] Template for nginx:$ver already exists!"
      echo
      continue;
    fi

    mkdir -p "builds/$ver"
    cp -r rootfs "builds/$version"
    render $ver Dockerfile.template > "builds/$ver/Dockerfile"
    echo " ==> [Done] nginx:$ver generated!"
    echo
  done
}

generate ${tags[@]}

generate ${vers[@]}
generate_alpine ${vers[@]}
