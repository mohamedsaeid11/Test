First we start with creating the submodules to create the big picture (top module) 
afterwards we go to create each one with a self checking testbench then we 
combine all this together in top module instancing them there and after make the 
whole system testbench 

# ALU Verilog Project

## Project Overview
This repository contains a Verilog implementation of an Arithmetic Logic Unit (ALU) with several basic operations. The ALU module and its supporting modules are organized for easy understanding and simulation.

## Folder Structure
- **RTL_Codes/** — Verilog source files (main ALU and any submodules)
- **Testbench/** — Verilog testbench files for simulation
- **docs/** — Documentation, diagrams, and reports (optional)

## Features
- Addition
- Subtraction
- Bitwise AND
- Bitwise OR
- (Add more if your ALU supports other operations!)

## How to Simulate

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mohamedsaeid11/ALU.git
   ```

2. **Go to the project folder:**
   ```bash
   cd ALU
   ```

3. **Run a simulation:**  
   You can use free tools like [Icarus Verilog](http://iverilog.icarus.com/) or online platforms like [EDA Playground](https://edaplayground.com/).

   Example with Icarus Verilog:
   ```bash
   iverilog -o alu_test RTL_Codes/alu.v Testbench/alu_tb.v
   vvp alu_test
   ```
   *(Change file names if needed.)*

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
This project is open-source. Feel free to use and modify.

## Author
Mohamed Saied  
[GitHub Profile](https://github.com/mohamedsaeid11)

