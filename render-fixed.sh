#!/bin/bash
set -e

# v1.21
version_1_21=(
  "1.21.3"
  "1.21.4"
  "1.21.5"
  "1.21.6"
)

# v1.22
version_1_22=(
  "1.22.0"
)

# v1.23
version_1_23=(
  "1.23.0"
  "1.23.1"
)

supported_versions=(
  # "${version_1_21[@]}"
  "${version_1_22[@]}"
  "${version_1_23[@]}"
)

# S6_OVERLAY_VERSION=v2.2.0.1 # v1.21
S6_OVERLAY_VERSION=v3.1.1.2 # v1.22, v1.23

render() {
  sedStr=""
  sedStr+="s!%%S6_NGINX_VERSION%%!$1!g;"
  sedStr+="s!%%S6_OVERLAY_VERSION%%!$2!g;"

  sed -r "$sedStr" Dockerfile.template
}

render_readme() {
  sedStr=""
  sedStr+="s!%%S6_NGINX_VERSION%%!$1!g;"
  sedStr+="s!%%S6_OVERLAY_VERSION%%!$2!g;"

  sed -r "$sedStr" README.template.md
}

generate() {
  local versions=$@
  echo "Rendering fixed builds..."

  for version in ${versions[*]}; do
    local context="versions/fixed/${version}"
    echo
    echo " ==> Genetating nginx:${version} build..."

    # If exist, skip
    if [ -d "$context" ]; then
      echo " ==> [Skip] Template for nginx:${version} already exists!"
      continue;
    fi

    mkdir -p "$context"
    cp -r rootfs "$context"

    echo " [+] Generating Dockerfile"
    render_readme "${version}" "${S6_OVERLAY_VERSION}" > "$context/README.md"

    echo " [+] Generating README.md"
    render ${version} "${S6_OVERLAY_VERSION}" > "$context/Dockerfile"

    echo " [+] [Done] nginx:${version} generated!"
  done
}

generate_alpine() {
  local versions=$@
  for version in ${versions[*]}; do
    local ver=${version}-alpine
    local context="versions/fixed/$ver"
    echo " ==> Genetating nginx:$ver build..."

    # If exist, skip
    if [ -d "$context" ]; then
      echo " ==> [Skip] Template for nginx:$ver already exists!"
      echo
      continue;
    fi

    mkdir -p "$context"
    cp -r rootfs "$context"

    echo " [+] Generating Dockerfile"
    render_readme "$ver" "${S6_OVERLAY_VERSION}" > "$context/README.md"

    echo " [+] Generating README.md"
    render "$ver" "${S6_OVERLAY_VERSION}" > "$context/Dockerfile"

    echo " [+] [Done] nginx:$ver generated!"
    echo
  done
}

if [[ -z "${supported_versions[@]}" ]]; then
    echo "Please specify versions to render."
    exit 1
fi

generate ${supported_versions[@]}
generate_alpine ${supported_versions[@]}
