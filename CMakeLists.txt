cmake_minimum_required (VERSION 3.19)

# Enable Hot Reload for MSVC compilers if supported.
if (POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

set(MYLIBRARY_INCLUDE_DIR 
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>)

project("MyLibrary")
set(PROJECT_VERSION_MAJOR 1)
set(PROJECT_VERSION_MINOR 0)
set(PROJECT_VERSION_PATCH 0)
set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
set(PROJECT_DESCRIPTION "A simple CMake library.")
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Add build options to this project.
string(COMPARE EQUAL "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_SOURCE_DIR}" MYLIBRARY_STANDALONE)
option(MYLIBRARY_BUILD_EXAMPLES "Build the ${PROJECT_NAME} example programs" ${MYLIBRARY_STANDALONE})
option(MYLIBRARY_BUILD_TESTS "Build the ${PROJECT_NAME} test programs" ${MYLIBRARY_STANDALONE})
option(MYLIBRARY_BUILD_DOCS "Build the ${PROJECT_NAME} HTML documentation." ON)
option(MYLIBRARY_INSTALL "Generate the ${PROJECT_NAME} installation target" ON)

# Add CMake modules to this project
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# Add source files (.cpp) to this project.
add_library(${PROJECT_NAME})
add_subdirectory("src")

# Add template header files (.hpp) to this project
file(GLOB_RECURSE TEMPLATE_FILES CONFIGURE_DEPENDS "${MYLIBRARY_INCLUDE_DIR}/*.hpp")
target_sources(${PROJECT_NAME} PUBLIC ${TEMPLATE_FILES})

# Add normal header files (.h) to this project
file(GLOB_RECURSE HEADER_FILES CONFIGURE_DEPENDS "${MYLIBRARY_INCLUDE_DIR}/*.h")
target_sources(${PROJECT_NAME} PUBLIC ${HEADER_FILES})
target_include_directories(${PROJECT_NAME} PUBLIC ${MYLIBRARY_INCLUDE_DIR})
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)

# Fix CMake Issue #18837 
# https://gitlab.kitware.com/cmake/cmake/-/issues/18837
# This is required for making the standard conforming __cplusplus macro the correct value
if ((MSVC) AND (MSVC_VERSION GREATER_EQUAL 1914))
	target_compile_options(${PROJECT_NAME} PUBLIC "/Zc:__cplusplus")
endif()

# Fix CMake Issue #17068
# https://gitlab.kitware.com/cmake/cmake/-/issues/17068
# This is required for making some standard conforming features compilable
if ((MSVC) AND (MSVC_VERSION GREATER_EQUAL 1912))
	target_compile_options(${PROJECT_NAME} PUBLIC "/permissive-")
endif()

# Add example programs to this project.
if (MYLIBRARY_BUILD_EXAMPLES)
	add_subdirectory("examples")
endif()

# Add test programs to this project.
if (MYLIBRARY_BUILD_TESTS)
	include(CTest)
	enable_testing()
	add_subdirectory("tests")
endif()

# Add documentation to this project.
if (MYLIBRARY_BUILD_DOCS)
	add_subdirectory("docs")
endif()

# Add installation target to this project.
if (MYLIBRARY_INSTALL)
	install(DIRECTORY ${MYLIBRARY_INCLUDE_DIR}
		DESTINATION ${CMAKE_INSTALL_PREFIX}
		FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp")

	set(MYLIBRARY_EXPORT_TARGETS "${PROJECT_NAME}Targets")
	set(MYLIBRARY_EXPORT_TARGETS_FILE "${MYLIBRARY_EXPORT_TARGETS}.cmake")
	set(MYLIBRARY_EXPORT_PATH "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
	install(TARGETS ${PROJECT_NAME}
		EXPORT ${MYLIBRARY_EXPORT_TARGETS})
	install(EXPORT ${MYLIBRARY_EXPORT_TARGETS}
		FILE ${MYLIBRARY_EXPORT_TARGETS_FILE}
		NAMESPACE ${PROJECT_NAME}::
		DESTINATION ${MYLIBRARY_EXPORT_PATH})

	set(MYLIBRARY_EXPORT_CONFIGS_FILE "${PROJECT_NAME}Config.cmake")
	include(CMakePackageConfigHelpers)
	configure_package_config_file(
		"${CMAKE_CURRENT_SOURCE_DIR}/cmake/${MYLIBRARY_EXPORT_CONFIGS_FILE}"
		"${CMAKE_CURRENT_BINARY_DIR}/${MYLIBRARY_EXPORT_CONFIGS_FILE}"
		INSTALL_DESTINATION ${MYLIBRARY_EXPORT_PATH})

	set(MYLIBRARY_EXPORT_CONFIGS_VERSION_FILE "${PROJECT_NAME}ConfigVersion.cmake")
	write_basic_package_version_file(
		${MYLIBRARY_EXPORT_CONFIGS_VERSION_FILE}
		VERSION ${PACKAGE_VERSION}
		COMPATIBILITY SameMajorVersion)

	install(FILES
	 "${CMAKE_CURRENT_BINARY_DIR}/${MYLIBRARY_EXPORT_CONFIGS_FILE}"
	 "${CMAKE_CURRENT_BINARY_DIR}/${MYLIBRARY_EXPORT_CONFIGS_VERSION_FILE}"
	 DESTINATION ${MYLIBRARY_EXPORT_PATH})
endif()