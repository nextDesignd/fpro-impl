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
RV32I uses 32-bit wide addresses
Memory is byte-addressable.

Data can be loaded from memory with lw (load word) or stored to memory with
sw (store-word) ->
```
# load word
lw s7, 8(zero) # s7 = mem[2], base-address(mem) = 0, offset = 8 (=2*4)

# store word
addi t0, zero, 42
sw   t0, 20(zero) # mem[5] = 42

```
Some RISC-V implementation might require Addresses used for lw/sw to be
word-aligned. This simplifes the implementation. But RISC-V ISA does not
enforce this (TODO: confirm).


### Program Flow
RV32I each instruction is 32-bit long.
Program counter -> tracks the current instruction being executed
#### Logical
Provide bit-wise logical operations. Example ->
```
add xd, x1, x2 # xd = x1 & x2
or  xd, x1, x2 # xd = x1 | x2
xor xd, x1, x2 # xd = x1 ^ x2
```

Immediate version of these are also avalaible. Immediate value begin 12-bit
sign-extended. addi, ori & xori

Bitwise NOT can be achived with xori as ->
```
xori xd, x1, -1     # xd = ~x1
```

#### Shift 
RISC-V provides 3 shift operations ->
    - sll (shift left logical)     : inserts zeros on LSB
    - srl (shift right logical)    : inserts zeros on MSB
    - sra (shift right arithmetic) : sign-extended on MSB
2nd operand register specifies the shift ammount

These are also immediate version of these shifts: slli, srli, srai. Immediate
value begin a 5-bit unsigned number


#### Mutliply Instructions
Mutliply Instructions are not part of arithmetic instructions as, product of 
2 N-bit numbers is 2N-bit wide. Mutliply is not part of RV32I, and is 
avalaible in RVM (RISC-V multiply/divide) extension.

mul instruction multiplies 2 32-bit numbers and stores lower 32-bit of product
in a register, while upper 32-bit are discarded. Small multiplication are be 
achived with just one instruction. Result of lower 32-bit is same wheather 
input numbers are signed or unsigned.

For upper 32-bit RISC-V provides 3 instructions: 
    - mulh    : treats both input operands as signed numbers
    - mulhsu  : treats 1st input operand as signed and 2nd as unsigned
    - mulhu   : treats both input operands as unsigned numbers
All 3 store upper 32-bit of product in specifed destination register

These can be called in sequence to generate 64-bit products, as ->
```
mulh t1, s3, s5
mul  t2, s3, s5 # {t1,t2} = s3 * s5
```

#### Branching

##### Conditional Branches
6 conditional branch instructions. Each take 2 source register and a label 
indicating where to go. These are ->
    - beq  : branch-if-equal, branch if 2 registers are equal
    - bne  : branch-if-not-equal, branch if 2 registers are not equal
    - blt  : branch-if-less-than, branch if s1 < s2, both s1 and s2 are treated as signed
    - bge  : branch-if-greater-than-or-equal, branch if s1 >= s2, both s1 and s2 are treated as signed
    - bltu : branch-if-less-than, branch if s1 < s2, both s1 and s2 are treated as unsigned
    - bgeu : branch-if-greater-than-or-equal, branch if s1 >= s2, both s1 and s2 are treated as unsigned

There are no ble & bgt, as they can be generated by switching the operand order.
Although these are avalible as pseudo-instructions

Example ->
```
beq s0, s1, target # if s0 == s1, jump to target
addi s1, s1, 1

target:
add s1, s1, s0
```

##### Unconditional Jumps
3 instructions are avalible -
    - j : jump, jumps directly to instruction specifed by label
    - jal : jump and link
    - jr : jump register
Latter 2 are used to implement functions

Example ->
```
    j target        # executed
    addi s1, s1, 1  # not executed

target:
    add s1, s1, s0  # executed
```

#### Conditional Statments

Translating high-level if-else constructs to Assembly

**if statments**
We check inverion of the the condition specified in the if statment.
if that is true we skip over the code of if statment, otherwise execute it

High-level code -
```
if(apples == oranges) 
    f = g + h
apples = oranges - h;
```

Assembly -
```
# s0 = apples, s1 = oranges
# s2, s3, s4 = f, g, h

    bne s0, s1, end
    add s2, s3, s4
end:
    sub s0, s1, s4

````

**if/else statments**
Similar to if statment Assembly would first check inverion of the high level
condition, jump to else part if its true, otherwise continue to execute
if part and at end we do an unconditional jump to instruction after last else
statment so that its not executed

```
if(apples == oranges) 
    f = g + h
