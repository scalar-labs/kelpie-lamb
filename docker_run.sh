#!/bin/bash

lamb_config=""
contract_config=""
variable_config=""
population_contract=""
target_contract=""
except_pre=false
only_pre=false

usage_exit() {
  echo "Usage: $0 -l|--lamb-config LAMB_CONFIG -c|--contract-config CONTRACT_CONFIG -v|--variable-config VARIABLE_CONFIG -p|--population-contract POPULATION_CONTRACT -t|--target-contract TARGET_CONTRACT [-e|--except-pre] [-o|--only-pre]" 1>&2
  exit 1
}

<<<<<<< HEAD
get_absolute_path() {
  local file="${1}"
  local dir=$(cd $(dirname ${file}); pwd)
  local name=$(basename ${file})

  echo "${dir}/${name}"
}

while [ $# -gt 0 ]; do
  case ${1} in
    -l | --lamb-config)
      lamb_config=$(get_absolute_path "${2}")
      shift 2
      ;;
    -c | --contract-config)
      contract_config=$(get_absolute_path "${2}")
      shift 2
      ;;
    -v | --variable-config)
      variable_config=$(get_absolute_path "${2}")
      shift 2
      ;;
    -p | --population-contract)
      population_contract=$(get_absolute_path "${2}")
      shift 2
      ;;
    -t | --target-contract)
      target_contract=$(get_absolute_path "${2}")
=======
while [ $# -gt 0 ]; do
  case ${1} in
    -l | --lamb-config)
      lamb_config="${2}"
      shift 2
      ;;
    -c | --contract-config)
      contract_config="${2}"
      shift 2
      ;;
    -v | --variable-config)
      variable_config="${2}"
      shift 2
      ;;
    -p | --population-contract)
      population_contract="${2}"
      shift 2
      ;;
    -t | --target-contract)
      target_contract="${2}"
>>>>>>> 750d3d9 (copy files and update docker_run.sh)
      shift 2
      ;;
    -e | --except-pre)
      except_pre=true
      shift 1
      ;;
    -o | --only-pre)
      only_pre=true
      shift 1
      ;;
    *)
      usage_exit
      ;;
  esac
done

for config in "${lamb_config}" "${contract_config}" "${variable_config}"; do
  if [ -z "${config}" ]; then
    echo "--lamb-config, --contract-config and --variable-config should be specified"
    exit 1
  fi
done

if ${except_pre} && ${only_pre}; then
    echo "--except-pre and --only-pre are exclusive"
    exit 1
fi

docker run \
  -v ${lamb_config}:/lamb/lamb_config.toml \
  -v ${contract_config}:/lamb/contract_config.json \
  -v ${variable_config}:/lamb/variable_config.json \
  -v ${population_contract}:/lamb/$(basename ${population_contract}) \
  -v ${target_contract}:/lamb/$(basename ${target_contract}) \
  -e EXCEPT_PRE=${except_pre} \
  -e ONLY_PRE=${only_pre} \
  ghcr.io/scalar-labs/kelpie-lamb
