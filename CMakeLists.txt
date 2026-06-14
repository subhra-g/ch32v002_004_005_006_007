#[[
CONFIGURATIONS:
- MCU:
		CH32V006K8 (for CH32V006K8U7)
		CH32V006E8 (for CH32V006E8R6 and CH32V006E8R7)
		CH32V006F8 (for CH32V006F8U7 and CH32V006F8P7)
    CH32V006F4 (for CH32V006F4U6)
    CH32V006D8 (for CH32V006D8U7)
    CH32V005E6 (for CH32V005E6R6)
    CH32V005F6 (for CH32V005F6U6 and CH32V005F6P6)
    CH32V005D6 (for CH32V005D6U6)
		If none defined, SDK will set the default one. The default in SDK can be controlled by commenting/uncommenting line.
- HSE_VALUE:
- INTSYSCR_INEST: Interrupt nesting
  Values:
    - INTSYSCR_INEST_NoEN : Interrupt nesting disabled
    - INTSYSCR_INEST_EN   : Interrupt nesting enable

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
#]]

cmake_minimum_required(VERSION 3.23)

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
set(MCU_FAMILY CH32V006)
if(NOT DEFINED MCU)
	set(MCU CH32V006F8)
	message(WARNING "MCU not defined for CH32V00x HAL.\n"
	                "Allowed MCUs are...\n"
                  "    CH32V006K8 - For CH32V006K8U7\n"
                  "    CH32V006E8 - For CH32V006E8R6 and CH32V006E8R7\n"
                  "    CH32V006F8 - For CH32V006F8U7 and CH32V006F8P7\n"
                  "    CH32V006F4 - For CH32V006F4U6\n"
                  "    CH32V006D8 - For CH32V006D8U7\n"
                  # "    CH32V005E6 - For CH32V005E6R6\n"
                  # "    CH32V005F6 - For CH32V005F6U6 and CH32V005F6P6\n"
                  # "    CH32V005D6 - For CH32V005D6U6\n"
									"Assuming ${MCU}.\n")
else()
	string(TOUPPER ${MCU} MCU_UPPER)
	if(NOT MCU_UPPER IN_LIST supported_mcus)
		message(FATAL_ERROR "Invalid MCU ${MCU}. Use one of the following\n"
                        "    CH32V006K8 - For CH32V006K8U7\n"
                        "    CH32V006E8 - For CH32V006E8R6 and CH32V006E8R7\n"
                        "    CH32V006F8 - For CH32V006F8U7 and CH32V006F8P7\n"
                        "    CH32V006F4 - For CH32V006F4U6\n"
                        "    CH32V006D8 - For CH32V006D8U7\n"
                        # "    CH32V005E6 - For CH32V005E6R6\n"
                        # "    CH32V005F6 - For CH32V005F6U6 and CH32V005F6P6\n"
                        # "    CH32V005D6 - For CH32V005D6U6\n"
                        )
	endif()
endif()
message(STATUS "MCU (${MCU}) and family (${MCU_FAMILY}) will be added to compile definition.")

# This is the manufacturer provided HAL.
add_subdirectory(EVT/EXAM)

# Don't setup installation when the project is not build standalone(e.g. `FetchContent`).
if(PROJECT_IS_TOP_LEVEL)
	message(STATUS "${PROJECT_DESCRIPTION} (${PROJECT_NAME}) is being build as top project")
	include(cmake/install.cmake)
endif()
