cmake_minimum_required(VERSION 3.23)

#[=============================================================================[
Compiler definitions:
- DEBUG: Set the UART to be used for debug log
    Tx-PD5: DEBUG_UART1_NoRemap/1
    Tx-PD6: DEBUG_UART1_Remap1 /2
    Tx-PD0: DEBUG_UART1_Remap2 /3
    Tx-PC0: DEBUG_UART1_Remap3 /4
    Tx-PD1: DEBUG_UART1_Remap4 /5
    Tx-PB3: DEBUG_UART1_Remap5 /6
    Tx-PC5: DEBUG_UART1_Remap6 /7
    Tx-PB5: DEBUG_UART1_Remap7 /8
    Tx-PA0: DEBUG_UART1_Remap8 /9
  Only for V005, V006, V007, M007 series
    Tx-PA7: DEBUG_UART2_NoRemap/10
    Tx-PA4: DEBUG_UART2_Remap1 /11
    Tx-PA2: DEBUG_UART2_Remap2 /12
    Tx-PD2: DEBUG_UART2_Remap3 /13
    Tx-PB0: DEBUG_UART2_Remap4 /14
    Tx-PC4: DEBUG_UART2_Remap5 /15
    Tx-PA6: DEBUG_UART2_Remap6 /16
- SDI_PRINT: Enable/disable debug log using SDI
    0: Disabled. Default
    1: Enabled

Usage instruction:
Using CMake,
1. [ToDo: Not required. Delete it.] create a target `ch32v00x_config`. This target must have include path for ch32v00x_conf.h and system_ch32v00x.h.
2. Use `FetchContent`.
    include(FetchContent)
    FetchContent_Declare(ch32v00x
      SOURCE_DIR "PATH/TO/SDK" # e.g ${HOME}/dev/libs/ch32v002_004_005_006_007
      CMAKE_ARGS "-DMCU=${CH32V006F8P}"
      EXCLUDE_FROM_ALL
      SYSTEM
    )
    Fetchcontent_MakeAvailable(ch32v00x)
3. The main application needs to have a function `SystemInit` defined. This function is expected to be
   called from the startup file. The function can be defined in the main application or in a target
   which is linked with the main application. The function is expected to initialize the system clock
   and other system related initializations. Refer to the examples in the SDK for more details.
4. WHen using one of the debug-print target, it requires `SystemCoreClock` to be defined and initialzed
   with proper System Clock Frequency (Core Clock) information. Take reference from any of the system_ch32v00X.c
   from included SDK examples.
#]=============================================================================]

function(print_hal_config)
	message(STATUS
		"CONFIGURATIONS:\n"
		"- MCU: \n"
		"    CH32V006K8 (for CH32V006K8U7)\n"
		"    CH32V006E8 (for CH32V006E8R6 and CH32V006E8R7)\n"
		"    CH32V006F8 (for CH32V006F8U7 and CH32V006F8P7)\n"
		"    CH32V006F4 (for CH32V006F4U6)\n"
		"    CH32V006D8 (for CH32V006D8U7)\n"
		"    CH32V005E6 (for CH32V005E6R6)\n"
		"    CH32V005F6 (for CH32V005F6U6 and CH32V005F6P6)\n"
		"    CH32V005D6 (for CH32V005D6U6)\n"
		"    SDK will set the default one if none defined. The default in SDK can be controlled by commenting/uncommenting line.\n"
		"- HSE_VALUE: Value of the External oscillator in Hz\n"
		"    Default 24000000\n"
		"- INTSYSCR_INEST: Interrupt nesting\n"
		"    INTSYSCR_INEST_NoEN: Interrupt nesting disabled\n"
		"    INTSYSCR_INEST_EN  : Interrupt nesting enable\n"
	)
endfunction()

project("ch32v00xhal" VERSION 1.4.0 # CH32V00X Standard Peripheral Library version number from ch32v00X.h
		DESCRIPTION "Standard Peripheral Library for CH32V002/004/005/006/007 MCUs"
		HOMEPAGE_URL "https://github.com/openwch/ch32v002_004_005_006_007"
		LANGUAGES C CXX ASM)

# Don't include MCU specific options when the project is not build standalone(e.g. `FetchContent`).
# In that case Toolchain, MCU etc. should be provided by or inherited from the parent project.
# if(PROJECT_IS_TOP_LEVEL)
# 	# ToDo: Need to accomodate other supported MCUs by this SDK.
# 	include(cmake/CH32V006F8P.cmake)
# endif()

set(supported_mcus CH32V006K8 CH32V006E8 CH32V006F8 CH32V006F4 CH32V006D8 CH32V005E6 CH32V005F6 CH32V005D6)
#set(MCU_FAMILY CH32V006)
if(NOT DEFINED MCU)
	set(MCU CH32V006F8)
	message(WARNING "MCU not defined for CH32V00x HAL.\n"
	                "Allowed MCUs are...\n"
                  "    CH32V006K8 - For CH32V006K8U7\n"
                  "    CH32V006E8 - For CH32V006E8R6 and CH32V006E8R7\n"
                  "    CH32V006F8 - For CH32V006F8U7 and CH32V006F8P7\n"
                  "    CH32V006F4 - For CH32V006F4U6\n"
                  "    CH32V006D8 - For CH32V006D8U7\n"
                  "    CH32V005E6 - For CH32V005E6R6\n"
                  "    CH32V005F6 - For CH32V005F6U6 and CH32V005F6P6\n"
                  "    CH32V005D6 - For CH32V005D6U6\n"
                  "Assuming ${MCU}.\n")
else()
	string(TOUPPER ${MCU} MCU_UPPER)
	if(NOT MCU_UPPER IN_LIST supported_mcus)
		print_hal_config()
		message(FATAL_ERROR "Check the MCU.")
	endif()
endif()

string(REGEX MATCH CH32V00[24567] MCU_FAMILY ${MCU})
message(STATUS "MCU (${MCU}) and family (${MCU_FAMILY}) will be added to compile definition.")

# This is the manufacturer provided HAL.
add_subdirectory(EVT/EXAM)

# Don't setup installation when the project is not build standalone(e.g. `FetchContent`).
if(PROJECT_IS_TOP_LEVEL)
	message(STATUS "${PROJECT_DESCRIPTION} (${PROJECT_NAME}) is being build as top project")
	include(cmake/install.cmake)
endif()
