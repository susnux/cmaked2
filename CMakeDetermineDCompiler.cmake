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
# Modified from CMake 2.6.5 CMakeDetermineCCompiler.cmake
# See http://www.cmake.org/HTML/Copyright.html for details
#

# determine the compiler to use for D programs
if(NOT CMAKE_D_COMPILER)

  # prefer the environment variable DC
	if($ENV{DC} MATCHES ".+")
		get_filename_component(CMAKE_D_COMPILER_INIT $ENV{DC} PROGRAM PROGRAM_ARGS CMAKE_D_FLAGS_ENV_INIT)
		if(CMAKE_D_FLAGS_ENV_INIT)
			set(CMAKE_D_COMPILER_ARG1 "${CMAKE_D_FLAGS_ENV_INIT}" CACHE STRING "First argument to D compiler")
		endif(CMAKE_D_FLAGS_ENV_INIT)
		if(NOT EXISTS ${CMAKE_D_COMPILER_INIT})
			message(FATAL_ERROR "Could not find compiler set in environment variable DC:\n$ENV{DC}.") 
		endif(EXISTS ${CMAKE_D_COMPILER_INIT})
	endif($ENV{DC} MATCHES ".+")

	# next try prefer the compiler specified by the generator
	if(CMAKE_GENERATOR_D) 
		if(NOT CMAKE_D_COMPILER_INIT)
		set(CMAKE_D_COMPILER_INIT ${CMAKE_GENERATOR_D})
		endif(NOT CMAKE_D_COMPILER_INIT)
	endif(CMAKE_GENERATOR_D)

	# finally list compilers to try
	if(CMAKE_D_COMPILER_INIT)
		set(CMAKE_D_COMPILER_LIST ${CMAKE_D_COMPILER_INIT})
	else(CMAKE_D_COMPILER_INIT)
		set(CMAKE_D_COMPILER_LIST dmd ldc2)  
	endif(CMAKE_D_COMPILER_INIT)

	# Find the compiler.
	find_program(CMAKE_D_COMPILER NAMES ${CMAKE_D_COMPILER_LIST} DOC "C compiler")
	if(CMAKE_D_COMPILER_INIT AND NOT CMAKE_D_COMPILER)
		set(CMAKE_D_COMPILER "${CMAKE_D_COMPILER_INIT}" CACHE FILEPATH "C compiler" FORCE)
	endif(CMAKE_D_COMPILER_INIT AND NOT CMAKE_D_COMPILER)
endif(NOT CMAKE_D_COMPILER)

mark_as_advanced(CMAKE_D_COMPILER)  

# Some toolchain stuff
get_filename_component(COMPILER_LOCATION "${CMAKE_D_COMPILER}" PATH)

find_program(CMAKE_AR NAMES ar PATHS ${COMPILER_LOCATION} )
mark_as_advanced(CMAKE_AR)

find_program(CMAKE_RANLIB NAMES ranlib)
if(NOT CMAKE_RANLIB)
	set(CMAKE_RANLIB : CACHE INTERNAL "noop for ranlib")
endif(NOT CMAKE_RANLIB)
mark_as_advanced(CMAKE_RANLIB)

if("${CMAKE_D_COMPILER}" MATCHES ".*dmd.*" )
	set(CMAKE_D_COMPILER_ID DMD)
	file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
		"Determining if the D compiler is DMD succeeded with "
		"the following output:\n${CMAKE_D_COMPILER}\n\n")
elseif("${CMAKE_D_COMPILER}" MATCHES ".*ldc.*" )
	set(CMAKE_D_COMPILER_ID LDC)
	file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
		"Determining if the D compiler is LDC succeeded with "
		"the following output:\n${CMAKE_D_COMPILER}\n\n")
endif()

# configure variables set in this file for fast reload later on
configure_file(${CMAKE_ROOT}/Modules/CMakeDCompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeDCompiler.cmake @ONLY)

# We need to define which env variable is used for the compiler
set(CMAKE_D_COMPILER_ENV_VAR "DC")
