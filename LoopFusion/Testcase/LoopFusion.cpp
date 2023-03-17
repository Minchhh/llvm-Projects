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
#include "llvm/Analysis/DependenceAnalysis.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

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
    dbgs() << "Hello: ";
    dbgs().write_escaped(F.getName()) << '\n';
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
  LoopInfo *LI = nullptr;
  ScalarEvolution *SE = nullptr;
  DependenceInfo *DI = nullptr;
  Hello2() : FunctionPass(ID) {}

  // Function to check Call Instructions present in the loop
  bool checkCallInstruction(Loop *L, Function *F) {
    for (Function::iterator BB = F->begin(), BE = F->end(); BB != BE; ++BB) {
      for (BasicBlock::iterator I = BB->begin(), IE = BB->end(); I != IE; ++I) {
        if (dyn_cast_or_null<CallInst>(I) || dyn_cast_or_null<InvokeInst>(I)) {
          BasicBlock *B = I->getParent();
          // Check if the call instruction is present inside the loop
          if (L->contains(B) || L->getLoopPreheader() == B ||
              L->getHeader() == B || L->getExitBlock() == B)
            return true;
        }
      }
    }
    return false;
  }

  // Function to fuse the 2 loops
  Loop *LoopFusion(Loop *L1, Loop *L2) {
    Loop *L = nullptr;
    if (!L1) {
      L = L2;
      return L;
    }

    if (!legalityCheck(L1, L2))
      return L;

    if (L1->isGuarded() && L2->isGuarded())
      L = GuardedLoopFusion(L1, L2);
    else if (!L1->isGuarded() && !L2->isGuarded())
      L = NonGuardedLoopFusion(L1, L2);

    return L;
  }

  // Function to check whether the loop has loop-carried dependency
  bool hasLoopCarriedDependency(std::vector<Instruction *> MemInstr) {
    // Check for a loop-carried dependence between the loops.
    std::vector<Instruction *>::iterator I, IE, J, JE;
    for (I = MemInstr.begin(), IE = MemInstr.end(); I != IE; I++) {
      for (J = I + 1, JE = MemInstr.end(); J != JE; J++) {
        auto D = DI->depends(*I, *J, true);
        if (!D)
          continue;
        int Level = D->getLevels();
        const SCEV *Distance = D->getDistance(Level);
        // Check the loop-carried dependency
        if (D->isAnti() && D->isConsistent() && !Distance->isZero())
          // There is a loop-carried dependency between the loops.
          return true;
      }
    }
    // There is no loop-carried dependency between the loops.
    return false;
  }

  // Function to check whether their is a dependency
  bool checkDependency(Loop *L1, Loop *L2) {
    std::vector<Instruction *> SrcIList;
    std::vector<Instruction *> DstIList;
    BasicBlock *Body1 = nullptr;
    BasicBlock *Body2 = nullptr;

    // Get the loop body
    if (L1->isGuarded() && L2->isGuarded()) {
      Body1 = L1->getHeader();
      Body2 = L2->getHeader();
    } else if (!L1->isGuarded() && !L2->isGuarded()) {
      Body1 = L1->getLoopLatch()->getSinglePredecessor();
      Body2 = L2->getLoopLatch()->getSinglePredecessor();
    }

    // Get the memory instructions from the loop body
    for (auto i = Body1->begin(); i != Body1->end(); i++) {
      Instruction *I = dyn_cast_or_null<Instruction>(i);
      if (isa<StoreInst>(*I) || isa<LoadInst>(*I))
        SrcIList.push_back(I);
    }

    for (auto i = Body2->begin(); i != Body2->end(); i++) {
      Instruction *I = dyn_cast_or_null<Instruction>(i);
      if (isa<StoreInst>(*I) || isa<LoadInst>(*I))
        DstIList.push_back(I);
    }

    // check the loopcarried dependency if their are more than one memory
    // instructions in the loop body of Loop1/Source
    if (SrcIList.size() > 1 && hasLoopCarriedDependency(SrcIList))
      return true;

    // check the loopcarried dependency if their are more than one memory
    // instructions in the loop body of Loop2/Destination
    if (DstIList.size() > 1 && hasLoopCarriedDependency(DstIList))
      return true;

    // check for dependency across the loops
    for (Instruction *ISrc : SrcIList) {
      for (Instruction *IDst : DstIList) {
        auto D = DI->depends(ISrc, IDst, true);
        if (!D)
          continue;
        if (D->isAnti())
          return true;
      }
    }
    return false;
  }

  // Function to check whether the loops are adjacent or not
  bool adjacent(Loop *L1, Loop *L2) {

    // when loop has guard branch
    if (L1->isGuarded() && L2->isGuarded()) {
      BasicBlock *L1_getNonLoopBlock = nullptr;
      auto *B1 = L1->getLoopGuardBranch();
      if (B1->isConditional())
        L1_getNonLoopBlock = B1->getSuccessor(1);

      BasicBlock *L2_EntryBlock = L2->getLoopGuardBranch()->getParent();
      if (L1_getNonLoopBlock == L2_EntryBlock)
        return true;
    }
    // when loop doesn't have guard branch
    else {
      if (L1->getExitBlock() == L2->getLoopPreheader())
        return true;
    }
    return false;
  }

  // function to check legality of 2 loops
  bool legalityCheck(Loop *L1, Loop *L2) {

    Optional<Loop::LoopBounds> Bounds1 = L1->getBounds(*SE);
    Optional<Loop::LoopBounds> Bounds2 = L2->getBounds(*SE);

    if (!Bounds1.hasValue() || !Bounds2.hasValue()) {
      dbgs() << "Did not get the bounds,cannot fuse the loops\n";
      return false;
    }
    if (&Bounds1->getInitialIVValue() != &Bounds2->getInitialIVValue()) {
      dbgs() << "The Initial Values of the Loop didn't match,cannot fuse the "
                "loops\n";
      return false;
    }
    if (Bounds1->getStepValue() != Bounds2->getStepValue()) {
      dbgs() << "The Step Values of the Loop didn't match,cannot fuse the "
                "loops\n";
      return false;
    }
    const SCEV *TripCount1 = SE->getBackedgeTakenCount(L1);
    const SCEV *TripCount2 = SE->getBackedgeTakenCount(L2);
    if (TripCount1 != TripCount2) {
      dbgs()
          << "The TripCount of the Loop didn't match,cannot fuse the loops\n";
      return false;
    }
    if ((!L1->isGuarded() && L2->isGuarded()) ||
        (L1->isGuarded() && !L2->isGuarded())) {
      dbgs() << "Either one of the loop doesn't have the guard Branch,cannot "
                "fuse the loops\n";
      return false;
    }
    if (!adjacent(L1, L2)) {
      dbgs() << "Loops are not Adjacent,cannot fuse the loops\n";
      return false;
    }
    if (checkDependency(L1, L2)) {
      dbgs()
          << "Between Loops their exist a dependency,cannot fuse the loops\n";
      return false;
    }

    return true;
  }

  // function to fuse 2 loops with guard branch
  Loop *GuardedLoopFusion(Loop *L1, Loop *L2) {
    std::vector<Instruction *> InstructionVector;

    // get the induction variable
    auto IV1 = L1->getInductionVariable(*SE);
    auto IV2 = L2->getInductionVariable(*SE);

    // replace all the uses of 2nd Induction variable with 1st induction
    // variable
    IV2->replaceAllUsesWith(IV1);
    IV2->eraseFromParent();

    // fuse 2 loop bodies
    auto *Header = L2->getHeader();
    for (auto i = Header->begin(); i != Header->end(); i++) {
      Instruction *I = dyn_cast_or_null<Instruction>(i);
      InstructionVector.push_back(I);
    }

    auto *insertpoint = L1->getHeader()->getTerminator();
    for (Instruction *I : InstructionVector) {
      if (isa<BranchInst>(*I) || isa<PHINode>(*I))
        continue;
      I->moveBefore(insertpoint);
    }
    // change/set the branches
    BranchInst *BI1 = L1->getLoopGuardBranch();
    auto *Exit2 = L2->getLoopGuardBranch();
    if (Exit2->isConditional())
      BI1->setSuccessor(1, Exit2->getSuccessor(1));

    auto *Exit1 = L1->getExitBlock();
    BranchInst *BI2 = dyn_cast_or_null<BranchInst>(Exit1->getTerminator());
    BI2->setSuccessor(0, Exit2->getSuccessor(1));

    // remove unneccessary basicblocks
    auto BB0 = L2->getLoopGuardBranch()->getParent();
    BB0->dropAllReferences();
    BB0->eraseFromParent();

    auto BB1 = L2->getLoopPreheader();
    BB1->dropAllReferences();
    BB1->removeFromParent();

    auto BB2 = L2->getExitBlock();

    for (auto *Block : L2->blocks())
      Block->dropAllReferences();

    for (auto *Block : L2->blocks())
      Block->eraseFromParent();

    BB2->dropAllReferences();
    BB2->eraseFromParent();

    return L1;
  }

  // function to fuse 2 loops with Nonguard branch
  Loop *NonGuardedLoopFusion(Loop *L1, Loop *L2) {
    std::vector<Instruction *> InstructionVector;
    // get the induction variable
    auto IV1 = L1->getInductionVariable(*SE);
    auto IV2 = L2->getInductionVariable(*SE);

    // replace all the uses of 2nd Induction variable with 1st induction
    // variable
    IV2->replaceAllUsesWith(IV1);
    IV2->eraseFromParent();

    // fuse 2 loop bodies
    auto *Body2 = L2->getLoopLatch()->getSinglePredecessor();

    for (auto i = Body2->begin(); i != Body2->end(); i++) {
      Instruction *I = dyn_cast_or_null<Instruction>(i);
      InstructionVector.push_back(I);
    }
    auto *Body1 = L1->getLoopLatch()->getSinglePredecessor();
    auto InsertPoint = Body1->getTerminator();
    for (Instruction *I : InstructionVector) {
      if (isa<BranchInst>(*I) || isa<PHINode>(*I))
        continue;
      I->moveBefore(InsertPoint);
    }
    // change/set the branches
    auto *Latch = L1->getLoopLatch();
    BranchInst *BI = dyn_cast_or_null<BranchInst>(Latch->getTerminator());
    BI->setSuccessor(1, L2->getExitBlock());

    // remove unwanted Basicblock
    auto Preheader2 = L2->getLoopPreheader();
    Preheader2->eraseFromParent();

    for (auto *Block : L2->blocks())
      Block->dropAllReferences();

    for (auto *Block : L2->blocks())
      Block->eraseFromParent();

    return L1;
  }

  bool runOnFunction(Function &F) override {
    ++HelloCounter;
    LI = &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
    SE = &getAnalysis<ScalarEvolutionWrapperPass>().getSE();
    DI = &getAnalysis<DependenceAnalysisWrapperPass>().getDI();
    std::vector<Loop *> LoopVector;
    Loop *LoopFuse = nullptr;

    for (auto i = LI->begin(); i != LI->end(); i++) {
      auto L = *i;
      // check whether the branch is nested or not
      if (!L->getSubLoops().empty()) {
        dbgs() << "Nested Loops Exist, cannot fuse the loops\n";
        return false;
      }
      // check whether the loop is in rotated or loopsimplify form
      if (!L->isRotatedForm() || !L->isLoopSimplifyForm()) {
        dbgs() << "Loop not in required form, cannot fuse the loops\n";
        return false;
      }
      if (checkCallInstruction(L, &F)) {
        dbgs() << "There is a Call Instruction in the loop, cannot fuse the "
                  "loops\n";
        return false;
      }
      LoopVector.push_back(L);
    }

    int n = LoopVector.size();
    if (LoopVector.size() == 1 || LoopVector.size() == 0) {
      dbgs() << "No loops or Single Loop Present in the function "
             << F.getName()
             << " cannot fuse "
                "further\n";
      return false;
    }
    while (n != 0) {
      LoopFuse = LoopFusion(LoopFuse, LoopVector[n - 1]);
      n--;
    }

    if (LoopFuse) {
      dbgs() << "Loop Fuse Successfull and the final Loop is\n";
      LoopFuse->print(dbgs());
    }

    return false;
  }

  // We don't modify the program, so we preserve all analyses.
  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<LoopInfoWrapperPass>();
    AU.addRequired<ScalarEvolutionWrapperPass>();
    AU.addRequired<DependenceAnalysisWrapperPass>();
    AU.setPreservesAll();
  }
};
} // namespace

char Hello2::ID = 0;
static RegisterPass<Hello2>
    Y("hello2", "Hello World Pass (with getAnalysisUsage implemented)");
