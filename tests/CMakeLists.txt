include(FetchGoogleTest)

set(TESTING_TARGET "${PROJECT_NAME}-Tests")

# Add unit tests files (.cpp) to this project.
file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS "*.cpp")
add_executable(${TESTING_TARGET} ${SOURCE_FILES})
target_link_libraries(${TESTING_TARGET} PRIVATE ${PROJECT_NAME} "gtest" "gtest_main")
gtest_discover_tests(${TESTING_TARGET})