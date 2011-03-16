if(itk-base-config-INCLUDED)
  return()
endif()
set(itk-base-config-INCLUDED 1)

get_filename_component(_itk_base_dir "${CMAKE_CURRENT_LIST_FILE}" PATH)

macro(itk_module _name)
  set(itk-module ${_name})
  set(itk-module-test ${_name}-Test)
  set(_doing "")
  set(ITK_MODULE_${itk-module}_DEPENDS "")
  set(ITK_MODULE_${itk-module-test}_DEPENDS "${itk-module}")
  set(ITK_MODULE_${itk-module}_DEFAULT OFF)
  foreach(arg ${ARGN})
    if("${arg}" MATCHES "^(DEPENDS|TEST_DEPENDS|DEFAULT)$")
      set(_doing "${arg}")
    elseif("${arg}" MATCHES "^[A-Z][A-Z][A-Z]$")
      set(_doing "")
      message(AUTHOR_WARNING "Unknown argument [${arg}]")
    elseif("${_doing}" MATCHES "^DEPENDS$")
      list(APPEND ITK_MODULE_${itk-module}_DEPENDS "${arg}")
    elseif("${_doing}" MATCHES "^TEST_DEPENDS$")
      list(APPEND ITK_MODULE_${itk-module-test}_DEPENDS "${arg}")
    elseif("${_doing}" MATCHES "^DEFAULT")
      set(ITK_MODULE_${itk-module}_DEFAULT "${arg}")
    else()
      set(_doing "")
      message(AUTHOR_WARNING "Unknown argument [${arg}]")
    endif()
  endforeach()
  list(SORT ITK_MODULE_${itk-module}_DEPENDS) # Deterministic order.
  list(SORT ITK_MODULE_${itk-module-test}_DEPENDS) # Deterministic order.
endmacro()

