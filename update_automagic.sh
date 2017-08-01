#!/bin/bash
VERSION=$1

function usage {
    echo -e "
    USAGE EXAMPLES:

        ./$(basename $0) 0.8.7
        ./$(basename $0) 0.9.2
    "
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

EXISTING_CONSUL_VERSION=$(consul version | head -n1 | sed -e 's/Consul//gI' -e 's/v//gI' -e 's/[[:space:]]//g')

if [ "${EXISTING_CONSUL_VERSION}" != "${VERSION}" ]; then
    echo "-) You are trying to update this script for consul ${VERSION} while you have"
    echo "   consul ${EXISTING_CONSUL_VERSION} installed at $(which consul)."
    echo "   Please update your local consul before using this script."
    exit 1
fi

echo "+) Acquiring consul-${VERSION}"
wget https://github.com/hashicorp/consul/archive/v${VERSION}.tar.gz

echo "+) Extracting consul-${VERSION}.tar.gz"
tar zxf v${VERSION}.tar.gz

echo "+) Running update_commands.rb"
./update_commands.rb

echo "+) Updating the badge in the README.md"
sed -i "/img.shields.io/c\[\![](https://img.shields.io/badge/Supports%20Consul%20Version-%3E%3D${VERSION}-blue.svg)](https://github.com/hashicorp/consul/blob/v${VERSION}/CHANGELOG.md)" README.md

echo "+) Cleaning up after ourselves"
rm -f v${VERSION}.tar.gz
rm -rf consul-${VERSION}

git status
