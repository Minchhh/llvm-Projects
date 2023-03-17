Loop Fusion

This project is the implementation of a pass for loop fusion in LLVM compiler. Two
loops, which are adjacent and have the same condition and increments with respect to the
loop variable may be fused, i.e, their bodies may be executed one after the other with in a
single loop. The decision to fuse the loops is taken based on the legality and dependency
of the fusion. It should not be performed if the resulting code has anti-dependency or if
the execution time of the program increases.

Following test case contains two loops.  Your task is to write a pass to fuse them together 

void init(int *a, int *b, int *c, int n) {

  for (int i = 0; i < n; i++) {
  
    c[i] = i + i;
    
    b[i] = i * i;
    
  } 
  
  for (int i = 0; i < n; i++) {
  
    a[i] = b[i] + c[i];
    
  } 
}

The other testcases used, are present in the Testcases folder.

    • ~/llvm/build/bin/clang -S -emit-llvm test.c -Xclang -disable-O0-optnone
    • ~/llvm/build/bin/opt -mem2reg -loop-simplify -loop-rotate -instcombine -instnamer -indvars test.ll -S -o out.ll
    • ~/llvm/build/bin/opt out.ll --load ~/llvm/build/lib/LLVMHello.so -enable-new-pm=0 -hello2 -S -o final.ll
    • ~/llvm/build/bin/opt tempafter.ll -S -passes=loop-simplify,loop-fusion -debug-only=loop-fusion -o final.ll// This command is to run loop fusion pass that is available in llvm on your IR.

To Understand the loop terminologies use the below link

    • https://llvm.org/docs/LoopTerminology.html
      
Similar to Scalar evolution , there are utilities to get the loop info. These utilities give you all the necessary information to implement the basic variant of the pass.

    • https://llvm.org/doxygen/classllvm_1_1LoopInfoWrapperPass.html
    • https://llvm.org/doxygen/classllvm_1_1LoopInfo.html
    
Other Links
    • https://llvm.org/devmtg/2014-04/PDFs/Talks/Passes.pdf
    • http://sridhargopinath.in/files/loop-fusion.pdf
    • https://llvm.org/devmtg/2012-11/Gohman-AliasAnalysis.pdf
      

      
