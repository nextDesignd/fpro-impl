#ifndef FPRO_IO_RW
#define FPRO_IO_RW

#include <inttypes.h>

#define SLOT_BASE_ADDR(mmio_base, slot_index) \
    (uint32_t) ( (mmio_base) + (32 * 4 * (slot_index)) )

#define io_read(base, offset) \
    (*( ( volatile uint32_t *) ((base) + (offset))))

#define io_write(base, offset, data) \
    (*( ( volatile uint32_t *) ((base) + (offset))) = (data))

#define bit_write(data, bit_pos, bit_value) \
    if((bit_value)) (data) |= (1UL << (bit_pos)); \
    else            (data) &= ~(1UL << (bit_pos))

#endif
