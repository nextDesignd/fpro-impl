## IO Register Framework

This framework includes following header files -
    - chu_io_map.h   : maintains address mapping infomations for c/c++ code
    - chu_io_map.svh : maintains address mapping infomations for SystemVerilog code
    - chu_io_rw.h    : provides I/O registers read/write macros

### Address Mapping files

#### MMIO Address assignment for FPro
MMIO subsystem would have address spaces for FPro system is divided in slots, where diffrent IP's connected in
system would map there configuration/data registers. There would be 
    - 64 (2^6) slots, and
    - 32 (2^5) registers per slot, and
    - 4 bytes (2^2 bytes) per register

Thus system would have 13-bit byte address able address space. With address format as -
    s_ssss_srrr_rr00
where, ssssss is the slot number of the perpherial and rrrrr is the offset one needs to
access

Not all IP cores will use all of the 32 registers avalaible and not all 32 bits of a register 
would be used. System is arranged this way to ease address decoding logic and provide path
to future expandability

#### chu_io_map
As discussed above, for FPro system, we have 64 slots, and when the system is build
we can configure what IPs are actually instanced and in which slot.
Below file capture this information for both SystemVerilog/C++ code.
    - chu_io_map.h   : maintains address mapping infomations for c/c++ code
    - chu_io_map.svh : maintains address mapping infomations for SystemVerilog code

chu_io_map.h would list out IPs instanced in a slot like -
```c++
    #define S0_SYS_TIMER 0
    #define S1_UART1     1
    #define S2_LED       2
    #define S3_SW        3
```
chu_io_map.svh, would also capture this same information, but in SV syntax
Consisteny between these files needs to be mainted to avoid errors (#TOOD: 
Can generate one file from another)

Asside from slot information, these files also contain bridge base address,
as this might based on what processor we are using.

#### chu_io_rw.h

Supppose we need to read a certain register inside the IP at address 0xc00000180.
The C/C++ code to do this would be -

```c++
#define SW_BASE 0xc00000180
#define DATA_REG1 0
#define DATA_REG2 4

uint32_t data1 = * (volatile uint32_t *) (SW_BASE + DATA_REG1)
uint32_t data2 = * (volatile uint32_t *) (SW_BASE + DATA_REG2)
```
Here, `uint32_t *`, ask's the compiler treat/cast the addresses as pointers
to 4 byte ints (so while reading it will read 4 bytes). `volatile`, tell 
compiler that these addresses might change value without any interaction 
from CPU, so don't optimize this. The first `*` actually derefreneces the 
pointer to get the value of the register.

This code is functionally correct. But its hard to read. We can improve it
a bit, by define macros for reading registers

```c++
#define io_read(base, offset) * (volatile uint32_t) ((base) + (offset))

uint32_t data1 = io_read(SW_BASE, DATA_REG1);
uint32_t data2 = io_read(SW_BASE, DATA_REG2);
```

With this, we just need to remember to invoke `io_read` to read any IO register.
Similar function can be written for writing the registers -

```c++
#define io_write(base, offset, data) \
    (* (volatile uint32_t *) ((base) + (offset))) = data

io_write(SW_BASE, DATA_REG2, 0x33);
io_write(SW_BASE, DATA_REG2, data_reg2);
```

One more optimization we can make is of generating BASE address of IP-cores.
As we know that base address of an IP core would be a function of bridge base
address and the slot number of IP (both of which are avalaible in chu_io_map.h).
We can generate IP core base address as -
    ip_core_base_address = bridge_base_addr + 32*4 * slot_number

Defined as a macro this becomes -
```c++
#define SLOT_BASE_ADDR(mmio_base, slot_index) \
    ((uint32_t)((mmio_base) + (slot_index)*32*4))

#define SW_BASE SLOT_BASE_ADDR(BRIDGE_BASE, S3_SW)
//offset of IP

#define LED_BASE SLOT_BASE_ADDR(BRIDGE_BASE, S2_LED)
//offset of IP
```

Note: These macros suffer from a subtle bug in-case the processor has a data
cache. Suppose these address are in data cached, and as processor sees these 
address as simple memory, it might not do a write back to memory after 
updating the registers, because of which, the data inside these won't be sent
to IP. As a solutions for this, normally there a certain code in boot sequence
that would mark certain memory regions (incuding MMIO) to be "not-cacheable".

### BIT-MANIPULATION (TODO)

