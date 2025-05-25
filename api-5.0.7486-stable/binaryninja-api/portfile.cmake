vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ekilmer/binaryninja-api
    # cmake-refactor-v5.0.7486-stable branch
    REF 28cea021bd257b55fe8f6e4999957e8322508223
    SHA512 586f78b0463877796c3758d9fd36aaf1adbf1ed7030d8d99a29c1d477ba2f6d4185f8ce028308bf476084fa05dba4ecc81d402fb40ea0fcd0f119fe17fca1225
    HEAD_REF cmake-refactor
)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    INVERTED_FEATURES
        ui BinaryNinjaAPI_HEADLESS
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBinaryNinjaAPI_INSTALL_CMAKEDIR=share/BinaryNinjaAPI
        -DBinaryNinjaAPI_BUILD_EXAMPLES=OFF
        -DBinaryNinjaAPI_EXTERNAL_DEPENDENCIES=ON
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME BinaryNinjaAPI)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
