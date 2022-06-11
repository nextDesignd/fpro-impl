# RISC-V

RV32I -> is a 32-bit architecture as it operates on 32-bit wide data

RISC-V has 32 registers, x0-x31, they also have special name based on there
intended use. RISC-V assembler understand both. Its prefrable to
use intended names, instead of register numbers. 

All registers and intended usage is captures in table ->

Name   | Register Number | Use
-----------------------------------------------
zero   | x0              | Constant value 0
ra     | x1              | Return Address
sp     | x2              | Stack Pointer
gp     | x3              | Global Pointer
tp     | x4              | Thread Pointer
t0-2   | x5-7            | Temporary Registers
s0/fp  | x8              | Saved register/Frame pointer
s1     | x9              | Saved register
a0-1   | x10-11          | Function arguments/Return values
a2-7   | x12-17          | Function arguments
s2-11  | x18-27          | Saved registers
t3-6   | x28-31          | Temporary registers


### Instructions

Add and subtract -
```
add xd, x1, x2 # xd = x1 + x2
sub xd, x1, x2 # xd = x1 - x2
```
Add Immediate -
Immediate value comes from instruction. Its a 12-bit 2's complement value.
Both addition and subtraction can be achived due to this.
Can also be used to load small constants in registers
```
addi xd, x1, 4
addi xd, x1, -12
addi xd, x1, 0x32 # hex
addi xd, x1, 0b0011 # binary
addi xd, x0, 10 # xd = 10, load 10 in xd
```
Load upper immediate -
Used to load upper 20 bits of a register with immediate value. Lower bits are 
set to 0. Lower bits can be set with addi
```
lui xd, 0xABCDE # xd = 0xABCDE000
addi xd, x0, 0x123 # xd = 0xABCDE123, full 32-bit value
```
When loading a 32-bit constant, where bit-11 is 1, i.e. we need to add one to
upper 20-bit value. As with addi, if bit-11 is 1, the constant would be 
sign-extended before adding.

This works becase sign-extended part of 12-bit immediate is 0xFFFFF (=-1), 
when we add it to upper 20-bit + 1, both 1 cancel out, giving us the required 
constant
Example, suppose we want to set a registers as 0xFEEDA987, code for that would 
be -
```
lui xd, 0xFEEDB # xd = 0xFEEDB000
addi xd, x0, 0x987 # xd = 0xFEEDB000 + 0xFFFFF987 = FEEDA987
```

#### Memory

Data that does not fit the regsiters is stored in memory.
RISC-V only has instructions to operate on data in Register, so to work with 
data in memory its needs to be moved in to Registers.
Memory is byte-addressable
