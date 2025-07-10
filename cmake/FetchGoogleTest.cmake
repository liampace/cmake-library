include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG        v1.12.0
)
set(INSTALL_GTEST OFF)
FetchContent_MakeAvailable(googletest)
include(GoogleTest)