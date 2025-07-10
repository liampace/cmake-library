@PACKAGE_INIT@
file(GLOB EXPORT_FILES "${CMAKE_CURRENT_LIST_DIR}/*Targets.cmake")
foreach(EXPORT_FILE ${EXPORT_FILES})
    include(${EXPORT_FILE})
endforeach()
check_required_components(MyLibrary::MyLibrary)