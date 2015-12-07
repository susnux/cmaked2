#
# CMakeD - CMake module for D Language
#
# Copyright (c) 2007, Selman Ulug <selman.ulug@gmail.com>
#                     Tim Burrell <tim.burrell@gmail.com>
#
# All rights reserved.
#
# See LICENSE for details.
#
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT (cmaked NONE)

SET (MOD_SRCS
	CMakeDCompiler.cmake.in        
	CMakeDInformation.cmake        
	CMakeTestDCompiler.cmake  
	CMakeDetermineDCompiler.cmake  
	UseDDoc.cmake
)

SET (PLAT_SRCS
	Platform/Linux-dmd.cmake
	Platform/Windows-dmd.cmake              
)

INSTALL (FILES ${MOD_SRCS} DESTINATION ${CMAKE_ROOT}/Modules)
INSTALL (FILES ${PLAT_SRCS} DESTINATION ${CMAKE_ROOT}/Modules/Platform)
