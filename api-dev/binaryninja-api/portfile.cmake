set(VCPKG_USE_HEAD_VERSION ON)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ekilmer/binaryninja-api
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
