# Copyright (C) 2020 XiaoMi Corporation.  All rights reserved.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set(PLATFORM_SHARED_DIR ${CMAKE_CURRENT_LIST_DIR})
set(PLATFORM_COMMON_POSIX_DIR ${CMAKE_CURRENT_LIST_DIR}/../common/posix)
add_definitions(-DBH_PLATFORM_NUTTX)

include_directories(${PLATFORM_SHARED_DIR})
include_directories(${PLATFORM_SHARED_DIR}/../include)

include(${PLATFORM_COMMON_POSIX_DIR}/platform_api_posix.cmake)

include(${SHARED_DIR}/utils/uncommon/shared_uncommon.cmake)

file(GLOB_RECURSE source_all ${PLATFORM_SHARED_DIR}/*.c)

if(WAMR_BUILD_LIBC_WASI EQUAL 1)
  list(APPEND source_all ${PLATFORM_SHARED_DIR}/../common/posix/posix_file.c)
  include(
    ${CMAKE_CURRENT_LIST_DIR}/../common/libc-util/platform_common_libc_util.cmake
  )
  set(source_all ${source_all} ${PLATFORM_COMMON_LIBC_UTIL_SOURCE})
endif()

set(PLATFORM_SHARED_SOURCE
    ${source_all} ${PLATFORM_COMMON_MATH_SOURCE}
    ${PLATFORM_COMMON_POSIX_SOURCE} ${UNCOMMON_SHARED_SOURCE})
# remove posix_memmap.c for NuttX
list(REMOVE_ITEM PLATFORM_SHARED_SOURCE
     ${PLATFORM_COMMON_POSIX_DIR}/posix_memmap.c)
list(REMOVE_ITEM PLATFORM_SHARED_SOURCE
     ${PLATFORM_COMMON_POSIX_DIR}/posix_malloc.c)