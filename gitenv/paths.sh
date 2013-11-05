#!/bin/bash

# Copyright (c) 2013, Ruslan Baratov
# All rights reserved.

# Load some extra paths and scripts from GITENV_ROOT
# Note: This file is sourced from bashrc

if [ -n "${GITENV_ROOT}" ];
then
  if [ -r "${GITENV_ROOT}/git/contrib/completion/git-completion.bash" ];
  then
    source "${GITENV_ROOT}/git/contrib/completion/git-completion.bash"
  fi

  if [ -r "${GITENV_ROOT}/sugar/cmake/Sugar" ];
  then
    export SUGAR_ROOT="${GITENV_ROOT}/sugar"
    if [ -r "${SUGAR_ROOT}/python" ];
    then
      PATH="${SUGAR_ROOT}/python":${PATH}
    fi
  fi
fi
