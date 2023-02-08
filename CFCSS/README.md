Control Flow Checking By Software Signatures using LLVM Compiler Framework

Implemented CFCSS (Control Flow Checking by Software Signatures) algorithm for error detection


CFCSS is a pure software method that checks the control ﬂow of a program using assigned signatures. This algorithm assigns a unique signature to each node in the program graph and adds instructions for error detection.

Below is the link for CFCSS Research Paper.This paper is also attached in the CFCSS folder in the repo for reference.

https://ieeexplore.ieee.org/document/994926

This algorithm was implemented by using LLVM Compiler framework. The method used to implement the CFCSS algorithm is as follows.

STEP-1

    • Create a global variable and Store 0 to it in the entry block of every function
    • Create a map of <BasicBlock * , int> and assign an unique integer to each block where this assigned unique integer becomes the signature(Si) of the           BasicBlock.
    • Store the map's unique value to the global variable in every block.
    • In every block , create XOR of the block's map value and the global variable and store it back to the global variable as Gnew.

STEP-2

    • Add the following function to a test case file, test.c

	int __ctt_error(int a , int b) {
			if (a != b) {
			fprintf(stderr, "Signatures are not matching ");
			exit(0);
			}
		}
    
For Single Predecessor case

    • After computing the Gnew value , create a call to the the function __ctt_error(Gnew , Si) .

For the multiple predecessor's case

    • Insert "D" computed as per the algorithm into each predecessor's blocks.
          Where D is the run-time adjusting signature.
	  
    • For each predecessor , compute the updated value of G(New) XOR D

The testcase files used are greater.c, test.c which are in Testcase folder.

To get IR file from different source files(C,C++) use below command

$clang -S -emit-llvm test.c

The code implemented is in hello pass of llvm and the command used is

~/llvm/build/bin/opt test.ll --load ~/llvm/build/lib/LLVMHello.so -enable-new-pm=0 -hello2 -S -o temp.ll
