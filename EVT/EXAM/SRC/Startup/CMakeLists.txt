cmake_minimum_required(VERSION 3.23)

set(lib ch32v00x.startupLib)

add_library(${lib} STATIC)

target_sources(${lib}
	PRIVATE
	"${CMAKE_CURRENT_SOURCE_DIR}/startup_ch32v00X.S"
)

target_include_directories(${lib}
	PUBLIC
#	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#	$<INSTALL_INTERFACE:$include> # REVIEW: Does it copy the headers in this dir or this dir is added to include path? 
)

# Processor Arch related
target_compile_options(${lib} PUBLIC -mno-save-restore)

# Optimization. Intentionally kept private.
target_compile_options(${lib} PRIVATE -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common)
target_compile_options(${lib} PRIVATE -msmall-data-limit=8)
# target_compile_options(${lib} PRIVATE -Os)

# Debugging
# target_compile_options(${lib} PRIVATE $<$<CONFIG:Debug>:-g>)

# Linker options
target_link_options(${lib} PUBLIC -mno-save-restore)
#target_link_options(${lib} PUBLIC -Xlinker --gc-sections)

#[=====[
# NOTE: Usually linker script is tightly integrated with startup script. So integrating both
#       together.
# Linker script
target_link_options(${lib}
	INTERFACE
	$<BUILD_INTERFACE:"-T${CMAKE_CURRENT_SOURCE_DIR}/../Ld/Link.ld">
	$<INSTALL_INTERFACE:-TLink.ld> # This Link.ld needs to installed in 'lib/ch32v00x'
)

target_link_directories(${lib}
	INTERFACE
	$<INSTALL_INTERFACE:lib/ch32v00x/ch32v006> # ToDo: Hard coded ch32v006. Should be MCU specific.
)

add_library(hal::startup ALIAS ${lib})
#]=====]

# An interface target if app directly wants to use the script.
set(lib ch32v00x.startup)

add_library(${lib} INTERFACE)

target_sources(${lib}
	INTERFACE
	$<BUILD_INTERFACE:"${CMAKE_CURRENT_SOURCE_DIR}/startup_ch32v00X.S">
	$<INSTALL_INTERFACE:startup/ch32v00x/ch32v006.S> # This Link.ld needs to installed in 'lib/ch32v00x'
)
