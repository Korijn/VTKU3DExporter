cmake_minimum_required(VERSION 3.12...3.16 FATAL_ERROR)

project(VTKCompileToolsTest)

find_package(VTKCompileTools REQUIRED)

function(display_status msg)
  message(STATUS "")
  message(STATUS "${msg}")
  message(STATUS "")
endfunction()

function(check_compiletools_exectuable target_name)
  display_status("Setting ${target_name}_EXECUTABLE")
  get_target_property(${target_name}_EXECUTABLE VTKCompileTools::${target_name} IMPORTED_LOCATION_RELEASE)
  if(NOT EXISTS ${${target_name}_EXECUTABLE})
    message(FATAL_ERROR "${target_name}_EXECUTABLE set to an nonexistent path: ${${target_name}_EXECUTABLE}")
  endif()

  display_status("Running ${${target_name}_EXECUTABLE}")
  execute_process(
    COMMAND ${${target_name}_EXECUTABLE} --help
    RESULT_VARIABLE result
    )
  if(NOT result EQUAL 0)
    message(FATAL_ERROR "Failed to run ${${target_name}_EXECUTABLE}")
  endif()
endfunction()

check_compiletools_exectuable("WrapHierarchy")
check_compiletools_exectuable("WrapPython")