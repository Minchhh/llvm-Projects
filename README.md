Getting Started with the LLVM System

Overview

Welcome to the LLVM project!

The LLVM project has multiple components. The core of the project is itself called "LLVM". This contains all of the tools, libraries, and header files needed to process intermediate representations and convert them into object files. Tools include an assembler, disassembler, bitcode analyzer, and bitcode optimizer. It also contains basic regression tests.

C-like languages use the Clang frontend. This component compiles C, C++, Objective-C, and Objective-C++ code into LLVM bitcode -- and from there into object files, using LLVM.

Other components include: the libc++ C++ standard library, the LLD linker, and more.

Getting the Source Code and Building LLVM

The LLVM Getting Started documentation may be out of date. The Clang Getting Started page might have more accurate information.

This is an example work-flow and configuration to get and build the LLVM source:

   1. Checkout LLVM (including related sub-projects like Clang):

    • git clone https://github.com/llvm/llvm-project.git
        
   2. Configure and build

    •     cd ~/llvm/
    •     mkdir build install Create directories for the build and install.
    •     cd build
    •     cmake -G "Ninja" -DCMAKE_INSTALL_PREFIX=../install -	DCMAKE_BUILD_TYPE="Debug" -DLLVM_TARGETS_TO_BUILD="host" ../llvm
    •     ninja 
    • This will build and install LLVM
    
    
Other Useful additional flags when configuring (cmake)

    •     -DCMAKE_BUILD_TYPE=[Release|Debug|RelWithDebInfo]
    • 
    •     -DLLVM_USE_LINKER=gold to use the gold linker which is faster and requires lesser memory. 	I suggest using this (requires the gold linker to be installed on your system).
    • 
    •     -DBUILD_SHARED_LIBS=1 Builds LLVM as a shared library. This can potentially bring down 	the memory requirements for your build. It may in turn add a delay when starting your 	debugger.
    • 
    •     -DLLVM_ENABLE_BINDINGS=OFF If you get warnings or errors related to missing OCaml 	bindings.
    • 
    •     -DLLVM_BUILD_TOOLS=OFF If you want to build just the libraries and not the executable 	tools (opt, llvm-as etc).
    • 
    •     -DLLVM_ENABLE_PROJECTS="clang;mlir" For example, to also build clang and mlir.
    • 
    • -DCMAKE_CXX_FLAGS=" -ggdb3 -gdwarf-4 " for better debugging experience with gdb.
