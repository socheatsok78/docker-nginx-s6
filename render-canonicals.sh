#!/bin/bash
set -e

tags=(latest mainline stable alpine mainline-alpine stable-alpine)
version_tags=(
  # "1.21"
  # "1.21-alpine"
  "1.22"
  "1.22-alpine"
  "1.23"
  "1.23-alpine"
)

supported_versions=(
  "${tags[@]}"
  "${version_tags[@]}"
)

S6_OVERLAY_VERSION=v3.1.1.2
force=false

render() {
  sedStr=""
  sedStr+="s!%%NGINX_VERSION%%!$1!g;"
  sedStr+="s!%%S6_OVERLAY_VERSION%%!$2!g;"

  sed -r "$sedStr" Dockerfile.template
}

render_readme() {
    sedStr=""
    sedStr+="s!%%NGINX_VERSION%%!$1!g;"
    sedStr+="s!%%S6_OVERLAY_VERSION%%!$2!g;"

    sed -r "$sedStr" README.template.md
}

generate() {
  local versions=$@
  echo "Rendering canonical builds..."

  for version in ${versions[*]}; do
    local context="versions/canonicals/$version"

    echo

    if [[ "${force}" == "true" ]]; then
      echo " ==> Removing nginx:$version template..."
      rm -rf "$context"
    fi

    echo " ==> Genetating nginx:$version build..."

    # If exist, skip
    if [ -d "$context" ]; then
      echo " ==> [Skip] Template for nginx:$version already exists!"
      continue;
    fi

    mkdir -p "$context"
    cp -r rootfs "$context"

    echo " [+] Generating Dockerfile"
    render_readme "${version}" "${S6_OVERLAY_VERSION}" > "$context/README.md"

    echo " [+] Generating README.md"
    render "${version}" "${S6_OVERLAY_VERSION}" > "$context/Dockerfile"

    echo " [+] [Done] nginx:$version generated!"
  done
}

if [[ "${1}" == "--force" ]]; then
  force=true
  shift
fi

generate ${supported_versions[@]}
