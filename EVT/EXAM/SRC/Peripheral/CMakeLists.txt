cmake_minimum_required(VERSION 3.23)

set(lib_name peripheral)
add_library(${lib_name} STATIC)
# HAL Peripherals
target_sources(${lib_name}
	PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_adc.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_dbgmcu.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_dma.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_exti.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_flash.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_gpio.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_i2c.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_iwdg.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_misc.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_opa.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_pwr.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_rcc.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_spi.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_tim.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_usart.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_wwdg.h>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc/ch32v00X_conf.h>
	# Install location for following files needs to be in include/Peripheral
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_adc.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_dbgmcu.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_dma.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_exti.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_flash.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_gpio.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_i2c.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_iwdg.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_misc.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_opa.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_pwr.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_rcc.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_spi.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_tim.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_usart.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_wwdg.h>
	$<INSTALL_INTERFACE:include/ch32v00x/Peripheral/ch32v00X_conf.h>
	PRIVATE
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_adc.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_dbgmcu.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_dma.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_exti.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_flash.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_gpio.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_i2c.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_iwdg.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_misc.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_opa.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_pwr.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_rcc.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_spi.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_tim.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_usart.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/ch32v00X_wwdg.c"
)

target_include_directories(${lib_name}
	PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc>
	$<INSTALL_INTERFACE:include>
	# TODO: Peripheral headers directly includes other headers directly from SDK. Following is WORKAROUND just for that.
	$<INSTALL_INTERFACE:include/ch32v00x/peripheral>
)
target_compile_definitions(${lib_name} PUBLIC ${MCU} ${MCU_FAMILY})
# Processor Arch related
target_compile_options(${lib_name} PUBLIC -mno-save-restore)
# Optimization. Intentionally kept private.
target_compile_options(${lib_name} PRIVATE -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common)
target_compile_options(${lib_name} PUBLIC -msmall-data-limit=8)
# Debugging and Optimization
# target_compile_options(${lib_name} PRIVATE -Os)
# target_compile_options(${lib_name} PRIVATE $<$<CONFIG:Debug>:-g>)
# Linker
target_link_options(${lib_name} PUBLIC -mno-save-restore)
#target_link_options(${lib_name} PUBLIC -Xlinker --gc-sections)
target_link_libraries(${lib_name} PUBLIC ch32v00x::core)

set_target_properties(${lib_name} PROPERTIES FOLDER "${PROJECT_NAME}")
add_library(ch32v00x::peripheral ALIAS ${lib_name})
