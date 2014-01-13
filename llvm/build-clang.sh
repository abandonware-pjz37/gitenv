#!/bin/bash -e

set -x

cd "`dirname "${BASH_SOURCE[0]}"`"
cd ..

GITENV_ROOT="`pwd`"

# http://clang.llvm.org/get_started.html

for curr in llvm/llvm llvm/clang llvm/clang-tools-extra llvm/compiler-rt;
do
  cd "${GITENV_ROOT}"
  git submodule update --init $curr
  cd $curr
  git checkout master
  git pull
done

rm -f "${GITENV_ROOT}/llvm/llvm/tools/clang/tools/clang-tools-extra"
rm -f "${GITENV_ROOT}/llvm/llvm/tools/clang"
rm -f "${GITENV_ROOT}/llvm/llvm/projects/compiler-rt"

ln -s "${GITENV_ROOT}/llvm/clang" "${GITENV_ROOT}/llvm/llvm/tools/clang"

ln -s "${GITENV_ROOT}/llvm/clang-tools-extra" \
    "${GITENV_ROOT}/llvm/llvm/tools/clang/tools/clang-tools-extra"

ln -s "${GITENV_ROOT}/llvm/compiler-rt" \
     "${GITENV_ROOT}/llvm/llvm/projects/compiler-rt"

cd "${GITENV_ROOT}/llvm"

rm -rf _build_clang

cmake -Hllvm -B_build_clang -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DCMAKE_INSTALL_PREFIX="`pwd`/_install" -DCMAKE_BUILD_TYPE=Release

cmake --build _build_clang --target install
