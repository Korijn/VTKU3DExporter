
set(proj U3D)

# Set dependency list
set(${proj}_DEPENDENCIES "")

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

# Sanity checks
if(DEFINED ${proj}_INCLUDE_DIR AND NOT EXISTS ${${proj}_INCLUDE_DIR})
  message(FATAL_ERROR "${proj}_INCLUDE_DIR variable is defined but corresponds to nonexistent directory")
endif()
if(DEFINED ${proj}_IDTF_LIBRARY AND NOT EXISTS ${${proj}_IDTF_LIBRARY})
  message(FATAL_ERROR "${proj}_IDTF_LIBRARY variable is defined but corresponds to nonexistent file")
endif()

if(NOT DEFINED ${proj}_INCLUDE_DIR OR NOT DEFINED ${proj}_IDTF_LIBRARY)

  set(EXTERNAL_PROJECT_OPTIONAL_CMAKE_CACHE_ARGS )

  if(NOT CMAKE_CONFIGURATION_TYPES)
    list(APPEND EXTERNAL_PROJECT_OPTIONAL_CMAKE_CACHE_ARGS
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      )
  endif()

  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj})
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
  set(EP_INSTALL_DIR ${CMAKE_BINARY_DIR}/${proj}-install)

  ExternalProject_add(U3D
    GIT_REPOSITORY https://github.com/ClinicalGraphics/u3d.git
    GIT_TAG 562d1bf70d0d687ac57658f05c4e535819a87d96
    SOURCE_DIR ${EP_SOURCE_DIR}
    BINARY_DIR ${EP_BINARY_DIR}
    INSTALL_DIR ${EP_INSTALL_DIR}
    CMAKE_CACHE_ARGS
      -DU3D_SHARED:BOOL=OFF
      -DCMAKE_INSTALL_PREFIX:PATH=${EP_INSTALL_DIR}
      ${EXTERNAL_PROJECT_OPTIONAL_CMAKE_CACHE_ARGS}
    USES_TERMINAL_DOWNLOAD 1
    USES_TERMINAL_UPDATE 1
    USES_TERMINAL_CONFIGURE 1
    USES_TERMINAL_BUILD 1
    USES_TERMINAL_INSTALL 1
    )

  set(${proj}_INCLUDE_DIR ${EP_INSTALL_DIR}/u3d/include/)

  if(WIN32)
    # library type hardcoded to "static" in U3D build-system
    set(${proj}_IDTF_LIBRARY ${EP_INSTALL_DIR}/u3d/IDTF.lib)
  else()
    # library type hardcoded to "shared" in U3D build-system
    set(${proj}_IDTF_LIBRARY ${EP_INSTALL_DIR}/u3d/${CMAKE_SHARED_LIBRARY_PREFIX}IDTF${CMAKE_SHARED_LIBRARY_SUFFIX})
  endif()

endif()

mark_as_superbuild(
  VARS
    ${proj}_INCLUDE_DIR:PATH
    ${proj}_IDTF_LIBRARY:FILEPATH
  )

ExternalProject_Message(${proj} "${proj}_INCLUDE_DIR:${${proj}_INCLUDE_DIR}")
ExternalProject_Message(${proj} "${proj}_IDTF_LIBRARY:${${proj}_IDTF_LIBRARY}")
