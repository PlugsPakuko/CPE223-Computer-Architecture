# Running the Code

This project utilizes ARM-based assembly language, and to execute the code, we will use the QEMU emulator along with the ARM toolchain.

## Setting Up WSL on Windows

### 1. Install the ARM Toolchain
To compile the ARM assembly code, first install the ARM toolchain by executing the following command in your WSL terminal:
```bash
sudo apt install gcc-arm-linux-gnueabihf
```

### 2. Install QEMU
Next, install QEMU, which allows you to emulate ARM architecture:
```bash
sudo apt install qemu-user-static
```

## Convert C Code to Assembly
To convert C code to assembly, use the following command:
```bash
arm-linux-gnueabihf-gcc -S -o <output_file>.s <input_file>.c
```

## Compiling and Running the Code

### 1. Compile the Code
Use the following command to compile your assembly code. Replace `<output_file>` with the desired name for the compiled executable and `<input_file>` with the name of your assembly source file:
```bash
arm-linux-gnueabihf-gcc -o <output_file> <input_file> -static
```

### 2. Run the Code
After compiling, execute the program with QEMU by using the command below, replacing `<output_file>` with the name of your compiled executable:
```bash
qemu-arm-static <output_file>
```

