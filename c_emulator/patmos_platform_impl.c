#include "patmos_platform_impl.h"
#include <unistd.h>
#include <stdio.h>

/* Settings of the platform implementation, with common defaults. */

uint32_t rv_ram_base = UINT32_C(0x00020000);
uint32_t rv_ram_size = UINT32_C(0x00010000);
