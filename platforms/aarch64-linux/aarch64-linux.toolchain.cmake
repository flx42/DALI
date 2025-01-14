cmake_minimum_required(VERSION 3.5)
set(CMAKE_SYSTEM_NAME Linux) # Set it to force CMAKE_CROSSCOMPILING to true
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fexceptions -fPIC -D_XOPEN_SOURCE=600 -std=gnu++0x -L/usr/aarch64-linux-gnu/lib")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -D_XOPEN_SOURCE=600 -std=gnu99")

set(CMAKE_AS /usr/bin/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu-as)
set(CMAKE_C_COMPILER /usr/bin/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu-g++)

set(CMAKE_CXX_COMPILER_TARGET_FORCED TRUE)
set(CMAKE_C_COMPILER_TARGET_FORCED TRUE)
set(CMAKE_C_COMPILER_TARGET aarch64)
set(CMAKE_CXX_COMPILER_TARGET aarch64)
add_definitions(-D__AARCH64_GNU__)
set(CMAKE_LINKER /usr/bin/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu-ld)

set(LINKER_FLAGS "-Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now,-lc -pthread -lpthread -ldl")

set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
set(CMAKE_FIND_LIBRARY_SUFFIXES ".so,.a")

set(CMAKE_SHARED_LINKER_FLAGS "${LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS}")
set(CMAKE_MODULE_LINKER_FLAGS "${LINKER_FLAGS} ${CMAKE_MODULE_LINKER_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS}")

set(CMAKE_SYSTEM_PREFIX_PATH "/usr/aarch64-linux-gnu")

include_directories(
  ${PROTOBUF_TARGET}/include
  /usr/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu/include
  set(CMAKE_FIND_ROOT_PATH  ${AGNOSTIC_BASE})
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
)
