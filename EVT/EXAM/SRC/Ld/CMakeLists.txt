cmake_minimum_required(VERSION 3.23)

set(lib ld)
add_library(${lib} INTERFACE)
# Linker script
# https://musteresel.github.io/posts/2019/10/cmake-install-linker-script-relative-path.html
target_link_options(${lib}
	INTERFACE
	$<BUILD_INTERFACE:-T${CMAKE_CURRENT_SOURCE_DIR}/Link.ld>
	$<INSTALL_INTERFACE:-Tch32v006.ld>
)
target_link_directories(${lib}
	INTERFACE
	$<INSTALL_INTERFACE:ld/ch32v00x>
)

# set the target's folder (for IDEs that support it, e.g. Visual Studio)
set_target_properties(${lib} PROPERTIES FOLDER "${PROJECT_NAME}")

add_library(ch32v00x::ld ALIAS ${lib})
