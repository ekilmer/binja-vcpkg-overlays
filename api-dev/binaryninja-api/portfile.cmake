vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ekilmer/binaryninja-api
    REF c22b79e1c8f16cbcece5167b914e3c1fdc508380
    SHA512 e0527cac6923b15390d9addd7a70e9fb33a762d3efb38c57354ac217e161786d74c4e2c067860994df7d9447f85c30f332ef459db6de3642268d68140a7750fe
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
