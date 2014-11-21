# Find PyQt5
# ~~~~~~~~~~
# Copyright (c) 2007-2008, Simon Edwards <simon@simonzone.com>
# Copyright (c) 2014, Joshua Arnott <josh@snorfalorpagus.net>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# PyQt5 website: http://www.riverbankcomputing.com/software/pyqt/intro
#
# Find the installed version of PyQt5. FindPyQt5 should only be called after
# Python has been found.
#
# This file defines the following variables:
#
# PYQT_VERSION - The version of PyQt5 found expressed as a 6 digit hex number
#     suitable for comparision as a string
#
# PYQT_VERSION_STR - The version of PyQt5 as a human readable string.
#
# PYQT_VERSION_TAG - The PyQt version tag using by PyQt's sip files.
#
# PYQT_SIP_DIR - The directory holding the PyQt5 .sip files.
#
# PYQT_SIP_FLAGS - The SIP flags used to build PyQt.

IF(EXISTS PYQT_VERSION)
  # Already in cache, be silent
  SET(PYQT_FOUND TRUE)
ELSE(EXISTS PYQT_VERSION)

  FIND_FILE(_find_pyqt_py FindPyQt5.py PATHS ${CMAKE_MODULE_PATH})

  EXECUTE_PROCESS(COMMAND ${PYTHON_EXECUTABLE} ${_find_pyqt_py} OUTPUT_VARIABLE pyqt_config)
  IF(pyqt_config)
    STRING(REGEX REPLACE "^pyqt_version:([^\n]+).*$" "\\1" PYQT_VERSION ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_version_str:([^\n]+).*$" "\\1" PYQT_VERSION_STR ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_version_tag:([^\n]+).*$" "\\1" PYQT_VERSION_TAG ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_version_num:([^\n]+).*$" "\\1" PYQT_VERSION_NUM ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_mod_dir:([^\n]+).*$" "\\1" PYQT_MOD_DIR ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_sip_dir:([^\n]+).*$" "\\1" PYQT_SIP_DIR ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_sip_flags:([^\n]+).*$" "\\1" PYQT_SIP_FLAGS ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_bin_dir:([^\n]+).*$" "\\1" PYQT_BIN_DIR ${pyqt_config})

    SET(PYQT_FOUND TRUE)
  ENDIF(pyqt_config)

  IF(PYQT_FOUND)
    IF(NOT PYQT_FIND_QUIETLY)
      MESSAGE(STATUS "Found PyQt version: ${PYQT_VERSION_STR}")
    ENDIF(NOT PYQT_FIND_QUIETLY)
  ELSE(PYQT_FOUND)
    IF(PYQT_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find Python")
    ENDIF(PYQT_FIND_REQUIRED)
  ENDIF(PYQT_FOUND)

ENDIF(EXISTS PYQT_VERSION)


