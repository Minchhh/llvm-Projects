//===- Hello.cpp - Example code from "Writing an LLVM Pass" ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements two versions of the LLVM "Hello World" pass described
// in docs/WritingAnLLVMPass.html
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/Statistic.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include <map>

using namespace llvm;

#define DEBUG_TYPE "hello"

STATISTIC(HelloCounter, "Counts number of functions greeted");

namespace {
// Hello - The first implementation, without getAnalysisUsage.

struct Hello : public FunctionPass {
  static char ID; // Pass identification, replacement for typeid
  // Map to store the unique signatures of each BB
  std::map<BasicBlock *, int> IntialMapVal;
  // Map to store the corresponding instruction of each BB
  std::map<BasicBlock *, Instruction *> M;
  // Global Variable Declaration
  GlobalVariable *GlobalVar = nullptr;
  GlobalVariable *D = nullptr;

  Hello() : FunctionPass(ID) {}
  // Function to compute G=G^d
  void SignatureDiff(ConstantInt *d, IRBuilder<> &Builder) {
    LLVMContext &C = d->getContext();
    auto *G = Builder.CreateLoad(Type::getInt32Ty(C), GlobalVar);
    auto *XorResult = Builder.CreateXor(G, d);
    Builder.CreateStore(XorResult, GlobalVar);
  }
  // Function to call "__ctt_error"
  void CttCall(IRBuilder<> &Builder, BasicBlock *BB) {
    Instruction *I = nullptr;
    auto F = BB->getParent();
    LLVMContext &Context = F->getContext();
    auto Module = F->getParent();
    Function *Func = Module->getFunction("__ctt_error");
    auto *TempGlobalVar =
        Builder.CreateLoad(Type::getInt32Ty(Context), GlobalVar);
    auto *SigCur =
        ConstantInt::get(Type::getInt32Ty(Context), IntialMapVal[BB]);
    I = Builder.CreateCall(Func, {SigCur, TempGlobalVar});
    M[BB] = I;
  }

  bool runOnFunction(Function &F) override {
    ++HelloCounter;
    // Get context wrt Function
    LLVMContext &Context = F.getContext();
    // Create a Builder based on the Context
    IRBuilder<> Builder(Context);
    auto Module = F.getParent();

    // GlobalVariable G creation
    GlobalVar = new GlobalVariable(
        *Module, Type::getInt32Ty(Context), false, GlobalValue::ExternalLinkage,
        ConstantInt::get(Type::getInt32Ty(Context), 0), "G");

    // GlobalVariable D creation
    D = new GlobalVariable(*Module, Type::getInt32Ty(Context), false,
                           GlobalValue::ExternalLinkage,
                           ConstantInt::get(Type::getInt32Ty(Context), 0), "D");

    // When the function is "__ctt_error" no actions should be taken
    if (F.getName() == "__ctt_error")
      return false;

    // Assigning unique signatures to each basicblock
    int CountBB = 1;
    for (BasicBlock &BB : F) {
      IntialMapVal[&BB] = CountBB;
      CountBB++;
    }

    for (BasicBlock &BB : F) {

      // Entry BB case
      if (BB.isEntryBlock()) {
        auto Val = ConstantInt::get(Type::getInt32Ty(Context), 1);
        Builder.SetInsertPoint(BB.getFirstNonPHI());
        Builder.CreateStore(Val, GlobalVar);
        continue;
      }

      auto BBPred = BB.getSinglePredecessor();

      // MultiPredecessor Case
      if (!BBPred && !BB.isEntryBlock()) {

        // Get the first Predecessor of the Branch fan in node
        pred_iterator PI = pred_begin(&BB);
        BBPred = *PI;

        // Compute D=FirstPredSig^CurrPredSig and insert into pred BB
        for (BasicBlock *Pred : predecessors(&BB)) {
          int Temp = IntialMapVal[BBPred] ^ IntialMapVal[Pred];
          auto *Res = ConstantInt::get(Type::getInt32Ty(Context), Temp);
          Builder.SetInsertPoint(M[Pred]->getNextNode());
          Builder.CreateStore(Res, D);
        }
      }
      // Compute d=SigPrev ^ SigCur
      int Temp = IntialMapVal[BBPred] ^ IntialMapVal[&BB];
      auto *d = ConstantInt::get(Type::getInt32Ty(Context), Temp);

      // Call SignatureDiff function to compute G=G ^ d
      Builder.SetInsertPoint(BB.getFirstNonPHI());
      SignatureDiff(d, Builder);

      // If BB has MultiPredecessor
      if (pred_size(&BB) > 1) {
        auto *GlobalNew =
            Builder.CreateLoad(Type::getInt32Ty(Context), GlobalVar);
        auto *DNew = Builder.CreateLoad(Type::getInt32Ty(Context), D);
        auto *XorResult = Builder.CreateXor(GlobalNew, DNew);
        Builder.CreateStore(XorResult, GlobalVar);
      }

      // Calling CttCall Function to check whether SigCur is equal
      // GlobalVariable
      CttCall(Builder, &BB);
    }
    return false;
  }
};
} // namespace

char Hello::ID = 0;
static RegisterPass<Hello> X("hello", "Hello World Pass");

namespace {
// Hello2 - The second implementation with getAnalysisUsage implemented.
struct Hello2 : public FunctionPass {
  static char ID; // Pass identification, replacement for typeid
  Hello2() : FunctionPass(ID) {}

  bool runOnFunction(Function &F) override {
    ++HelloCounter;
    errs() << "Hello: ";
    errs().write_escaped(F.getName()) << '\n';
    return false;
  }

  // We don't modify the program, so we preserve all analyses.
  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesAll();
  }
};
} // namespace

char Hello2::ID = 0;
static RegisterPass<Hello2>
    Y("hello2", "Hello World Pass (with getAnalysisUsage implemented)");
