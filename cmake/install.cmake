# Include for 
#	CMAKE_INSTALL_INCLUDEDIR  => usually 'include'
#	CMAKE_INSTALL_LIBDIR      => usually 'lib'
#	CMAKE_INSTALL_BINDIR      => usually 'bin'
#	CMAKE_INSTALL_DATAROOTDIR => usually 'share'
include(GNUInstallDirs)

# Trying out based on https://dominikberner.ch//cmake-interface-lib/
# https://crascit.com/2016/01/31/enhanced-source-file-handling-with-target_sources/
# message(STATUS "DEBUG: CMAKE_INSTALL_INCLUDEDIR  - ${CMAKE_INSTALL_INCLUDEDIR}")
# message(STATUS "DEBUG: CMAKE_INSTALL_LIBDIR      - ${CMAKE_INSTALL_LIBDIR}")
# message(STATUS "DEBUG: CMAKE_INSTALL_BINDIR      - ${CMAKE_INSTALL_BINDIR}")
# message(STATUS "DEBUG: CMAKE_INSTALL_DATAROOTDIR - ${CMAKE_INSTALL_DATAROOTDIR}")

#[[
Installtion planning:
install_dir
  |
  +-- include
  |   |
  |   +-- ch32v00x
  |       |
  |       +-- core -> Contains headers from 'SRC/Core'
  |       +-- peripheral -> Contains headers from 'SRC/Peripheral/inc'
  |
  +-- startup
  |   |
	|   +--ch32v00x
  |      |
  |      +-- ch32v002.S -> ch32v002 Startup file
  |      +-- ch32v004.S -> ch32v004 Startup file
  |      +-- ch32v005.S -> ch32v005 Startup file
  |      +-- ch32v006.S -> ch32v006 Startup file
  |      +-- ch32v007.S -> ch32v007 Startup file
  |
  +-- lib
  |   |
  |   +-- ch32v002 -> Contains ch32v002 archives/static libs
  |   +-- ch32v004 -> Contains ch32v004 archives/static libs
  |   +-- ch32v005 -> Contains ch32v005 archives/static libs
  |   +-- ch32v006 -> Contains ch32v006 archives/static libs
  |   +-- ch32v007 -> Contains ch32v007 archives/static libs
  |
  +-- ld
  |   |
	|   +--ch32v00x
  |      |
  |      +-- ch32v002.ld -> Contains ch32v002 linker script
  |      +-- ch32v004.ld -> Contains ch32v004 linker script
  |      +-- ch32v005.ld -> Contains ch32v005 linker script
  |      +-- ch32v006.ld -> Contains ch32v006 linker script
  |      +-- ch32v007.ld -> Contains ch32v007 linker script
  |
  +-- share
      |
      +-- cmake -> Contains cmake scripts. use this path for find_package
#]]

install(
	TARGETS core peripheral startupLib startup ld debug-print.sdi
		${install_debug_print_target}
	EXPORT ch32v00xhal_Targets
	# INCLUDES DESTINATION include/ch32v008 # For include files => ${CMAKE_INSTALL_INCLUDEDIR}
	#	PUBLIC_HEADER DESTINATION include/ch32v008
	# HEADER DESTINATION  include/ch32v008
	# INTERFACE_SOURCES DESTINATION include/ch32v008
	ARCHIVE DESTINATION lib/ch32v006      # For static libs   => ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION lib               # For dyamic libs   => ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION bin               # For executables   => ${CMAKE_INSTALL_BINDIR}
)
include(CMakePackageConfigHelpers)
write_basic_package_version_file("ch32v00xhalConfigVersion.cmake"
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
	"${PROJECT_SOURCE_DIR}/cmake/ch32v00xhalConfig.cmake.in"
	"${PROJECT_BINARY_DIR}/ch32v00xhalConfig.cmake"
	INSTALL_DESTINATION
	${CMAKE_INSTALL_DATAROOTDIR}/cmake
)

install(EXPORT ch32v00xhal_Targets
	FILE ch32v00xhalTargets.cmake
	NAMESPACE ch32v00x::
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/cmake
)

install(
	FILES "${PROJECT_BINARY_DIR}/ch32v00xhalConfig.cmake"
	      "${PROJECT_BINARY_DIR}/ch32v00xhalConfigVersion.cmake"
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/cmake
)

# REVIEW: Is there no way to do it automatically, like the PUBLIC sources?
install(FILES ${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/core/core_riscv.h DESTINATION include/ch32v00x/core)
install(FILES ${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/debug/debug.h DESTINATION include/ch32v00x/debug)
# Following copies 'inc' directory in 'peripheral' creating 'peripheral/inc' path
# install(DIRECTORY ${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc DESTINATION include/ch32v00x/peripheral)
list(APPEND peripheral_inc
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_adc.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_dbgmcu.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_dma.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_exti.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_flash.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_gpio.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_i2c.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_iwdg.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_misc.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_opa.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_pwr.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_rcc.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_spi.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_tim.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_usart.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_wwdg.h
	${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Peripheral/inc/ch32v00X_conf.h
)
install(FILES ${peripheral_inc} DESTINATION include/ch32v00x/peripheral)
install(FILES ${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Startup/startup_ch32v00X.S DESTINATION startup/ch32v00x RENAME ch32v006.S)
# ToDo: CH32V006 is default in the linker script. For other MCUs, it needs to be processed (uncomment
#       relevant section, comment/remove irrelevant sections). But for now, it is fine since I don't
#       have any of the other MCUs.
install(FILES ${PROJECT_SOURCE_DIR}/EVT/EXAM/SRC/Ld/Link.ld DESTINATION ld/ch32v00x RENAME ch32v006.ld)
install(FILES ${PROJECT_SOURCE_DIR}/Targets.md DESTINATION docs RENAME ch32v002_004_005_006_007-Targets.md)
