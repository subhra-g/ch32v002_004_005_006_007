cmake_minimum_required(VERSION 3.23)

function(preprocess_linker_script input_file mcu output_file)
	string(TOUPPER "${mcu}" _mcu)

	if(_mcu MATCHES "^CH32V002")
		set(_flash_length 16K)
		set(_ram_length 4K)
	elseif(_mcu MATCHES "^CH32V00[45]")
		set(_flash_length 32K)
		set(_ram_length 6K)
	elseif(_mcu MATCHES "^CH32V00[67]" OR _mcu MATCHES "^CH32M007")
		set(_flash_length 62K)
		set(_ram_length 8K)
	else()
		message(FATAL_ERROR "Cannot select linker memory sizes for unsupported MCU '${mcu}'.")
	endif()

	file(READ "${input_file}" _linker_script)
	string(FIND "${_linker_script}" "MEMORY" _memory_start)
	if(_memory_start EQUAL -1)
		message(FATAL_ERROR "No MEMORY block found in linker script '${input_file}'.")
	endif()

	string(SUBSTRING "${_linker_script}" ${_memory_start} -1 _memory_tail)
	string(FIND "${_memory_tail}" "{" _memory_open)
	if(_memory_open EQUAL -1)
		message(FATAL_ERROR "Malformed MEMORY block in linker script '${input_file}'.")
	endif()
	string(SUBSTRING "${_memory_tail}" ${_memory_open} -1 _memory_after_open)
	string(FIND "${_memory_after_open}" "}" _memory_close_after_open)
	if(_memory_close_after_open EQUAL -1)
		message(FATAL_ERROR "Malformed MEMORY block in linker script '${input_file}'.")
	endif()

	math(EXPR _memory_close "${_memory_open} + ${_memory_close_after_open}")
	math(EXPR _memory_end "${_memory_start} + ${_memory_close}")
	math(EXPR _prefix_length "${_memory_start}")
	math(EXPR _suffix_start "${_memory_end} + 1")
	string(SUBSTRING "${_linker_script}" 0 ${_prefix_length} _prefix)
	string(SUBSTRING "${_linker_script}" ${_suffix_start} -1 _suffix)

	set(_memory_block "MEMORY\n{\n\tFLASH (rx) : ORIGIN = 0x00000000, LENGTH = ${_flash_length}\n\tRAM (xrw) : ORIGIN = 0x20000000, LENGTH = ${_ram_length}\n}")
	get_filename_component(_output_directory "${output_file}" DIRECTORY)
	file(MAKE_DIRECTORY "${_output_directory}")
	file(WRITE "${output_file}" "${_prefix}${_memory_block}${_suffix}")
endfunction()

set(lib ld)
add_library(${lib} INTERFACE)

string(TOLOWER "${MCU_FAMILY}" _mcu_family_lower)
set(CH32V00X_LINKER_SCRIPT "${PROJECT_BINARY_DIR}/ld/${_mcu_family_lower}.ld")
preprocess_linker_script(
	"${CMAKE_CURRENT_SOURCE_DIR}/Link.ld"
	"${MCU}"
	"${CH32V00X_LINKER_SCRIPT}"
)

# Linker script
# https://musteresel.github.io/posts/2019/10/cmake-install-linker-script-relative-path.html
target_link_options(${lib}
	INTERFACE
	$<BUILD_INTERFACE:-T${CH32V00X_LINKER_SCRIPT}>
	$<INSTALL_INTERFACE:-T${_mcu_family_lower}.ld>
)
target_link_directories(${lib}
	INTERFACE
	$<INSTALL_INTERFACE:ld/ch32v00x>
)

# set the target's folder (for IDEs that support it, e.g. Visual Studio)
set_target_properties(${lib} PROPERTIES FOLDER "${PROJECT_NAME}")

add_library(ch32v00x::ld ALIAS ${lib})
