########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(libgettext_COMPONENT_NAMES "")
if(DEFINED libgettext_FIND_DEPENDENCY_NAMES)
  list(APPEND libgettext_FIND_DEPENDENCY_NAMES Iconv)
  list(REMOVE_DUPLICATES libgettext_FIND_DEPENDENCY_NAMES)
else()
  set(libgettext_FIND_DEPENDENCY_NAMES Iconv)
endif()
set(Iconv_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(libgettext_PACKAGE_FOLDER_RELEASE "/Users/maxmccormick/.conan2/p/libge76e09504d707c/p")
set(libgettext_BUILD_MODULES_PATHS_RELEASE )


set(libgettext_INCLUDE_DIRS_RELEASE )
set(libgettext_RES_DIRS_RELEASE )
set(libgettext_DEFINITIONS_RELEASE )
set(libgettext_SHARED_LINK_FLAGS_RELEASE )
set(libgettext_EXE_LINK_FLAGS_RELEASE )
set(libgettext_OBJECTS_RELEASE )
set(libgettext_COMPILE_DEFINITIONS_RELEASE )
set(libgettext_COMPILE_OPTIONS_C_RELEASE )
set(libgettext_COMPILE_OPTIONS_CXX_RELEASE )
set(libgettext_LIB_DIRS_RELEASE "${libgettext_PACKAGE_FOLDER_RELEASE}/lib")
set(libgettext_BIN_DIRS_RELEASE )
set(libgettext_LIBRARY_TYPE_RELEASE STATIC)
set(libgettext_IS_HOST_WINDOWS_RELEASE 0)
set(libgettext_LIBS_RELEASE gnuintl)
set(libgettext_SYSTEM_LIBS_RELEASE )
set(libgettext_FRAMEWORK_DIRS_RELEASE )
set(libgettext_FRAMEWORKS_RELEASE CoreFoundation)
set(libgettext_BUILD_DIRS_RELEASE )
set(libgettext_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(libgettext_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${libgettext_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${libgettext_COMPILE_OPTIONS_C_RELEASE}>")
set(libgettext_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${libgettext_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${libgettext_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${libgettext_EXE_LINK_FLAGS_RELEASE}>")


set(libgettext_COMPONENTS_RELEASE )