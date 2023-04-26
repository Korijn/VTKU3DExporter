cmake_minimum_required(VERSION 3.15)

function(display_status msg)
  message(STATUS "")
  message(STATUS "${msg}")
  message(STATUS "")
endfunction()

#
# Download and build VTKCompileTools
#

if(NOT DEFINED VTKCompileTools_DIR)
  message(FATAL_ERROR "Variable VTKCompileTools_DIR is not defined")
endif()

if(NOT DEFINED VTKCompileTools_POPULATE_DIR)
  message(FATAL_ERROR "Variable VTKCompileTools_POPULATE_DIR is not defined")
endif()

set(proj "vtk-compile-tools")

display_status("${proj} - VTKCompileTools_DIR:${VTKCompileTools_DIR}")

if(NOT DEFINED VTK_SOURCE_DIR)

  set(VTK_SOURCE_DIR ${VTKCompileTools_POPULATE_DIR}/VTK)

  if(NOT DEFINED VTK_WHEEL_SDK_VERSION)
    message(FATAL_ERROR "Variable VTK_WHEEL_SDK_VERSION is not defined")
  endif()
  display_status("${proj} - VTK_WHEEL_SDK_VERSION:${VTK_WHEEL_SDK_VERSION}")

  include(FetchContent)
  FetchContent_Populate(${proj}
    SOURCE_DIR ${VTK_SOURCE_DIR}
    BINARY_DIR ${VTKCompileTools_POPULATE_DIR}/${proj}-build
    SUBBUILD_DIR ${VTKCompileTools_POPULATE_DIR}/${proj}-subbuild
    GIT_REPOSITORY "https://github.com/Kitware/VTK.git"
    GIT_TAG v${VTK_WHEEL_SDK_VERSION}
    GIT_SHALLOW 1
    GIT_PROGRESS 1
    )
else()
  display_status("${proj} - Skipping VTK download (VTK_SOURCE_DIR is defined)")
endif()

display_status("${proj} - VTK_SOURCE_DIR:${VTK_SOURCE_DIR}")

display_status("${proj} - Configuring ${VTKCompileTools_DIR}")
execute_process(
  COMMAND
    ${CMAKE_COMMAND}
      -DVTK_BUILD_COMPILE_TOOLS_ONLY:BOOL=ON
      -DCMAKE_BUILD_TYPE:STRING=Release
      -DVTK_BUILD_ALL_MODULES:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DVTK_BUILD_EXAMPLES:BOOL=OFF
      -DVTK_BUILD_TESTING:BOOL=OFF
      -DVTK_ENABLE_LOGGING:BOOL=OFF
      -S ${VTK_SOURCE_DIR}
      -B ${VTKCompileTools_DIR}
  )

include(ProcessorCount)
ProcessorCount(nproc)

display_status("${proj} - Building ${VTKCompileTools_DIR} [--parallel ${nproc}]")
execute_process(
  COMMAND
    ${CMAKE_COMMAND}
      --build ${VTKCompileTools_DIR}
      --config Release
      --parallel ${nproc}
  )

#
# Build VTKCompileToolsTest
#

display_status("${proj} - Testing ${VTKCompileTools_DIR}")

set(test_proj_src_dir ${CMAKE_CURRENT_LIST_DIR}/Testing/VTKCompileTools)
set(test_proj_bld_dir ${VTKCompileTools_POPULATE_DIR}/VTKCompileToolsTest-build)

execute_process(
  COMMAND
    ${CMAKE_COMMAND}
      -DVTKCompileTools_DIR:PATH=${VTKCompileTools_DIR}
      -S ${test_proj_src_dir}
      -B ${test_proj_bld_dir}
  )