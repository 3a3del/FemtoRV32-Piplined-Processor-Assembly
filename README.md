## FemtoRV32-Piplined-Processor-Assembly                                                                                
                     
# Testing
All Testing Source Codes in `Src` folder and the verification's pictures.

# How to Run
  1. Clone the Repo.
           
  2. Write any assembly code that you need the processor to excute it, write it in .text Section the `code.S` in `firmware`.
  3. Run first Commond in `gcc_commands.sh`, that assemble the source code to object code by `riscv32 compilar`
 ```bash
riscv32-unknown-elf-gcc -c -mabi=ilp32 -march=rv32i -o code.o code.S
  ```
4. Linking Step to get the Binary file
 ```bash
riscv32-unknown-elf-gcc -Og -mabi=ilp32 -march=rv32i -ffreestanding -nostdlib -o code.elf -Wl,--build-id=none,-Bstatic,-T,sections.lds,-Map,code.map,--strip-debug code.o -lgcc
  ```
5. After get the .elf file convert it to dumpfile to get the readable instruction file
 ```bash
riscv32-unknown-elf-objdump -d code.elf > dumpfile
 ```                    
  
6. Get the risc-v Machine code file
```bash
riscv32-unknown-elf-objcopy  -O binary code.elf code.bin
  ```                    
7. Convert the Machine code instructions to Hex code to be read in our processor
 ```bash
python3 makehex.py code.bin 1024 > code.hex
```
8. First .py to convert the hex to bin 64 line as our instruction memory bear up to 32 x 64 inst, Second .py convert to 64 lines, third .py the get the random Memory data for our data memory
 ```bash
python3 HextoBin.py
python3 lines64.py
python3 randomMEMgen.py
```                    
9. Simulating with `Icarus Verilog` and `GTKwave`                                                                                                 
 ```bash
iverilog src/*.v DataPath_tb.v -o program
./program
```
10. Run to check Functionality
 ```bash
gtkwave DataPath.vcd
```
11. enjoy :)
    
** Note 1: All the previous commands only for linux users in existance of python3 package, VsCode, risc-v compliar.

** Note 2: Don't forget to link the `random_data.mem` location in the verilog code Data Memory, `output_64_lines_hex.txt` location in the verilog code Instruction Memory.                    
## Windows User
  1. Clone the Repo
 
2. Use any external tool or source to covert the assembly risc code to hex codes.
3. get the random data for data Memory.
 ```bash                    
python3 randomMEMgen.py
```
4. Don't forget the Note 1,2.
5. use questa Sim or vivado
6. enjoy :)
