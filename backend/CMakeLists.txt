include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    EdItbackend_SRCS
    modules/EdIt/backend.cpp
    modules/EdIt/mytype.cpp
)

add_library(EdItbackend MODULE
    ${EdItbackend_SRCS}
)

set_target_properties(EdItbackend PROPERTIES
         LIBRARY_OUTPUT_DIRECTORY EdIt)

qt5_use_modules(EdItbackend Gui Qml Quick)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(EdItbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/EdIt/qmldir ${CMAKE_CURRENT_BINARY_DIR}/EdIt
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS EdItbackend DESTINATION ${QT_IMPORTS_DIR}/EdIt/)
install(FILES   modules/EdIt/qmldir DESTINATION ${QT_IMPORTS_DIR}/EdIt/)

