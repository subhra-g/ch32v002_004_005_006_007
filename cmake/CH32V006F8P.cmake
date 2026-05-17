# Toolchain configuration for CH32V00X family

# NOTE: May be CMAKE_<LANG>_COMPILER_VERSION will be helpfull to support some of the recent breaking change
#       in recent RISC-V GCC (commandline) options.
if(CMAKE_COMPILER_IS_GNUCC)
	# NOTE: The options should be separated by spaces, and options with spaces should be quoted.
	#set(arch_flags "-march=rv32ec_zmmul_xw -mabi=ilp32e -mcmodel=medany") # ToDo: Taken from MRS. Doesn't work with GCC12. Mostly for GCC15 only. Needs to be tested.
	set(arch_flags "-march=rv32ec -mabi=ilp32e -mcmodel=medany")
	# Compile definition for the processor family.
	set(compile_def CH32V00X CH32V006F8P)
	set(CMAKE_ASM_FLAGS "${arch_flags}")
	set(CMAKE_C_FLAGS "${arch_flags}")
	set(CMAKE_CXX_FLAGS "${arch_flags} -fno-exceptions -fno-unwind-tables -fno-rtti") # Disable RTTI and exception handling.
	add_compile_definitions(${compile_def})
	# set(CMAKE_EXE_LINKER_FLAGS "-march=rv32ec -mabi=ilp32e -mcmodel=medany")
else()
	message(FATAL_ERROR "${CMAKE_C_COMPILER_ID} Compiler is not supported yet")
endif()
