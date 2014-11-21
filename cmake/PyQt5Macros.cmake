# Macros for PyQt5
# ~~~~~~~~~~~~~~~~
# Copyright (c) 2009, Juergen E. Fischer <jef at norbit dot de>
# Copyright (c) 2009, Joshua Arnott <josh@snorfalorpagus.net>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF(NOT PYUIC_PROGRAM)
  IF (MSVC)
    FIND_PROGRAM(PYUIC_PROGRAM
      NAMES pyuic5.bat
      PATHS $ENV{LIB_DIR}/bin
    )
  ELSE(MSVC)
    FIND_PROGRAM(PYUIC_PROGRAM NAMES python2-pyuic5 pyuic5 pyuic)
  ENDIF (MSVC)

  IF (NOT PYUIC_PROGRAM)
    MESSAGE(FATAL_ERROR "pyuic not found - aborting")
  ENDIF (NOT PYUIC_PROGRAM)
ENDIF(NOT PYUIC_PROGRAM)

# Adapted from QT4_WRAP_UI
MACRO(PYQT_WRAP_UI outfiles )
  IF(WIN32)
    SET(PYUIC_WRAPPER "${CMAKE_SOURCE_DIR}/scripts/pyuic-wrapper.bat")
    SET(PYUIC_WRAPPER_PATH "${QGIS_OUTPUT_DIRECTORY}/bin/${CMAKE_BUILD_TYPE}")
  ELSE(WIN32)
    # TODO osx
    SET(PYUIC_WRAPPER "${CMAKE_SOURCE_DIR}/scripts/pyuic-wrapper.sh")
    SET(PYUIC_WRAPPER_PATH "${QGIS_OUTPUT_DIRECTORY}/lib")
  ENDIF(WIN32)

  FOREACH(it ${ARGN})
    GET_FILENAME_COMPONENT(outfile ${it} NAME_WE)
    GET_FILENAME_COMPONENT(infile ${it} ABSOLUTE)
    SET(outfile ${CMAKE_CURRENT_BINARY_DIR}/ui_${outfile}.py)
    ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
      COMMAND ${PYUIC_WRAPPER} "${PYUIC_PROGRAM}" "${PYUIC_WRAPPER_PATH}" "${QGIS_OUTPUT_DIRECTORY}/python" ${infile} -o ${outfile}
      MAIN_DEPENDENCY ${infile}                       
      DEPENDS pygui pycore
    )
    SET(${outfiles} ${${outfiles}} ${outfile})
  ENDFOREACH(it)
ENDMACRO(PYQT_WRAP_UI)

IF(NOT PYRCC_PROGRAM)
  IF (MSVC)
    FIND_PROGRAM(PYRCC_PROGRAM
      NAMES pyrcc5.exe
      PATHS $ENV{LIB_DIR}/bin
    )
  ELSE(MSVC)
    FIND_PROGRAM(PYRCC_PROGRAM pyrcc5 pyrcc)
  ENDIF (MSVC)

  IF (NOT PYRCC_PROGRAM)
    MESSAGE(FATAL_ERROR "pyrcc not found - aborting")
  ENDIF (NOT PYRCC_PROGRAM)
ENDIF(NOT PYRCC_PROGRAM)

# Adapted from QT4_ADD_RESOURCES
MACRO (PYQT_ADD_RESOURCES outfiles )
  FOREACH (it ${ARGN})
    GET_FILENAME_COMPONENT(outfile ${it} NAME_WE)
    GET_FILENAME_COMPONENT(infile ${it} ABSOLUTE)
    GET_FILENAME_COMPONENT(rc_path ${infile} PATH)
    SET(outfile ${CMAKE_CURRENT_BINARY_DIR}/${outfile}_rc.py)
    #  parse file for dependencies 
    #  all files are absolute paths or relative to the location of the qrc file
    FILE(READ "${infile}" _RC_FILE_CONTENTS)
    STRING(REGEX MATCHALL "<file[^<]+" _RC_FILES "${_RC_FILE_CONTENTS}")
    SET(_RC_DEPENDS)
    FOREACH(_RC_FILE ${_RC_FILES})
      STRING(REGEX REPLACE "^<file[^>]*>" "" _RC_FILE "${_RC_FILE}")
      STRING(REGEX MATCH "^/|([A-Za-z]:/)" _ABS_PATH_INDICATOR "${_RC_FILE}")
      IF(NOT _ABS_PATH_INDICATOR)
        SET(_RC_FILE "${rc_path}/${_RC_FILE}")
      ENDIF(NOT _ABS_PATH_INDICATOR)
      SET(_RC_DEPENDS ${_RC_DEPENDS} "${_RC_FILE}")
    ENDFOREACH(_RC_FILE)
    ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
      COMMAND ${PYRCC_PROGRAM} -name ${outfile} -o ${outfile} ${infile}
      MAIN_DEPENDENCY ${infile}
      DEPENDS ${_RC_DEPENDS})
    SET(${outfiles} ${${outfiles}} ${outfile})
  ENDFOREACH (it)
ENDMACRO (PYQT_ADD_RESOURCES)
