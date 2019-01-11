#!/usr/bin/env bash
# ship script for covenantsql docs
# usage: ship -v 0.1.0 -u foreseaz

set -o errexit
set -o pipefail

command::ship() {
    local version=()
    local user=()
    local current_opt=""

    while :; do
        case ${1:-notset} in
            -v|--version)
                current_opt="version"
                ;;
            -u|--user)
                current_opt="user"
                ;;
            notset)
                break
                ;;
            *)
              case ${current_opt} in
                  version)
                      version+=("$1")
                      ;;
                  user)
                      user+=("$1")
                      ;;
              esac
              ;;
        esac
        shift
    done

    # print version and user
    echo $version
    echo $user

    # generate versioned docs
    cd website
    rm versions.json || true
    yarn run version $version

    # publish current docs
    GIT_USER=$user \
    CURRENT_BRANCH=master \
    USE_SSH=true \
    yarn run publish-gh-pages

    # commit and push
    cd ..
    git add .
    git commit -m "chore(publish): published $version docs by [$user]"
    git push origin master
}

usage() {
    echo "
Usage: ship -v <version> -u <user>

Options:
    version: semantic version, e.g. 0.2.0
    user:    username who updates the docs, e.g. forseaz
" 1>&2; exit 1;
}

main() {
    if [[ $# -ne 4 ]]; then
        usage
    fi
    command::ship "$@"
}

main "$@"
