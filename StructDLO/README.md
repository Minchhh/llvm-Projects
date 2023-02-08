Structure Data Layout Optimization using LLVM Compiler FrameWork.

The above Optimization was implemented by writing two LLVM Module pass, the first pass implemented was CheckAlwaysInlineAttribute pass which checks whether the “always-inline ” attribute is present for all the function calls. And adds if the attribute is not present.

The other pass which is implemented was StructDLOPass which determines the hot, cold and dead ﬁelds of the structure where

 - Dead fields of the struct - the fields which are not accessed at all / the fields to which there is only store (no load access) / fields accessed in functions which are not called anywhere.
- Hot fields - Fields which are frequently accessed, for example fields used in loops.
- Cold fields - Fields which are less frequently accessed.

After inling all the functions, all functions except the main function is removed from the module.

The Hot, cold and dead fields is implemented by assigning weight to each field of the structure.

And when you encounter an access to any field of a structure,

 - increment weight of the field by 1 if it is not in any loop
- if it is in loop increment by value equal to 8^(depth of loop).

Finally, The dead ﬁeld will be removed by removing the dead field instructions from the entire module, then the new struct type will be created and the entire module is rewritten to use the new struct type with no dead ﬁelds.

The testcase files used has a struct defined in define.h, this is used across multiple functions in main.c and fill.c.

To get single IR file from different source files use below command

    • $clang -S -emit-llvm main.c
    • $clang -S -emit-llvm fill.c
    • $llvm-link main.ll fill.ll -S -o out.ll

The other commands used to run above 2 passes in clang at -O2 are

    • ~/llvm/build/bin/clang out.ll -emit-llvm -O2 -mllvm -struct-dlo-opt -S -o temp.ll