else
    f = g - h
apples = oranges - h;
```

Assembly -
```
# s0 = apples, s1 = oranges
# s2, s3, s4 = f, g, h

    bne s0, s1, else
    add s2, s3, s4
    j end
else:
    sub s2, s3, s4
end:
    sub s0, s1, s4

````

**switch/case statments**

High-level code ->
```
switch (button) {
    case 1: amt = 20; break;
    case 2: amt = 50; break;
    case 3: amt = 100; break;
    default: amt = 0;
}
```

Assembly ->
```
# s0 == button, amt = s1

    addi t0, zero, 1
    bne  s0, t0, case2
    addi s1, zero, 20
    j    done
case2:
    addi t0, zero, 2
    bne  s0, t0, case3
    addi s1, zero, 50
    j    done
case3:
    addi t0, zero, 3
    bne  s0, t0, default
    addi s1, zero, 100
    j    done
default:
    addi s1, zero, 0
done:
```


#### Loops

**while loops**
While loop's assemby also checks for the opposite of high-level condtion, which
if true ends the loop otherwise we continue to exectue the loop by jumping to 
start (condition check) of the while loop

High-level code ->
```
int pow = 1;
int x   = 0;

while(pow != 128) {
    pow = pow * 2;
    x = x + 1;
}
```

Assembly ->
```
# s0 => pow, s1 => x

    addi s0, zero, 1
    addi s1, zero, 0

    addi t0, zero, 128
loop:
    beq  s0, t0, done
    slli s0, s0, 1
    addi s1, s1, 1
    j    loop
done:
```

**do-while loop**
Similar to while loop, except -
    - condition jump is moved to end of code
    - jump condition is same as that of the high-level code

This require one less jump instruction then while loop.
High-level code ->
```
int pow = 1;
int x   = 0;

do{
    pow = pow * 2;
    x = x + 1;
}while(pow != 128);
```

Assembly ->
```
# s0 => pow, s1 => x

    addi s0, zero, 1
    addi s1, zero, 0

    addi t0, zero, 128
loop:
    slli s0, s0, 1
    addi s1, s1, 1
    bne  s0, t0, loop
```

**for loops**
Similar implementation as the while loop
High-level Code -
```
int sum = 0;
int i;
for (i = 0; i < 10; i = i + 1) {
    sum = sum + i;
}
```

Assembly Code
```
# s0 => i, s1 => sum
    addi s1, zero, 0

    addi s0, zero, 0
    addi t0, zero, 10
loop:
    bge  s0, t0, done
    add  s1, s1, s0
    addi s0, s0, 1
    j    loop
done:
```
#### Arrays
High-Level code ->
```
int i;
int scores[200];
for (i = 0; i < 200; i = i + 1)
    scores[i] = scores[i] + 10;
```

Assembly ->
```
# s0 = scores base-address, s1 = i

    addi s1, zero, 0
    addi t0, zero, 200
loop:
    bge s1, t0, done

    slli t2, s1, 2
    add  t2, t2, s0     # t2 = scores + i*4

    lw t1, 0(t2)        # t1 = scores[i]
    addi t1, t1, 10
    sw t1, 0(t2)        # scores[i] = t1

    addi s1, s1, 1
    j    loop
done:

```

**Bytes and Characters**
Bytes can be stored/loaded from memory using following instructions ->
    - lb, load-byte, sign-extends 8-bits to 32-bit register
    - lbu, load-byte-unsigned, zero-extends 8-bits to 32-bit register
    - sb, store-byte, store 8 LBS of register to memory

Usage Example ->

High-Level code ->
```
// Covert lower-case char array to upper-case
int i;
char chararray[10]

for (i = 0; i < 10; i = i + 1)
    chararray[i] = chararray[i] - 32;
```

Assembly ->
```
# s0 = chararray base-address, s1 = i

    addi s1, zero, 0
    addi t2, zero, 10
loop:
    bge  s1, t2, done

    add  t0, s1, s0    # t0 = chararray + i
    lb   t1, 0(t0)     # t1 = chararray[i]
    addi t1, t1, -32
    sb   t1, 0(t0)     # chararray[i] = t1
    
    addi s1, s1, 1
    j    loop
done:

```

#### Function Calls

**Function calls and Returns**
**Input Arguments and Return value**
**The Stack**
**Preserved Registers**
**Nonleaf Function Calls**
**Recursive Function Calls**
**Additional Arguments and Local Variables**

#### Pseudoinstruction

