set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR RISCV)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(TOOLCHAIN_TRIPLET riscv-none-elf-)
cmake_path(APPEND toolchain_path ${TOOLCHAIN_TRIPLET} OUTPUT_VARIABLE pathWithTriplet)

set(CMAKE_C_COMPILER ${pathWithTriplet}gcc${CMAKE_HOST_EXECUTABLE_SUFFIX})
set(CMAKE_CXX_COMPILER ${pathWithTriplet}g++${CMAKE_HOST_EXECUTABLE_SUFFIX})
#set(CMAKE_ASM_COMPILER ${pathWithTriplet}-gcc{CMAKE_HOST_EXECUTABLE_SUFFIX})
# CMake doesn't have a variable for 'size'. So create one.
set(CMAKE_SIZE ${pathWithTriplet}size${CMAKE_HOST_EXECUTABLE_SUFFIX})
