#!/bin/bash
set -e

tags=(latest mainline stable alpine mainline-alpine stable-alpine)

render() {
  sedStr="s!%%NGINX_VERSION%%!$1!g;"
  sed -r "$sedStr" $2
}

generate() {
  local versions=$@
  echo "Rendering canonical builds..."

  for version in ${versions[*]}; do
    local context="versions/canonicals/$version"
    echo
    echo " ==> Genetating nginx:$version build..."

    # If exist, skip
    if [ -d "$context" ]; then
      echo " ==> [Skip] Template for nginx:$version already exists!"
      continue;
    fi

    mkdir -p "$context"
    cp -r rootfs "$context"
    render $version Dockerfile.template > "$context/Dockerfile"
    echo " ==> [Done] nginx:$version generated!"
  done
}

generate ${tags[@]}
