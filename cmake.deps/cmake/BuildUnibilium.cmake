if(WIN32)
  ExternalProject_Add(unibilium
    PREFIX ${DEPS_BUILD_DIR}
    URL ${UNIBILIUM_URL}
    DOWNLOAD_DIR ${DEPS_DOWNLOAD_DIR}/unibilium
    DOWNLOAD_COMMAND ${CMAKE_COMMAND}
      -DPREFIX=${DEPS_BUILD_DIR}
      -DDOWNLOAD_DIR=${DEPS_DOWNLOAD_DIR}/unibilium
      -DURL=${UNIBILIUM_URL}
      -DEXPECTED_SHA256=${UNIBILIUM_SHA256}
      -DTARGET=unibilium
      -DUSE_EXISTING_SRC_DIR=${USE_EXISTING_SRC_DIR}
      -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/DownloadAndExtractFile.cmake
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy
      ${CMAKE_CURRENT_SOURCE_DIR}/cmake/UnibiliumCMakeLists.txt
      ${DEPS_BUILD_DIR}/src/unibilium/CMakeLists.txt
      COMMAND ${CMAKE_COMMAND} ${DEPS_BUILD_DIR}/src/unibilium
        -DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR}
        # Pass toolchain
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}
        -DCMAKE_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}
        ${BUILD_TYPE_STRING}
        -DCMAKE_GENERATOR=${CMAKE_GENERATOR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config $<CONFIG>
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>)
else()
  ExternalProject_Add(unibilium
    PREFIX ${DEPS_BUILD_DIR}
    URL ${UNIBILIUM_URL}
    DOWNLOAD_DIR ${DEPS_DOWNLOAD_DIR}/unibilium
    DOWNLOAD_COMMAND ${CMAKE_COMMAND}
      -DPREFIX=${DEPS_BUILD_DIR}
      -DDOWNLOAD_DIR=${DEPS_DOWNLOAD_DIR}/unibilium
      -DURL=${UNIBILIUM_URL}
      -DEXPECTED_SHA256=${UNIBILIUM_SHA256}
      -DTARGET=unibilium
      -DUSE_EXISTING_SRC_DIR=${USE_EXISTING_SRC_DIR}
      -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/DownloadAndExtractFile.cmake
    CONFIGURE_COMMAND ""
    BUILD_IN_SOURCE 1
    BUILD_COMMAND ${MAKE_PRG} CC=${DEPS_C_COMPILER}
                              PREFIX=${DEPS_INSTALL_DIR}
                              CFLAGS=-fPIC
                              LDFLAGS+=-static
    INSTALL_COMMAND ${MAKE_PRG} PREFIX=${DEPS_INSTALL_DIR} install)
endif()

list(APPEND THIRD_PARTY_DEPS unibilium)
