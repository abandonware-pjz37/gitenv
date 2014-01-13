#!/bin/bash -e

set -x

cd "`dirname "${BASH_SOURCE[0]}"`"
cd ..

GITENV_ROOT="`pwd`"

BUILD_DIR=_build_libcxx

# http://libcxx.llvm.org/
git submodule update --init llvm/libcxx
cd llvm/libcxx
git checkout master
git pull

INCLUDE_DIRS=`echo | g++ -Wp,-v -x c++ - -fsyntax-only 2>&1 | grep ' \/usr\/include\/' | grep 'c++' | head -n2`

INCLUDE_OPTS=""
for x in ${INCLUDE_DIRS}
do
  INCLUDE_OPTS="$INCLUDE_OPTS;${x}"
done

cd "${GITENV_ROOT}/llvm"

# Build static release
rm -rf "${BUILD_DIR}"
cmake -DLIBCXX_CXX_ABI=libstdc++ \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLIBCXX_LIBSUPCXX_INCLUDE_PATHS="${INCLUDE_OPTS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DLIBCXX_ENABLE_SHARED=OFF \
    -DLIBCXX_ENABLE_ASSERTIONS=OFF \
    -DCMAKE_INSTALL_PREFIX="`pwd`/_install" \
    -Hlibcxx "-B${BUILD_DIR}"

cmake --build "${BUILD_DIR}" --target install

# Build static debug
rm -rf "${BUILD_DIR}"
cmake -DLIBCXX_CXX_ABI=libstdc++ \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLIBCXX_LIBSUPCXX_INCLUDE_PATHS="${INCLUDE_OPTS}" \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DLIBCXX_ENABLE_SHARED=OFF \
    -DCMAKE_DEBUG_POSTFIX=d \
    -DCMAKE_INSTALL_PREFIX="`pwd`/_install" \
    -Hlibcxx "-B${BUILD_DIR}"

cmake --build "${BUILD_DIR}" --target install

# Build shared release
rm -rf "${BUILD_DIR}"
cmake -DLIBCXX_CXX_ABI=libstdc++ \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLIBCXX_LIBSUPCXX_INCLUDE_PATHS="${INCLUDE_OPTS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DLIBCXX_ENABLE_SHARED=ON \
    -DLIBCXX_ENABLE_ASSERTIONS=OFF \
    -DCMAKE_INSTALL_PREFIX="`pwd`/_install" \
    -Hlibcxx "-B${BUILD_DIR}"

cmake --build "${BUILD_DIR}" --target install

# Build shared debug
rm -rf "${BUILD_DIR}"
cmake -DLIBCXX_CXX_ABI=libstdc++ \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLIBCXX_LIBSUPCXX_INCLUDE_PATHS="${INCLUDE_OPTS}" \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DLIBCXX_ENABLE_SHARED=ON \
    -DCMAKE_DEBUG_POSTFIX=d \
    -DCMAKE_INSTALL_PREFIX="`pwd`/_install" \
    -Hlibcxx "-B${BUILD_DIR}"

cmake --build "${BUILD_DIR}" --target install
