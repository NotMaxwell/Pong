# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(plutovg_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(plutovg_FRAMEWORKS_FOUND_RELEASE "${plutovg_FRAMEWORKS_RELEASE}" "${plutovg_FRAMEWORK_DIRS_RELEASE}")

set(plutovg_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET plutovg_DEPS_TARGET)
    add_library(plutovg_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET plutovg_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${plutovg_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${plutovg_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### plutovg_DEPS_TARGET to all of them
conan_package_library_targets("${plutovg_LIBS_RELEASE}"    # libraries
                              "${plutovg_LIB_DIRS_RELEASE}" # package_libdir
                              "${plutovg_BIN_DIRS_RELEASE}" # package_bindir
                              "${plutovg_LIBRARY_TYPE_RELEASE}"
                              "${plutovg_IS_HOST_WINDOWS_RELEASE}"
                              plutovg_DEPS_TARGET
                              plutovg_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "plutovg"    # package_name
                              "${plutovg_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${plutovg_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET plutovg::plutovg
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${plutovg_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${plutovg_LIBRARIES_TARGETS}>
                 )

    if("${plutovg_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET plutovg::plutovg
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     plutovg_DEPS_TARGET)
    endif()

    set_property(TARGET plutovg::plutovg
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${plutovg_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET plutovg::plutovg
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${plutovg_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET plutovg::plutovg
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${plutovg_LIB_DIRS_RELEASE}>)
    set_property(TARGET plutovg::plutovg
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${plutovg_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET plutovg::plutovg
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${plutovg_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(plutovg_LIBRARIES_RELEASE plutovg::plutovg)
