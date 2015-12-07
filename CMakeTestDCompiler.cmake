#
# CMakeD - CMake module for D Language
#
# Copyright (c) 2015, Ferdinand Thiessen <rpm@fthiessen.de>
# Copyright (c) 2007, Selman Ulug <selman.ulug@gmail.com>
#                     Tim Burrell <tim.burrell@gmail.com>
#
# All rights reserved.
#
# See LICENSE for details.
#
# Modified from CMake 2.6.5 CMakeTestCCompiler.cmake
# See http://www.cmake.org/HTML/Copyright.html for details
#

# This file is used by EnableLanguage in cmGlobalGenerator to
# determine that that selected D compiler can actually compile
# and link the most basic of programs.   If not, a fatal error
# is set and cmake stops processing commands and will not generate
# any makefiles or projects.

if(NOT CMAKE_D_COMPILER_WORKS)
	message(STATUS "Check for working D compiler: ${CMAKE_D_COMPILER}")
	file(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
		"int main(char[][] args)\n"
		"{return args.sizeof-1;}\n")
	if(CMAKE_D_COMPILER_ID STREQUAL "DMD")
		if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
			try_compile(CMAKE_D_COMPILER_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
				OUTPUT_VARIABLE OUTPUT) 
		else(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
			try_compile(CMAKE_D_COMPILER_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
				OUTPUT_VARIABLE OUTPUT) 
		endif(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	else(CMAKE_D_COMPILER_ID STREQUAL "DMD")
		try_compile(CMAKE_D_COMPILER_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
			OUTPUT_VARIABLE OUTPUT) 
	endif(CMAKE_D_COMPILER_ID STREQUAL "DMD")
	set(C_TEST_WAS_RUN 1)
endif(NOT CMAKE_D_COMPILER_WORKS)

if(NOT CMAKE_D_COMPILER_WORKS)
	message(STATUS "Check for working D compiler: ${CMAKE_D_COMPILER} -- broken")
	message(STATUS "To force a specific D compiler set the DC environment variable")
	message(STATUS "    ie - export DC=\"/opt/dmd/bin/dmd\"")
	message(STATUS "If the D path is not set please use the D_PATH variable")
	message(STATUS "    ie - export D_PATH=\"/opt/dmd\"")
	file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
		"Determining if the D compiler works failed with "
		"the following output:\n${OUTPUT}\n\n")
	message(FATAL_ERROR "The D compiler \"${CMAKE_D_COMPILER}\" "
		"is not able to compile a simple test program.\nIt fails "
		"with the following output:\n ${OUTPUT}\n\n"
		"CMake will not be able to correctly generate this project.")
else(NOT CMAKE_D_COMPILER_WORKS)
	if(C_TEST_WAS_RUN)
		message(STATUS "Check for working D compiler: ${CMAKE_D_COMPILER} -- works")
		file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
			"Determining if the D compiler works passed with "
			"the following output:\n${OUTPUT}\n\n") 
	endif(C_TEST_WAS_RUN)
	set(CMAKE_D_COMPILER_WORKS 1 CACHE INTERNAL "")
endif(NOT CMAKE_D_COMPILER_WORKS)

if(NOT CMAKE_D_PHOBOS_WORKS)
	message(STATUS "Check for working Phobos")
	file(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
		"import std.stdio;\n"
		"int main(char[][] args)\n"
		"{ writefln(\"%s\", args[0]); return args.sizeof-1;}\n")
	if(CMAKE_D_COMPILER_ID STREQUAL "DMD")
		if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
			try_compile(CMAKE_D_PHOBOS_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
				OUTPUT_VARIABLE OUTPUT) 
		else(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
			try_compile(CMAKE_D_PHOBOS_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
				CMAKE_FLAGS "-DLINK_LIBRARIES=${D_PATH}/lib/libphobos.a"
				COMPILE_DEFINITIONS "-I${D_PATH}/include -I${D_PATH}/import"
				OUTPUT_VARIABLE OUTPUT) 
		endif(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	endif(CMAKE_D_COMPILER_ID STREQUAL "DMD")
	set(C_TEST_WAS_RUN 1)
endif(NOT CMAKE_D_PHOBOS_WORKS)

if(NOT CMAKE_D_PHOBOS_WORKS)
	message(STATUS "Check for working Phobos -- unavailable")
	file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
		"Determining if Phobos works failed with "
		"the following output:\n${OUTPUT}\n\n")
	#MESSAGE(FATAL_ERROR "Phobos does not work")
else(NOT CMAKE_D_PHOBOS_WORKS)
	if(C_TEST_WAS_RUN)
		message(STATUS "Check for working Phobos -- works")
		file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
			"Determining if Phobos works passed with "
			"the following output:\n${OUTPUT}\n\n") 
	endif(C_TEST_WAS_RUN)
	set(CMAKE_D_PHOBOS_WORKS 1 CACHE INTERNAL "")
