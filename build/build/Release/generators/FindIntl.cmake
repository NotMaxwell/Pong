########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(Intl_FIND_QUIETLY)
    set(Intl_MESSAGE_MODE VERBOSE)
else()
    set(Intl_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/module-IntlTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${libgettext_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(Intl_VERSION_STRING "0.22")
set(Intl_INCLUDE_DIRS ${libgettext_INCLUDE_DIRS_RELEASE} )
set(Intl_INCLUDE_DIR ${libgettext_INCLUDE_DIRS_RELEASE} )
set(Intl_LIBRARIES ${libgettext_LIBRARIES_RELEASE} )
set(Intl_DEFINITIONS ${libgettext_DEFINITIONS_RELEASE} )


# Definition of extra CMake variables from cmake_extra_variables


# Only the last installed configuration BUILD_MODULES are included to avoid the collision
foreach(_BUILD_MODULE ${libgettext_BUILD_MODULES_PATHS_RELEASE} )
    message(${Intl_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


include(FindPackageHandleStandardArgs)
set(Intl_FOUND 1)
set(Intl_VERSION "0.22")

find_package_handle_standard_args(Intl
                                  REQUIRED_VARS Intl_VERSION
                                  VERSION_VAR Intl_VERSION)
mark_as_advanced(Intl_FOUND Intl_VERSION)

set(Intl_FOUND 1)
set(Intl_VERSION "0.22")
mark_as_advanced(Intl_FOUND Intl_VERSION)

