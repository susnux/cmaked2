#
# CMakeD2 - CMake module for D(2) Language
#
# Copyright (c) 2015, Ferdinand Thiessen <rpm@fthiessen.de>
# Copyright (c) 2007, Selman Ulug <selman.ulug@gmail.com>
#                     Tim Burrell <tim.burrell@gmail.com>
#
# All rights reserved.
#
# See LICENSE for details.
#
cmake_minimum_required(VERSION 2.8)
project(cmaked NONE)

set(MOD_SRCS
	CMakeDCompiler.cmake.in        
	CMakeDInformation.cmake        
	CMakeTestDCompiler.cmake  
	CMakeDetermineDCompiler.cmake  
	UseDDoc.cmake
)

set(PLAT_SRCS
	Platform/Linux-DMD.cmake
	Platform/Windows-DMD.cmake
	Platform/Linux-LDC.cmake
)

set(COMP_SRCS
	Compiler/DMD-D.cmake
	Compiler/LDC-D.cmake
)

install(FILES ${MOD_SRCS} DESTINATION ${CMAKE_ROOT}/Modules)
install(FILES ${PLAT_SRCS} DESTINATION ${CMAKE_ROOT}/Modules/Platform)
install(FILES ${COMP_SRCS} DESTINATION ${CMAKE_ROOT}/Modules/Compiler)