endif(NOT CMAKE_D_PHOBOS_WORKS)

IF(NOT CMAKE_D_TANGO_WORKS)
  MESSAGE(STATUS "Check for working Tango")
  FILE(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
    "import tango.io.Stdout;"
    "int main(char[][] args)\n"
    "{Stdout.newline();return args.sizeof-1;}\n")
  IF(CMAKE_COMPILER_IS_GDC)
	  TRY_COMPILE(CMAKE_D_TANGO_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
	     CMAKE_FLAGS "-DLINK_LIBRARIES=gtango"
	     OUTPUT_VARIABLE OUTPUT) 
  ELSE(CMAKE_COMPILER_IS_GDC)
      IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	  TRY_COMPILE(CMAKE_D_TANGO_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
	     OUTPUT_VARIABLE OUTPUT) 
      ELSE(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	  TRY_COMPILE(CMAKE_D_TANGO_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testDCompiler.d
	     CMAKE_FLAGS "-DLINK_LIBRARIES=${D_PATH}/lib/libtango.a;${D_PATH}/lib/libphobos.a"
	     COMPILE_DEFINITIONS "-I${D_PATH}/include -I${D_PATH}/import"
	     OUTPUT_VARIABLE OUTPUT) 
      ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  ENDIF(CMAKE_COMPILER_IS_GDC)
  SET(C_TEST_WAS_RUN 1)
ENDIF(NOT CMAKE_D_TANGO_WORKS)

IF(NOT CMAKE_D_TANGO_WORKS)
  MESSAGE(STATUS "Check for working Tango -- unavailable")
  FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if Tango works failed with "
    "the following output:\n${OUTPUT}\n\n")
  #MESSAGE(FATAL_ERROR "Tango does not work: \n${OUTPUT}\n\n")
ELSE(NOT CMAKE_D_TANGO_WORKS)
  IF(C_TEST_WAS_RUN)
    MESSAGE(STATUS "Check for working Tango -- works")
    FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if Tango works passed with "
      "the following output:\n${OUTPUT}\n\n") 
  ENDIF(C_TEST_WAS_RUN)
  SET(CMAKE_D_TANGO_WORKS 1 CACHE INTERNAL "")
ENDIF(NOT CMAKE_D_TANGO_WORKS)

# if both tango and phobos are selected try to choose which one is available
IF(CMAKE_D_USE_TANGO AND CMAKE_D_USE_PHOBOS)
	MESSAGE(FATAL_ERROR "Tango AND Phobos selected, please choose one or the other!")
ENDIF(CMAKE_D_USE_TANGO AND CMAKE_D_USE_PHOBOS)

# ensure the user has the appropriate std lib available
IF(CMAKE_D_USE_TANGO AND NOT CMAKE_D_TANGO_WORKS)
	MESSAGE(FATAL_ERROR "Tango is required for this project, but it is not available!")
ENDIF(CMAKE_D_USE_TANGO AND NOT CMAKE_D_TANGO_WORKS)

IF(CMAKE_D_USE_PHOBOS AND NOT CMAKE_D_PHOBOS_WORKS)
	MESSAGE(FATAL_ERROR "Phobos is required for this project, but it is not available!")
ENDIF(CMAKE_D_USE_PHOBOS AND NOT CMAKE_D_PHOBOS_WORKS)