macro(itk_module_impl)
  include(itk-module.cmake) # Load module meta-data
  if(NOT ${itk-module}-target)
    set(${itk-module}-target ${itk-module})
  endif()
  set(${itk-module}_INSTALL_RUNTIME_DIR ${ITK_INSTALL_RUNTIME_DIR})
  set(${itk-module}_INSTALL_LIBRARY_DIR ${ITK_INSTALL_LIBRARY_DIR})
  set(${itk-module}_INSTALL_ARCHIVE_DIR ${ITK_INSTALL_ARCHIVE_DIR})
  set(${itk-module}_INSTALL_INCLUDE_DIR ${ITK_INSTALL_INCLUDE_DIR})

  if(DEFINED ${itk-module}_LIBRARIES)
    set(itk-module-config-build "${itk-module-config-build}
set(${itk-module}_LIBRARIES \"${${itk-module}_LIBRARIES}\")
")
    set(itk-module-config-install "${itk-module-config-install}
set(${itk-module}_LIBRARIES \"${${itk-module}_LIBRARIES}\")
")
    set(_trans 0)
  else()
    set(_trans 1)
  endif()

  foreach(dep IN LISTS ITK_MODULE_${itk-module}_DEPENDS)
    if(NOT ${dep}_LOADED)
      include("${ITK_MODULES_DIR}/${dep}.cmake")
    endif()
    if(${dep}_INCLUDE_DIRS)
      include_directories(${${dep}_INCLUDE_DIRS})
    endif()
    if(${dep}_LIBRARY_DIRS)
      link_directories(${${dep}_LIBRARY_DIRS})
    endif()
    set(itk-module-config-build "${itk-module-config-build}
if(NOT ${dep}_LOADED)
  include(\"\${ITK_MODULES_DIR}/${dep}.cmake\")
endif()
list(APPEND ${itk-module}_INCLUDE_DIRS \${${dep}_INCLUDE_DIRS})
list(APPEND ${itk-module}_LIBRARY_DIRS \${${dep}_LIBRARY_DIRS})
")
    set(itk-module-config-install "${itk-module-config-install}
if(NOT ${dep}_LOADED)
  include(\"\${ITK_MODULES_DIR}/${dep}.cmake\")
endif()
list(APPEND ${itk-module}_INCLUDE_DIRS \${${dep}_INCLUDE_DIRS})
list(APPEND ${itk-module}_LIBRARY_DIRS \${${dep}_LIBRARY_DIRS})
")
    if(_trans)
      list(APPEND ${itk-module}_LIBRARIES ${${dep}_LIBRARIES})
      set(itk-module-config-build "${itk-module-config-build}
list(APPEND ${itk-module}_LIBRARIES \${${dep}_LIBRARIES})
")
      set(itk-module-config-install "${itk-module-config-install}
list(APPEND ${itk-module}_LIBRARIES \${${dep}_LIBRARIES})
")
    endif()
  endforeach()

  if(EXISTS ${${itk-module}_SOURCE_DIR}/include)
    list(APPEND ${itk-module}_INCLUDE_DIRS ${${itk-module}_SOURCE_DIR}/include)
    install(DIRECTORY include/ DESTINATION ${${itk-module}_INSTALL_INCLUDE_DIR})
    set(itk-module-config-install "${itk-module-config-install}
list(APPEND ${itk-module}_INCLUDE_DIRS \"\${ITK_INSTALL_PREFIX}/${${itk-module}_INSTALL_INCLUDE_DIR}\")
")
  endif()

  if(${itk-module}_INCLUDE_DIRS)
    include_directories(${${itk-module}_INCLUDE_DIRS})
    set(itk-module-config-build "${itk-module-config-build}
list(APPEND ${itk-module}_INCLUDE_DIRS \"${${itk-module}_INCLUDE_DIRS}\")
")
  endif()

  if(_trans)
    if(${itk-module}_LIBRARIES)
      list(REMOVE_DUPLICATES ${itk-module}_LIBRARIES)
    endif()
    set(itk-module-config-build "${itk-module-config-build}
if(${itk-module}_LIBRARIES)
  list(REMOVE_DUPLICATES ${itk-module}_LIBRARIES)
endif()
")
    set(itk-module-config-install "${itk-module-config-install}
if(${itk-module}_LIBRARIES)
  list(REMOVE_DUPLICATES ${itk-module}_LIBRARIES)
endif()
")
  endif()

  set(itk-module-export-targets 0)
  if(EXISTS ${${itk-module}_SOURCE_DIR}/src/CMakeLists.txt AND NOT itk-module-no-src)
    set(itk-module-export-targets 1)
    add_subdirectory(src)
  endif()

  configure_file(${_itk_base_dir}/itk-module-build.cmake.in ${ITK_MODULES_DIR}/${itk-module}.cmake @ONLY)
  configure_file(${_itk_base_dir}/itk-module-install.cmake.in CMakeFiles/${itk-module}.cmake @ONLY)
  install(FILES
    ${${itk-module}_BINARY_DIR}/CMakeFiles/${itk-module}.cmake
    DESTINATION ${ITK_INSTALL_PACKAGE_DIR}/Modules
    )
endmacro()

macro(itk_module_test)
  include(../itk-module.cmake) # Load module meta-data
  set(${itk-module-test}_LIBRARIES "")
  foreach(dep IN LISTS ITK_MODULE_${itk-module-test}_DEPENDS)
    if(NOT ${dep}_LOADED)
      include("${ITK_MODULES_DIR}/${dep}.cmake")
    endif()
    if(${dep}_INCLUDE_DIRS)
      include_directories(${${dep}_INCLUDE_DIRS})
    endif()
    if(${dep}_LIBRARY_DIRS)
      link_directories(${${dep}_LIBRARY_DIRS})
    endif()
   list(APPEND ${itk-module-test}_LIBRARIES ${${dep}_LIBRARIES})
  endforeach()
endmacro()

macro(itk_module_target_name _name)
  set_property(TARGET ${_name} PROPERTY VERSION 1)
  set_property(TARGET ${_name} PROPERTY OUTPUT_NAME ${_name}-${ITK_VERSION_MAJOR}.${ITK_VERSION_MINOR})
endmacro()

macro(itk_module_target_export _name)
  export(TARGETS ${_name} APPEND FILE ${${itk-module}-targets-build})
endmacro()

macro(itk_module_target_install _name)
  install(TARGETS ${_name}
    EXPORT  ${${itk-module}-targets}
    RUNTIME DESTINATION ${${itk-module}_INSTALL_RUNTIME_DIR}
    LIBRARY DESTINATION ${${itk-module}_INSTALL_ARCHIVE_DIR}
    ARCHIVE DESTINATION ${${itk-module}_INSTALL_LIBRARY_DIR}
    )
endmacro()

macro(itk_module_target _name)
  itk_module_target_name(${_name})
  itk_module_target_export(${_name})
  itk_module_target_install(${_name})
endmacro()
