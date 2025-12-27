########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(plutosvg_COMPONENT_NAMES "")
if(DEFINED plutosvg_FIND_DEPENDENCY_NAMES)
  list(APPEND plutosvg_FIND_DEPENDENCY_NAMES plutovg freetype)
  list(REMOVE_DUPLICATES plutosvg_FIND_DEPENDENCY_NAMES)
else()
  set(plutosvg_FIND_DEPENDENCY_NAMES plutovg freetype)
endif()
set(plutovg_FIND_MODE "NO_MODULE")
set(freetype_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(plutosvg_PACKAGE_FOLDER_RELEASE "/Users/maxmccormick/.conan2/p/b/pluto3541474cc52c5/p")
set(plutosvg_BUILD_MODULES_PATHS_RELEASE )


set(plutosvg_INCLUDE_DIRS_RELEASE )
set(plutosvg_RES_DIRS_RELEASE )
set(plutosvg_DEFINITIONS_RELEASE "-DPLUTOSVG_HAS_FREETYPE"
			"-DPLUTOSVG_BUILD_STATIC")
set(plutosvg_SHARED_LINK_FLAGS_RELEASE )
set(plutosvg_EXE_LINK_FLAGS_RELEASE )
set(plutosvg_OBJECTS_RELEASE )
set(plutosvg_COMPILE_DEFINITIONS_RELEASE "PLUTOSVG_HAS_FREETYPE"
			"PLUTOSVG_BUILD_STATIC")
set(plutosvg_COMPILE_OPTIONS_C_RELEASE )
set(plutosvg_COMPILE_OPTIONS_CXX_RELEASE )
set(plutosvg_LIB_DIRS_RELEASE "${plutosvg_PACKAGE_FOLDER_RELEASE}/lib")
set(plutosvg_BIN_DIRS_RELEASE )
set(plutosvg_LIBRARY_TYPE_RELEASE STATIC)
set(plutosvg_IS_HOST_WINDOWS_RELEASE 0)
set(plutosvg_LIBS_RELEASE plutosvg)
set(plutosvg_SYSTEM_LIBS_RELEASE )
set(plutosvg_FRAMEWORK_DIRS_RELEASE )
set(plutosvg_FRAMEWORKS_RELEASE )
set(plutosvg_BUILD_DIRS_RELEASE )
set(plutosvg_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(plutosvg_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${plutosvg_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${plutosvg_COMPILE_OPTIONS_C_RELEASE}>")
set(plutosvg_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${plutosvg_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${plutosvg_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${plutosvg_EXE_LINK_FLAGS_RELEASE}>")


set(plutosvg_COMPONENTS_RELEASE )