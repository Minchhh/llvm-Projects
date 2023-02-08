Scalar Evolution (SCEV) using LLVM Compiler Framework

Scalar Evolution or SCEV as it's often abbreviated, is, in a very broad sense, an analysis of change (hence the "evolution" part) of scalar quantities in a program. 

For more details on SCEV and to understand more about SCEV this is  the video with complete explaination

 https://www.youtube.com/watch?

Go through the video and understand SCEV .

Part of the test case which was used in SCEV Evolution is as follows

c = 10;
for(int i = 0; i < n; i += 4) {
A[i+2] = c+i+2
A[i+1] = c+i+1;
A[i+3] = c+i+3;
A[i] = c+i;
}

This code is simd vectorized if the array accesses are in order. That is 0/1/2/3.

For the above access pattern , the task was to identify that the accesses are not in required order. And to rearrange the code to make the access in required order.

Used Scalar Evolution (SCEV) analysis pass of LLVM Compiler
framework to rearrange the array access pattern to make the code SIMD vectorized. This exploits the spatial locality and reduces the
running time of the program.

The other testcase files used are sample.c which are in Testcase folder.

To get IR file from different source files(C,C++) use below command
    • $clang -S -emit-llvm sample.c

The code implemented is in hello pass of llvm and the command used is

    • clang -S -emit-llvm sample.c -Xclang -disable-O0-optnone
    •  ~/llvm/build/bin/opt -mem2reg -loop-simplify -instcombine -instnamer -indvars sample.ll -S -o out.ll
    •  ~/llvm/build/bin/opt -analyze -scalar-evolution out.ll //didn’t work so used the below alternative command 
    •  ~/llvm/build/bin/opt "-passes=print<scalar-evolution>"  -S out.ll >&out.txt
    •  ~/llvm/build/bin/opt out.ll --load ../build/lib/LLVMHello.so -hello2 -S -o out2.ll

The other Usefull links for refernece.
    • https://mukulrathi.com/create-your-own-programming-language/llvm-ir-cpp-api-tutorial/

	A Good talk that explains GEP well.
    • https://www.youtube.com/watch?v=m8G_S5LwlTo&t=1753
    • https://llvm.org/docs/GetElementPtr.html
      

