#!/bin/bash
set -e

tags=(latest mainline alpine)
vers=(1.21 1.21.3 1.21-alpine 1.21.3-alpine)

render() {
  sedStr="s!%%NGINX_VERSION%%!$1!g;"
  sed -r "$sedStr" $2
}

generate() {
  local versions=$@
  for version in ${versions[*]}; do
    echo "Genetating nginx:$version"
    # If exist, cleanup
    if [ -d "builds/$version" ]; then
      rm -rf "builds/$version";
    fi

    mkdir -p "builds/$version"
    # cp -r rootfs "builds/$version"
    render $version Dockerfile.template > "builds/$version/Dockerfile"
  done
}

generate ${tags[@]}
generate ${vers[@]}
