#!/bin/bash

# AUTHOR: p31d4

CHALLENGE=
ARCH=
ZIP_FILE=

VALID_CHALLENGES="ret2win split callme write4 badchars fluff pivot ret2csu"
VALID_ARCHS="x86_64 x86 armv5 mipsel"

usage()
{
    if [ "${1}" = "bad_challenge" ]; then
        echo -e "\n[ERROR] INVALID CHALLENGE"
    fi

    if [ "${1}" = "bad_arch" ]; then
        echo -e "\n[ERROR] INVALID ARCHITECTURE"
    fi

    echo ""
    echo "Usage: get_challenge.sh [ -c | --challenge ] CHALLENGE"
    echo "                        [ -a | --arch ] ARCH"
    echo ""
    echo "Challenges:      ret2win; split; callme; write4;"
    echo "                 badchars; fluff; pivot; ret2csu"
    echo ""
    echo "Architectures:   x86_64; x86; armv5; mipsel"
    echo ""
    echo "Examples:        get_challenge.sh -c fluff -a armv5"
    echo "                 get_challenge.sh --challenge ret2csu --arch x86_64"

    exit 1
}

check_challenge()
{
    if [[ -z "${1}" ]]; then
       echo "[ERROR] Please provide a valid challenge name!"
       usage
    fi

    [[ ${VALID_CHALLENGES} =~ (^|[[:space:]])${1}($|[[:space:]]) ]] || \
	    usage "bad_challenge"

    ZIP_FILE="${CHALLENGE}"
}

check_arch()
{
    if [[ -z "${ARCH}" ]]; then
       echo "[ERROR] Please provide a valid architecture!"
       usage
    fi

    echo ${VALID_ARCHS} | grep -w -q ${1}

    if [ "$?" != "0" ]; then
        usage "bad_arch"
    fi


    if [ "${ARCH}" = "x86" ]; then
        ZIP_FILE="${ZIP_FILE}32.zip"
    elif [ "${ARCH}" = "armv5" ]; then
        ZIP_FILE="${ZIP_FILE}_armv5.zip"
    elif [ "${ARCH}" = "mipsel" ]; then
        ZIP_FILE="${ZIP_FILE}_mipsel.zip"
    else
        ZIP_FILE="${ZIP_FILE}.zip"
    fi

}

OPTS=$(getopt -n ${0} -o c:a: --long challenge:,arch: -- "$@")
if [ "$?" != "0" ]; then
  usage
fi

echo $OPTS

eval set -- "$OPTS"

while true; do
  case "$1" in
    -c | --challenge)
      CHALLENGE=${2}
      shift 2
      ;;
    -a | --arch)
      ARCH=${2}
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "[ERROR] Internal error!"
      exit 1
      ;;
  esac
done

check_challenge ${CHALLENGE}
check_arch ${ARCH}

if [ "${CHALLENGE}" = "ret2csu" ] && [ "${ARCH}" = "x86" ]; then
    echo "[ERROR] The challenge ret2csu is not available for the x86 architecture!"
    exit 1
fi

mkdir -p ${CHALLENGE}/${ARCH}
echo "[INFO] Downloading ${ZIP_FILE} ..."
curl https://ropemporium.com/binary/${ZIP_FILE} --output ${CHALLENGE}/${ARCH}/${ZIP_FILE}
cd ${CHALLENGE}/${ARCH}
unzip ${ZIP_FILE}
rm ${ZIP_FILE}
