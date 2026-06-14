set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(TOOLCHAIN_TRIPLET riscv-none-elf)
cmake_path(APPEND toolchain_path ${TOOLCHAIN_TRIPLET} OUTPUT_VARIABLE pathWithTriplet)

if(NOT RISCV_ARCH)
  message(WARNING "RISC-V acrichitecture is not set. Set RISCV_ARCH (-march)")
endif()
if(NOT RISCV_ABI)
  message(WARNING "RISC-V ABI is not set. Set RISCV_ARCH (-mabi)")
endif()
if(NOT FPU_FLAGS)
  message(TRACE "Optional FPU_FLAGS variable for cross-compilation is not set. Ignore this if MCU doesn't support Floating-point.")
endif()

set(common_riscv_opt "-mcmodel=medany")
set(CMAKE_C_COMPILER ${pathWithTriplet}-gcc${CMAKE_HOST_EXECUTABLE_SUFFIX} CACHE FILEPATH "GNU C Compiler")
set(CMAKE_CXX_COMPILER ${pathWithTriplet}-g++${CMAKE_HOST_EXECUTABLE_SUFFIX} CACHE FILEPATH "GNU C++ Compiler")
#set(CMAKE_ASM_COMPILER ${pathWithTriplet}-gcc{CMAKE_HOST_EXECUTABLE_SUFFIX})
# CMake doesn't have a variable for 'size'. So create one.
set(CMAKE_SIZE ${pathWithTriplet}-size${CMAKE_HOST_EXECUTABLE_SUFFIX} CACHE FILEPATH "GNU size bintools")

set(CMAKE_C_FLAGS_INIT "-march=${RISCV_ARCH} -mabi=${RISCV_ABI} ${FPU_FLAGS} ${common_riscv_opt}" CACHE INTERNAL "Default C compiler flags.")
set(CMAKE_CXX_FLAGS_INIT "-march=${RISCV_ARCH} -mabi=${RISCV_ABI} ${FPU_FLAGS} ${common_riscv_opt} -fno-exceptions -fno-unwind-tables -fno-rtti -nostdlib"  CACHE INTERNAL "Default C++ compiler flags.")
set(CMAKE_ASM_FLAGS_INIT "-march=${RISCV_ARCH} -mabi=${RISCV_ABI} ${FPU_FLAGS} ${common_riscv_opt}" CACHE INTERNAL "Default ASM compiler flags.") # -x assembler-with-cpp
set(CMAKE_EXE_LINKER_FLAGS_INIT "-march=${RISCV_ARCH} -mabi=${RISCV_ABI} ${FPU_FLAGS} ${common_all_opt}") # -Wl,--gc-sections" CACHE INTERNAL "Default linker flags.")
