cmake_minimum_required(VERSION 3.15)

# TODO: The Debug library has dependency on system_ch32v00x.h and ch32v00x_conf.h.
#       system_ch32v00x.h sets the system clock, hence it is dependent on the board (i.e.
#       the main application). This is sort of circular dependency i.e. the application
#       depends on peripheral lib and peripheral lib depends on application specific info.
#       How to break the circular dependency???
# message(WARNING "The Debug library has dependency on system_ch32v00x.h and ch32v00x_conf.h. system_ch32v00x.h sets the system clock, hence it is dependent on the board (i.e. the main application).")

list(APPEND uart_options pd5 pd6 pd0 pc0 pd1 pb3 pc5 pb5 pa0)
list(APPEND compile_options DEBUG_UART1_NoRemap DEBUG_UART1_Remap1 DEBUG_UART1_Remap2 DEBUG_UART1_Remap3 DEBUG_UART1_Remap4 DEBUG_UART1_Remap5 DEBUG_UART1_Remap6 DEBUG_UART1_Remap7 DEBUG_UART1_Remap8)

# Applies to CH32V005, CH32V006, CH32V007 and CH32M007 `defined(CH32V007_M007)`
list(APPEND uart_options pa7 pa4 pa2 pd2 pb0 pc4 pa6)
list(APPEND compile_options DEBUG_UART2_NoRemap DEBUG_UART2_Remap1 DEBUG_UART2_Remap2 DEBUG_UART2_Remap3 DEBUG_UART2_Remap4 DEBUG_UART2_Remap5 DEBUG_UART2_Remap6)

set(all_debug_print_target "")
foreach(uart compile_opt IN ZIP_LISTS uart_options compile_options)
	message(DEBUG "${uart}: ${compile_opt}")

	set(lib debug-print.uart.${uart})
	add_library(${lib} STATIC)
	list(APPEND all_debug_print_target ${lib})

	target_sources(${lib}
		PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/debug.h>
		$<INSTALL_INTERFACE:include/ch32v00x/debug/debug.h>
		PRIVATE
		"${CMAKE_CURRENT_SOURCE_DIR}/debug.c"
	)

	target_include_directories(${lib}
		PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
		$<INSTALL_INTERFACE:include>
		$<INSTALL_INTERFACE:include/ch32v00x/debug>
	)
	target_compile_definitions(${lib} PUBLIC DEBUG=${compile_opt})
	target_compile_options(${lib} PUBLIC -mno-save-restore)
	# Optimization
	target_compile_options(${lib} PRIVATE -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common)
	target_compile_options(${lib} PUBLIC -msmall-data-limit=8)
	# Debugging and optimization
	# target_compile_options(${lib} PRIVATE -Os)
	# target_compile_options(${lib} PRIVATE $<$<CONFIG:Debug>:-g>)
	target_link_options(${lib} PUBLIC -msave-restore)
	target_link_libraries(${lib}
		PUBLIC
		$<BUILD_INTERFACE:peripheral>
		$<INSTALL_INTERFACE:ch32v00x::peripheral>
	)
	target_link_directories(${lib}
		INTERFACE
		$<INSTALL_INTERFACE:lib/ch32v00x>
	)

	add_library(ch32v00x::${lib} ALIAS ${lib})
	set_target_properties(${lib} PROPERTIES FOLDER "${PROJECT_NAME}/Debug")

	message(DEBUG "Created target: ch32v00x::${lib} (${lib})")

endforeach()

if(PROJECT_IS_TOP_LEVEL)
	# Prepare for installation when project is built standalone.
	set(install_debug_print_target ${all_debug_print_target} CACHE INTERNAL "All debug-print targets") # For installation.
endif()
# --------------------------------------------------------------------------------------------------

set(lib debug-print.sdi)
add_library(${lib} STATIC)

target_sources(${lib}
	PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/debug.h>
	$<INSTALL_INTERFACE:include/ch32v00x/debug/debug.h>
	PRIVATE
	"${CMAKE_CURRENT_SOURCE_DIR}/debug.c"
)

target_include_directories(${lib}
	PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
	$<INSTALL_INTERFACE:include/>
	$<INSTALL_INTERFACE:include/ch32v00x/debug>
)
# Processor Arch related
target_compile_definitions(${lib} PUBLIC SDI_PRINT=SDI_PR_OPEN)
target_compile_options(${lib} PUBLIC -msave-restore)
# Optimization
target_compile_options(${lib} PRIVATE -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common)
target_compile_options(${lib} PUBLIC -msmall-data-limit=8)
# Debugging and Optimization
# target_compile_options(${lib} PRIVATE -Os)
# target_compile_options(${lib} PRIVATE $<$<CONFIG:Debug>:-g>)
target_link_options(${lib} PUBLIC -msave-restore)
target_link_libraries(${lib}
	PUBLIC
	$<BUILD_INTERFACE:peripheral>
	$<INSTALL_INTERFACE:ch32v00x::peripheral>
)
target_link_directories(${lib}
	INTERFACE
	$<INSTALL_INTERFACE:lib/ch32v00x>
)

# set the target's folder (for IDEs that support it, e.g. Visual Studio)
set_target_properties(${lib} PROPERTIES FOLDER "${PROJECT_NAME}/Debug")
add_library(ch32v00x::${lib} ALIAS ${lib})
