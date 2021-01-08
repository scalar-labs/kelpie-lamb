#!/bin/bash

LAMB_CONFIG="/lamb/lamb_config.toml"
CONTRACT_CONFIG="/lamb/contract_config.json"
VARIABLE_CONFIG="/lamb/variable_config.json"
OPT=""

if [ ! -f "${LAMB_CONFIG}" ] \
  || [ ! -f "${CONTRACT_CONFIG}" ] \
  || [ ! -f "${VARIABLE_CONFIG}" ]; then
  echo "ERROR: LAMB_CONFIG, CONTRACT_CONFIG and VARIABLE_CONFIG are required"
  exit 1
fi

if ${EXCEPT_PRE}; then
  OPT="--except-pre"
fi

if ${ONLY_PRE}; then
  OPT="--only-pre"
fi

cd /lamb
kelpie --config ${LAMB_CONFIG} ${OPT}
