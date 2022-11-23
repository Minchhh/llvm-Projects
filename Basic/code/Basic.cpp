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
#include "llvm/IR/CFG.h"
#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
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

    int MaxBasicBlock = 0;
    int MaxPredecessor = 0;
    int MaxSuccessor = 0;
    BasicBlock *MaximumBasicBlock = nullptr;
    BasicBlock *Predecessor = nullptr;
    BasicBlock *Successor = nullptr;
    std::vector<int> V;

    errs() << "Number of basicblocks is " << F.size() << '\n';
    for (BasicBlock &BB : F) {
      V.push_back(BB.size());
      // Maximum Basic Block
      if (BB.size() > MaxBasicBlock) {
        MaxBasicBlock = BB.size();
        MaximumBasicBlock = &BB;
      }

      // Predecessor
      int CountPredecessor = 0;
      for (BasicBlock *Pred : predecessors(&BB)) {
        CountPredecessor++;
        if (CountPredecessor >= 2) {
          errs() << "The Basic Block which has 2+ predecessor are\n";
          BB.dump();
        }
        if (CountPredecessor >= MaxPredecessor) {
          MaxPredecessor = CountPredecessor;
          Predecessor = &BB;
        }
      }

      // Successor
      int CountSuccessor = 0;
      for (BasicBlock *Suc : successors(&BB)) {
        CountSuccessor++;
        if (CountSuccessor >= 2) {
          errs() << "The Basic Block which has 2+ successors are\n";
          BB.dump();
        }

        if (CountSuccessor >= MaxSuccessor) {
          MaxSuccessor = CountSuccessor;
          Successor = &BB;
        }
      }
    }

    if (Predecessor) {
      errs() << "The Basic Block which has max predecessors are\n";
      Predecessor->dump();
    }

    if (Successor) {
      errs() << "The Basic Block which has max successors are\n";
      Successor->dump();
    }

    for (int i = 0; i < V.size(); i++)
      errs() << "Each Basic block has " << V[i] << " instructions.\n";

    errs() << "\nThe Basic Block with maximum instruction is \n";
    MaximumBasicBlock->dump();

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
