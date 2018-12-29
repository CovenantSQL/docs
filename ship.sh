#!/usr/bin/env bash

# cd website
# rm versions.json
#
# GIT_USER=foreseaz \
# CURRENT_BRANCH=master \
# USE_SSH=true \
# yarn run publish-gh-pages

# ship -v 0.1.0 -u auxten

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

    echo $version
    echo $user

    cd website
    rm versions.json
    yarn run version $version

    GIT_USER=$user \
    CURRENT_BRANCH=master \
    USE_SSH=true \
    yarn run publish-gh-pages

    cd ..
    git add .
    git commit -m "chore(version): bump to $version [$user]"
    git push origin master
}

usage() {
    echo "
Usage: ship [command]
available seba variables:
    COMMIT, VERSION, SHIP_VERSION, IMAGE_NAME, IMAGE_TAR, IMAGE_TAR_GZ
" 1>&2; exit 1;
}

main() {
  command::ship "$@"
}

main "$@"
