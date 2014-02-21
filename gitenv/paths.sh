#!/bin/bash

# Copyright (c) 2013, Ruslan Baratov
# All rights reserved.

# Load some extra paths and scripts from GITENV_ROOT
# Note: This file is sourced from bashrc

if [ -n "${GITENV_ROOT}" ];
then
  if [ -r "${GITENV_ROOT}/git/contrib/completion/git-completion.bash" ];
  then
    echo "[gitenv] add git-completion.bash"
    source "${GITENV_ROOT}/git/contrib/completion/git-completion.bash"
  fi

  if [ -r "${GITENV_ROOT}/sugar/cmake/Sugar" ];
  then
    export SUGAR_ROOT="${GITENV_ROOT}/sugar"
    echo "[gitenv] set SUGAR_ROOT to '${SUGAR_ROOT}'"
    if [ -r "${SUGAR_ROOT}/python" ];
    then
      echo "[gitenv] add '${SUGAR_ROOT}/python' directory to PATH"
      export PATH="${SUGAR_ROOT}/python":${PATH}
    fi
  fi

  if [ -r "${GITENV_ROOT}/polly/utilities/polly_common.cmake" ];
  then
    export POLLY_ROOT="${GITENV_ROOT}/polly"
    echo "[gitenv] set POLLY_ROOT to '${POLLY_ROOT}'"
  fi

  if [ -r "${GITENV_ROOT}/hunter/Source/cmake/Hunter" ];
  then
    export HUNTER_ROOT="${GITENV_ROOT}/hunter"
    echo "[gitenv] set HUNTER_ROOT to '${HUNTER_ROOT}'"
  fi

  if [ -r "${GITENV_ROOT}/llvm/_install/bin/clang" ];
  then
    echo "[gitenv] add '${GITENV_ROOT}/llvm/_install/bin' directory to PATH"
    export PATH="${GITENV_ROOT}/llvm/_install/bin":${PATH}
  fi

  asan="${GITENV_ROOT}/llvm/compiler-rt/lib/asan/scripts"
  if [ -r "${asan}/asan_symbolize.py" ];
  then
    echo "[gitenv] add '${asan}' directory to PATH"
    export PATH="${asan}":${PATH}
  fi

  cmake_path="${GITENV_ROOT}/cmake/_install/bin"
  if [ -r "${cmake_path}/cmake" ];
  then
    echo "[gitenv] add '${cmake_path}' directory to PATH"
    export PATH="${cmake_path}":${PATH}
  fi
fi
