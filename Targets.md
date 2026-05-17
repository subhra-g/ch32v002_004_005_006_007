# CH32V002/CH32V004/CH32V005/CH32V006/CH32V007 SDK

Set a variable pointing to the installation directory in user preset
```json
"CH32V00X_HAL_ROOT": {
	"type": "PATH",
	"value": "$env{USERPROFILE}/dev/libs/InstalledEmbeddedLibs/share/cmake"
}
```
Use `find_package` to locate the package. 
```cmake
find_package(ch32v00xhal HINTS "${CH32V00X_HAL_ROOT}")
```

## Targets

Target                              | Type       | Description 
------------------------------------|------------|-------------
`ch32v00x::core`                    | Static     | 
`ch32v00x::peripheral`              | Static     | The SDK HAL.
`ch32v00x::startup`                 | Interface  | SDK provided startup in compiled form.
`ch32v00x::startupLib`              | Static     | SDK provided startup source file.
`ch32v00x::debug-print::sdi`        | Static     | Debug print library via SDI.
`ch32v00x::debug-print::uart::pd5`<sup>DEFAULT</sup>| Static | Debug print library via UART (Port D Pin5).
`ch32v00x::debug-print::uart::pd0`  | Static     | Debug print library via UART (Port D Pin0).
`ch32v00x::debug-print::uart::pd6`  | Static     | Debug print library via UART (Port D Pin6).
`ch32v00x::debug-print::uart::pc0`  | Static     | Debug print library via UART (Port C Pin0).
`ch32v00x::debug-print::uart::pd1`  | Static     | Debug print library via UART (Port D Pin1).
`ch32v00x::debug-print::uart::pb3`  | Static     | Debug print library via UART (Port B Pin3).
`ch32v00x::debug-print::uart::pc5`  | Static     | Debug print library via UART (Port C Pin5).
`ch32v00x::debug-print::uart::pb5`  | Static     | Debug print library via UART (Port B Pin5).
`ch32v00x::debug-print::uart::pa0`  | Static     | Debug print library via UART (Port A Pin0).

Applies to V005, V006, V007, M007.

Target                              | Type       | Description 
------------------------------------|------------|-------------
`ch32v00x::debug-print::uart::pa7`  | Static     | Debug print library via UART (Port A Pin7).
`ch32v00x::debug-print::uart::pa4`  | Static     | Debug print library via UART (Port A Pin4).
`ch32v00x::debug-print::uart::pa2`  | Static     | Debug print library via UART (Port A Pin2).
`ch32v00x::debug-print::uart::pd2`  | Static     | Debug print library via UART (Port D Pin2).
`ch32v00x::debug-print::uart::pb0`  | Static     | Debug print library via UART (Port B Pin0).
`ch32v00x::debug-print::uart::pc4`  | Static     | Debug print library via UART (Port C Pin4).
`ch32v00x::debug-print::uart::pa6`  | Static     | Debug print library via UART (Port A Pin6).

> Use any one of the `debug-print::uart` targets.
> Also use one of the startup targets (`ch32v003::startup` or `ch32v003::startupLib`)

## Compile options:

Following targets adds some compile options.

Target                              | Compile option
------------------------------------|----------------
`ch32v00x::debug-print::sdi`        | `SDI_PRINT=SDI_PR_OPEN`
`ch32v00x::debug-print::uart::pd5`  | `DEBUG=DEBUG_UART1_NoRemap`
`ch32v00x::debug-print::uart::pd0`  | `DEBUG=DEBUG_UART1_Remap1`
`ch32v00x::debug-print::uart::pd6`  | `DEBUG=DEBUG_UART1_Remap2`
`ch32v00x::debug-print::uart::pc0`  | `DEBUG=DEBUG_UART1_Remap3`
`ch32v00x::debug-print::uart::pd1`  | `DEBUG=DEBUG_UART1_Remap4`
`ch32v00x::debug-print::uart::pb3`  | `DEBUG=DEBUG_UART1_Remap5`
`ch32v00x::debug-print::uart::pc5`  | `DEBUG=DEBUG_UART1_Remap6`
`ch32v00x::debug-print::uart::pb5`  | `DEBUG=DEBUG_UART1_Remap7`
`ch32v00x::debug-print::uart::pa0`  | `DEBUG=DEBUG_UART1_Remap8`
`ch32v00x::debug-print::uart::pa7`  | `DEBUG=DEBUG_UART2_NoRemap`
`ch32v00x::debug-print::uart::pa4`  | `DEBUG=DEBUG_UART2_Remap1`
`ch32v00x::debug-print::uart::pa2`  | `DEBUG=DEBUG_UART2_Remap2`
`ch32v00x::debug-print::uart::pd2`  | `DEBUG=DEBUG_UART2_Remap3`
`ch32v00x::debug-print::uart::pb0`  | `DEBUG=DEBUG_UART2_Remap4`
`ch32v00x::debug-print::uart::pc4`  | `DEBUG=DEBUG_UART2_Remap5`
`ch32v00x::debug-print::uart::pa6`  | `DEBUG=DEBUG_UART2_Remap6`

Define a function `SystemInit`. Define a static variable `SystemCoreClock` of type `uint32_t` and set it with system clock frequency to use any of the `debug-print` target. Example to do these steps can be found in any of the SDK examples.
