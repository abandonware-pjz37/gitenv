# Copyright (c) 2013, Ruslan Baratov
# All rights reserved.

if(DEFINED GITENV_GITENV_GITENV_PATHS_CMAKE)
  return()
else()
  set(GITENV_GITENV_GITENV_PATHS_CMAKE 1)
endif()

if(NOT GITENV_ROOT)
  set(GITENV_ROOT $ENV{GITENV_ROOT})
endif()

macro(_gitenv_path_setup macro_name gitenv_location)
  # First check cmake variable. If not empty - nothing need to be done
  if(NOT ${macro_name})
    # If cmake variable is not set, try to check environment variable
    set(${macro_name} $ENV{${macro_name}})
    # If environment variable is not setted too, set from gitenv
    if(NOT ${macro_name} AND GITENV_ROOT)
      set(${macro_name} "${GITENV_ROOT}/${gitenv_location}/${GITENV_INSTALL_PREFIX}")
    endif()
  endif()
endmacro()

_gitenv_path_setup(LIBCXX_ROOT "llvm/libcxx")
_gitenv_path_setup(GTEST_ROOT "google/gtest")
