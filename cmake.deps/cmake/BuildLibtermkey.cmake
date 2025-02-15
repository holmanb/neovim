if(WIN32)
ExternalProject_Add(libtermkey
  PREFIX ${DEPS_BUILD_DIR}
  URL ${LIBTERMKEY_URL}
  DOWNLOAD_DIR ${DEPS_DOWNLOAD_DIR}/libtermkey
  DOWNLOAD_COMMAND ${CMAKE_COMMAND}
  -DPREFIX=${DEPS_BUILD_DIR}
  -DDOWNLOAD_DIR=${DEPS_DOWNLOAD_DIR}/libtermkey
  -DURL=${LIBTERMKEY_URL}
  -DEXPECTED_SHA256=${LIBTERMKEY_SHA256}
  -DTARGET=libtermkey
  -DUSE_EXISTING_SRC_DIR=${USE_EXISTING_SRC_DIR}
  -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/DownloadAndExtractFile.cmake
  CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/libtermkeyCMakeLists.txt
      ${DEPS_BUILD_DIR}/src/libtermkey/CMakeLists.txt
    COMMAND ${CMAKE_COMMAND} ${DEPS_BUILD_DIR}/src/libtermkey
      -DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR}
      # Pass toolchain
      -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}
      ${BUILD_TYPE_STRING}
      # Hack to avoid -rdynamic in Mingw
      -DCMAKE_SHARED_LIBRARY_LINK_C_FLAGS=""
      -DCMAKE_GENERATOR=${CMAKE_GENERATOR}
      -DCMAKE_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}
      -DUNIBILIUM_INCLUDE_DIRS=${DEPS_INSTALL_DIR}/include
      -DUNIBILIUM_LIBRARIES=${DEPS_LIB_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}unibilium${CMAKE_STATIC_LIBRARY_SUFFIX}
  BUILD_COMMAND ${CMAKE_COMMAND} --build . --config $<CONFIG>
  INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>)
else()
find_package(PkgConfig REQUIRED)

ExternalProject_Add(libtermkey
  PREFIX ${DEPS_BUILD_DIR}
  URL ${LIBTERMKEY_URL}
  DOWNLOAD_DIR ${DEPS_DOWNLOAD_DIR}/libtermkey
  DOWNLOAD_COMMAND ${CMAKE_COMMAND}
  -DPREFIX=${DEPS_BUILD_DIR}
  -DDOWNLOAD_DIR=${DEPS_DOWNLOAD_DIR}/libtermkey
  -DURL=${LIBTERMKEY_URL}
  -DEXPECTED_SHA256=${LIBTERMKEY_SHA256}
  -DTARGET=libtermkey
  -DUSE_EXISTING_SRC_DIR=${USE_EXISTING_SRC_DIR}
  -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/DownloadAndExtractFile.cmake
  CONFIGURE_COMMAND ""
  BUILD_IN_SOURCE 1
  BUILD_COMMAND ""
  INSTALL_COMMAND ${MAKE_PRG} CC=${DEPS_C_COMPILER}
                              PREFIX=${DEPS_INSTALL_DIR}
                              PKG_CONFIG_PATH=${DEPS_LIB_DIR}/pkgconfig
                              CFLAGS=-fPIC
                              LDFLAGS+=-static
                              ${DEFAULT_MAKE_CFLAGS}
                              install)
endif()

list(APPEND THIRD_PARTY_DEPS libtermkey)
