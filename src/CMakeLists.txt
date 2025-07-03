# Add cross platform source files (.cpp) to this project.
file(GLOB SOURCE_FILES CONFIGURE_DEPENDS "*.cpp")
target_sources(${PROJECT_NAME} PRIVATE ${SOURCE_FILES})

# Add platform dependent source files (.cpp) to this project.
file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS "${CMAKE_SYSTEM_NAME}/*.cpp")
target_sources(${PROJECT_NAME} PRIVATE ${SOURCE_FILES})