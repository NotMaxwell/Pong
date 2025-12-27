########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(plutovg_COMPONENT_NAMES "")
if(DEFINED plutovg_FIND_DEPENDENCY_NAMES)
  list(APPEND plutovg_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES plutovg_FIND_DEPENDENCY_NAMES)
else()
  set(plutovg_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(plutovg_PACKAGE_FOLDER_RELEASE "/Users/maxmccormick/.conan2/p/b/pluto941890a788690/p")
set(plutovg_BUILD_MODULES_PATHS_RELEASE )


set(plutovg_INCLUDE_DIRS_RELEASE )
set(plutovg_RES_DIRS_RELEASE )
set(plutovg_DEFINITIONS_RELEASE )
set(plutovg_SHARED_LINK_FLAGS_RELEASE )
set(plutovg_EXE_LINK_FLAGS_RELEASE )
set(plutovg_OBJECTS_RELEASE )
set(plutovg_COMPILE_DEFINITIONS_RELEASE )
set(plutovg_COMPILE_OPTIONS_C_RELEASE )
set(plutovg_COMPILE_OPTIONS_CXX_RELEASE )
set(plutovg_LIB_DIRS_RELEASE "${plutovg_PACKAGE_FOLDER_RELEASE}/lib")
set(plutovg_BIN_DIRS_RELEASE )
set(plutovg_LIBRARY_TYPE_RELEASE STATIC)
set(plutovg_IS_HOST_WINDOWS_RELEASE 0)
set(plutovg_LIBS_RELEASE plutovg)
set(plutovg_SYSTEM_LIBS_RELEASE )
set(plutovg_FRAMEWORK_DIRS_RELEASE )
set(plutovg_FRAMEWORKS_RELEASE )
set(plutovg_BUILD_DIRS_RELEASE )
set(plutovg_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(plutovg_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${plutovg_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${plutovg_COMPILE_OPTIONS_C_RELEASE}>")
set(plutovg_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${plutovg_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${plutovg_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${plutovg_EXE_LINK_FLAGS_RELEASE}>")


set(plutovg_COMPONENTS_RELEASE )