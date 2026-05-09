cmake_minimum_required(VERSION 3.23)

set(lib_name ch32v00x.peripheral)

add_library(${lib_name} STATIC)

# HAL Peripherals
target_sources(${lib_name}
	PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_adc.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_dbgmcu.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_dma.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_exti.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_flash.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_gpio.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_i2c.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_iwdg.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_misc.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_opa.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_pwr.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_rcc.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_spi.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_tim.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_usart.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00x_wwdg.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_conf.h>
	# Install location for following files needs to be in include/Peripheral
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_adc.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_dbgmcu.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_dma.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_exti.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_flash.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_gpio.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_i2c.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_iwdg.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_misc.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_opa.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_pwr.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_rcc.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_spi.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_tim.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_usart.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00x_wwdg.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_conf.h>
	PRIVATE
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_adc.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_dbgmcu.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_dma.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_exti.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_flash.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_gpio.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_i2c.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_iwdg.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_misc.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_opa.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_pwr.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_rcc.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_spi.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_tim.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_usart.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00x_wwdg.c"
)

target_include_directories(${lib_name}
	PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc>
	$<INSTALL_INTERFACE:include>
	$<INSTALL_INTERFACE:include/ch32v003/peripheral>
)

# Processor Arch related
target_compile_options(${lib_name} PUBLIC -mno-save-restore)

# Optimization. Intentionally kept private.
target_compile_options(${lib_name} PRIVATE -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common)
target_compile_options(${lib_name} PRIVATE -msmall-data-limit=8)
# target_compile_options(${lib_name} PRIVATE -Os)

# Debugging
# target_compile_options(${lib_name} PRIVATE $<$<CONFIG:Debug>:-g>)

# Linker
target_link_options(${lib_name} PUBLIC -mno-save-restore)
#target_link_options(${lib_name} PUBLIC -Xlinker --gc-sections)
target_link_libraries(${lib_name} PUBLIC hal::core)

add_library(hal::peripheral ALIAS ${lib_name})
