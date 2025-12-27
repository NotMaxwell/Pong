########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(harfbuzz_COMPONENT_NAMES "")
if(DEFINED harfbuzz_FIND_DEPENDENCY_NAMES)
  list(APPEND harfbuzz_FIND_DEPENDENCY_NAMES glib freetype)
  list(REMOVE_DUPLICATES harfbuzz_FIND_DEPENDENCY_NAMES)
else()
  set(harfbuzz_FIND_DEPENDENCY_NAMES glib freetype)
endif()
set(glib_FIND_MODE "NO_MODULE")
set(freetype_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(harfbuzz_PACKAGE_FOLDER_RELEASE "/Users/maxmccormick/.conan2/p/b/harfb4ed052f403893/p")
set(harfbuzz_BUILD_MODULES_PATHS_RELEASE )


set(harfbuzz_INCLUDE_DIRS_RELEASE )
set(harfbuzz_RES_DIRS_RELEASE )
set(harfbuzz_DEFINITIONS_RELEASE )
set(harfbuzz_SHARED_LINK_FLAGS_RELEASE )
set(harfbuzz_EXE_LINK_FLAGS_RELEASE )
set(harfbuzz_OBJECTS_RELEASE )
set(harfbuzz_COMPILE_DEFINITIONS_RELEASE )
set(harfbuzz_COMPILE_OPTIONS_C_RELEASE )
set(harfbuzz_COMPILE_OPTIONS_CXX_RELEASE )
set(harfbuzz_LIB_DIRS_RELEASE "${harfbuzz_PACKAGE_FOLDER_RELEASE}/lib")
set(harfbuzz_BIN_DIRS_RELEASE )
set(harfbuzz_LIBRARY_TYPE_RELEASE STATIC)
set(harfbuzz_IS_HOST_WINDOWS_RELEASE 0)
set(harfbuzz_LIBS_RELEASE harfbuzz)
set(harfbuzz_SYSTEM_LIBS_RELEASE c++)
set(harfbuzz_FRAMEWORK_DIRS_RELEASE )
set(harfbuzz_FRAMEWORKS_RELEASE ApplicationServices)
set(harfbuzz_BUILD_DIRS_RELEASE )
set(harfbuzz_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(harfbuzz_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${harfbuzz_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${harfbuzz_COMPILE_OPTIONS_C_RELEASE}>")
set(harfbuzz_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${harfbuzz_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${harfbuzz_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${harfbuzz_EXE_LINK_FLAGS_RELEASE}>")


set(harfbuzz_COMPONENTS_RELEASE )