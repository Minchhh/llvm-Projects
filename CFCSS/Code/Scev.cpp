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

#include "llvm/ADT/APInt.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/DependenceAnalysis.h"
#include "llvm/Analysis/LoopAccessAnalysis.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instruction.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include <map>
#include <vector>
using namespace llvm;

#define DEBUG_TYPE "hello"

STATISTIC(HelloCounter, "Counts number of functions greeted");

namespace {
// Hello - The first implementation, without getAnalysisUsage.
struct Hello : public FunctionPass {
  static char ID; // Pass identification, replacement for typeid
  Hello() : FunctionPass(ID) {}
  bool runOnFunction(Function &F) override {
    ++HelloCounter;
    errs() << "Hello: ";
    errs().write_escaped(F.getName()) << '\n';
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
  // vector pair to store Storeinstructions and offset
  std::vector<std::pair<StoreInst *, long unsigned int>> StoreOffset;
  // vector to store offset
  std::vector<long unsigned int> OffsetVector;
  // vector to store all memory instructions
  std::vector<Instruction *> MemInstr;
  // vector to store Storeinstructions
  std::vector<Instruction *> StoreInstr;
  Hello2() : FunctionPass(ID) {}

  // Comparator function to sort pairs according to second value
  static bool cmp(std::pair<StoreInst *, long unsigned int> &a,
                  std::pair<StoreInst *, long unsigned int> &b) {
    return a.second < b.second;
  }

  // Function to check Dependency between Memory Instructions
  bool checkDependency(DependenceInfo *DI) {
    // Get the last Storeinstruction from vector
    for (int i = MemInstr.size() - 1; i >= 0; i--) {
      if (isa<StoreInst>(MemInstr[i]))
        break;
      else
        MemInstr.pop_back();
    }
    // Check the dependency between memory instructions
    Instruction *Src = nullptr;
    Instruction *Dst = nullptr;
    std::vector<Instruction *>::iterator I, IE, J, JE;
    for (I = MemInstr.begin(), IE = MemInstr.end(); I != IE; I++) {
      for (J = I, JE = MemInstr.end(); J != JE; J++) {
        Src = cast<Instruction>(*I);
        Dst = cast<Instruction>(*J);
        if (Src->getParent() != Dst->getParent())
          continue;
        if (Src->getParent() == Dst->getParent()) {
          if (auto D = DI->depends(Src, Dst, true)) {
            // isOrdered function checks the Flow, Anti, Output Dependency
            if (D->isOrdered()) {
              return false;
            }
          }
        }
      }
      // Push only the Store Instructions into the vector
      if (isa<StoreInst>(Src))
        StoreInstr.push_back(Src);
    }
    return true;
  }

  // Calculate the offset and Rearrange the store instructions
  void calculateOffsetAndRearrange(ScalarEvolution *SE) {

    for (int i = 0; i < StoreInstr.size(); i++) {
      if (StoreInst *SI = dyn_cast<StoreInst>(StoreInstr[i])) {
        // Get the pointer operand of the store instruction
        auto *GetPointer = SI->getPointerOperand();
        // Get SCEV Expression for the Pointer Operand
        const SCEV *GetScev = SE->getSCEV(GetPointer);
        // Get the pointer base of the Scev expression
        const SCEV *GetPointerBase = SE->getPointerBase(GetScev);
        // Remove the PointerBase S(Scev)-GetPointerBase
        const SCEV *MinusRes = SE->getMinusSCEV(GetScev, GetPointerBase);
        const SCEVAddRecExpr *Add = dyn_cast<SCEVAddRecExpr>(MinusRes);
        // Get Start of the SCEV Add Expression
        auto *Start = Add->getStart();
        // Convert start of the Scev to SCEVConstant
        auto *Constant = dyn_cast<SCEVConstant>(Start);
        // Extract to normal integer from SCEVConstant
        auto Res = Constant->getAPInt();
        auto offset = Res.getZExtValue();
        // Push only the offset to a vector to Rearrange
        OffsetVector.push_back(offset);
        // Push vector pairs of StoreInstructions and offset
        StoreOffset.push_back(std::make_pair(SI, offset));
      }
    }
    Instruction *Ins = StoreInstr[StoreInstr.size() - 1];
    Instruction *TemporaryInst = Ins->getNextNode();
    // Check whether the offset is in order or not
    if (!(std::is_sorted(OffsetVector.begin(), OffsetVector.end()))) {

      std::sort(StoreOffset.begin(), StoreOffset.end(), cmp);
      // Rearrange the store instructions
      for (int i = 0; i < StoreOffset.size(); i++) {
        StoreOffset[i].first->removeFromParent();
        StoreOffset[i].first->insertBefore(TemporaryInst);
      }
    }

    if (std::is_sorted(OffsetVector.begin(), OffsetVector.end()))
      errs()
          << "The array is already in the sorted order. No need to Rearrange\n";
  }

  bool runOnFunction(Function &F) override {
    ++HelloCounter;
    // Get the LoopInfo
    LoopInfo *LI = &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
    // Get the Dependence Info
    DependenceInfo *DI = &getAnalysis<DependenceAnalysisWrapperPass>().getDI();
    // Get the Scalar Evolution
    ScalarEvolution *SE = &getAnalysis<ScalarEvolutionWrapperPass>().getSE();

    for (BasicBlock &BB : F) {
      // Get the Basicblocks inside for loops
      Loop *L = LI->getLoopFor(&BB);
      if (L) {
        for (Instruction &I : BB) {
          // Push the memory instructions into a vector
          if (StoreInst *SI = dyn_cast<StoreInst>(&I))
            MemInstr.push_back(&I);
          else if (auto *Ld = dyn_cast<LoadInst>(&I))
            MemInstr.push_back(&I);
        }
      }
    }
    // Check the dependency and calculate the offset and rearrange the offset
    if (checkDependency(DI)) {
      calculateOffsetAndRearrange(SE);
    } else
      errs() << "Function aborted due to dependency\n";

    return false;
  }

  // We don't modify the program, so we preserve all analyses.
  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<LoopInfoWrapperPass>();
    AU.addRequired<DependenceAnalysisWrapperPass>();
    AU.addRequired<ScalarEvolutionWrapperPass>();
    AU.setPreservesAll();
  }
};
} // namespace

char Hello2::ID = 0;
static RegisterPass<Hello2>
    Y("hello2", "Hello World Pass (with getAnalysisUsage implemented)");
