vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ekilmer/binaryninja-api
    # cmake-refactor-v5.0.7290-stable branch
    REF e493c61a64539d187e7afcd8a140a19de7f2bdbd
    SHA512 04ae06b821249ca542ea21230ff94f70413a28c13630445c7d376a3b2d7b81fc126ee96a77a90b3b68b40e9067a553ea5fe051e0cfdbc1c45ba3539a4d83ab38
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
