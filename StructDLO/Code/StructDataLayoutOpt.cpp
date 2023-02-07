// Writing my first Module pass

#include "llvm/Transforms/Scalar/StructDataLayoutOpt.h"
#include "llvm/Analysis/LoopAccessAnalysis.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Operator.h"
#include "llvm/IR/Use.h"
#include "llvm/IR/Value.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include <map>
#include <string.h>
#include <vector>

using namespace llvm;

// Command line options
static cl::opt<bool> StructDLOOpt("struct-dlo-opt", cl::init(false), cl::Hidden,
                                  cl::desc("Enable StructDLO Pass"));

// Function to calculate the offset
template <typename T> int CalculateOffset(T *Gep) {
  int Offset = -1;
  auto *PtrTy = dyn_cast_or_null<PointerType>(Gep->getPointerOperandType());
  if (!PtrTy && PtrTy->isOpaque())
    return -1;

  auto *NonOpaquePointerElementType = PtrTy->getNonOpaquePointerElementType();
  if (NonOpaquePointerElementType->isArrayTy()) {
    auto *GEPPointerOperand = Gep->getPointerOperand();
    GetElementPtrInst *GEPInstruction =
        dyn_cast_or_null<GetElementPtrInst>(GEPPointerOperand);
    auto *PtrTy =
        dyn_cast_or_null<PointerType>(GEPInstruction->getPointerOperandType());
    if (PtrTy && !PtrTy->isOpaque()) {
      auto *PointerElementType = PtrTy->getNonOpaquePointerElementType();
      if (PointerElementType->isStructTy()) {
        auto Operand = GEPInstruction->getOperand(2);
        auto *CI = dyn_cast_or_null<ConstantInt>(Operand);
        Offset = CI->getZExtValue();
      }
    }
  }
  if (NonOpaquePointerElementType->isStructTy()) {
    auto Operand = Gep->getOperand(2);
    auto *CI = dyn_cast_or_null<ConstantInt>(Operand);
    Offset = CI->getZExtValue();
  }
  return Offset;
}

// Function to remove all the instructions offseting deadfield
void RemoveDeadFieldInstructions(int DeadField, Function *F) {
  std::multimap<int, Instruction *> GetOffsetAndInstruction;

  for (BasicBlock &BB : *F) {
    for (Instruction &I : BB) {
      if (isa<StoreInst>(&I)) {
        StoreInst *SI = dyn_cast_or_null<StoreInst>(&I);
        Value *GetPointer = SI->getPointerOperand();
        GEPOperator *GEPOp = dyn_cast_or_null<GEPOperator>(GetPointer);
        if (GEPOp) {
          int Offset = CalculateOffset<GEPOperator>(GEPOp);
          if (Offset == DeadField) {
            GetOffsetAndInstruction.insert({Offset, SI});
          }
        }
      }

      else if (isa<GetElementPtrInst>(&I)) {
        GetElementPtrInst *GEPInstruction =
            dyn_cast_or_null<GetElementPtrInst>(&I);
        int Offset = CalculateOffset<GetElementPtrInst>(GEPInstruction);
        if (Offset == DeadField) {
          GetOffsetAndInstruction.insert({Offset, GEPInstruction});
        }
      }
    }
  }
  for (auto &it : GetOffsetAndInstruction) {
    *(it.second)->eraseFromParent();
  }
}

// Function to populate the vector fields
void AssignFieldWeight(Value *GetPointer, bool isInsideLoop,
                       std::vector<long unsigned int> &Fields, int LoopDepth) {

  GEPOperator *GEPOp = dyn_cast_or_null<GEPOperator>(GetPointer);
  GetElementPtrInst *GEPInstruction =
      dyn_cast_or_null<GetElementPtrInst>(GetPointer);

  if (!(GEPOp || GEPInstruction))
    return;

  if (GEPOp) {
    int Offset = CalculateOffset<GEPOperator>(GEPOp);
    if (isInsideLoop == false && Offset != -1)
      Fields[Offset]++;
    else if (isInsideLoop == true && Offset != -1)
      Fields[Offset] += pow(8, LoopDepth);
  } else if (GEPInstruction) {
    int Offset = CalculateOffset<GetElementPtrInst>(GEPInstruction);
    if (isInsideLoop == false && Offset != -1)
      Fields[Offset]++;
    else if (isInsideLoop == true && Offset != -1)
      Fields[Offset] += pow(8, LoopDepth);
  }
}

// Function to Create a New GlobalVariable And Replace OldUses
// With NewUses
void CreateNewGlobalVarAndReplaceOldUses(Module *M, StructType *NewStructTy,
                                         std::vector<long unsigned int> &Fields,
                                         StructType *ST, LLVMContext &Context) {

  GlobalVariable *OldGlobalVar = nullptr;
  GlobalVariable *NewGlobalVar = nullptr;
  long unsigned int count = 0;
  std::map<long unsigned int, long unsigned int> MapCrtVal;
  std::vector<User *> uses;
  IRBuilder<> Builder(Context);

  // Iterate over all the Global Variables in the Module and get global variable
  // of given struct type
  for (auto &GetGlobalVar : M->getGlobalList()) {
    auto GetGlobalVarType = GetGlobalVar.getInitializer()->getType();
    if (GetGlobalVarType == ST) {
      OldGlobalVar = &GetGlobalVar;
    }
  }

  // GlobalVariable G creation
  NewGlobalVar = new GlobalVariable(
      *M, NewStructTy, false, GlobalValue::ExternalLinkage,
      Constant::getNullValue(NewStructTy), OldGlobalVar->getName());

  // Mapping to get the right offset
  for (int i = 0; i < Fields.size(); i++) {
    if (Fields[i] != 0) {
      MapCrtVal[i] = count++;
    }
  }

  // Iterating over all the uses of the oldglobalVar and replacing its
  // uses with new uses
  for (auto U : OldGlobalVar->users()) { // U is of type User*

    std::vector<Value *> Index;
    // For GEP Instruction
    if (auto Ins = dyn_cast<Instruction>(U)) {
      if (isa<GetElementPtrInst>(Ins)) {
        Index.push_back(Ins->getOperand(1));

        auto Operand = Ins->getOperand(2);
        auto *Ty = Ins->getOperand(2)->getType();
        auto *CI = dyn_cast_or_null<ConstantInt>(Operand);
        int Offset = CI->getZExtValue();

        if (Fields[Offset] == 0)
          continue;

        Value *Val = nullptr;
        if (Ty->isIntegerTy()) {
          Val = ConstantInt::get(Ty, MapCrtVal[Offset]);
        }

        Index.push_back(Val);
        Index.push_back(Ins->getOperand(3));

        // Creating a New GEP Instruction
        auto *New =
            GetElementPtrInst::Create(NewGlobalVar->getInitializer()->getType(),
                                      NewGlobalVar, Index, Ins->getName(), Ins);
        Ins->replaceAllUsesWith(New);
        uses.push_back(U);
      }
    }
    // For GEP Operator
    else if (auto GepOp = dyn_cast<GEPOperator>(U)) {
      Index.push_back(GepOp->getOperand(1));

      auto Operand = GepOp->getOperand(2);
      auto *Ty = Operand->getType();
      auto *CI = dyn_cast_or_null<ConstantInt>(Operand);
      int Offset = CI->getZExtValue();

      if (Fields[Offset] == 0)
        continue;

      Value *Val = nullptr;
      if (Ty->isIntegerTy()) {
        Val = ConstantInt::get(Ty, MapCrtVal[Offset]);
      }

      Index.push_back(Val);

      // Creating a New GEP Operator
      auto *New = Builder.CreateGEP(NewGlobalVar->getInitializer()->getType(),
                                    NewGlobalVar, Index, "",
                                    cast<GEPOperator>(U)->isInBounds());
      GepOp->replaceAllUsesWith(New);
    }
  }
  // Removing all the old GEP Instructions from the IR
  for (auto it = uses.begin(); it != uses.end(); it++) {
    if (auto I = dyn_cast_or_null<Instruction>(*it)) {
      I->eraseFromParent();
    }
  }
  uses.clear();
  OldGlobalVar->eraseFromParent();
}
// Function to calculate the vector fields
void CalculateFieldWeight(Function *F, int NumberOfElements, LoopInfo *LI,
                          std::vector<long unsigned int> &Fields) {
  int LoopDepth = 0;
  for (BasicBlock &BB : *F) {
    bool isInsideLoop;
    Loop *L = LI->getLoopFor(&BB);
    if (!L)
      isInsideLoop = false;
    else {
      LoopDepth = LI->getLoopDepth(&BB);
      isInsideLoop = true;
    }

    for (Instruction &I : BB) {
      if (isa<LoadInst>(&I)) {
        LoadInst *LOI = dyn_cast_or_null<LoadInst>(&I);
        Value *GetPointer = LOI->getPointerOperand();
        AssignFieldWeight(GetPointer, isInsideLoop, Fields, LoopDepth);
      }
    }
  }
}

// Function to check Dead, Hot and cold fields of a structure based on the
// values present in the Fields Vector and to check whether dead fields are
// further present or not in the function
bool CheckDeadFields(std::vector<long unsigned int> &Fields,
                     Function *MainFunction, StructType *ST,
                     LLVMContext &Context) {
  StructType *NewStructTy = nullptr;
  std::vector<Type *> EltTys;
  std::vector<long unsigned int>::iterator it;
  Module *M = MainFunction->getParent();

  for (int i = 0; i < Fields.size(); i++) {
    if (Fields[i] == 0) {
      errs() << i << " element of Structure is Dead Field\n";
      RemoveDeadFieldInstructions(i, MainFunction);
    } else if (0 < Fields[i] && Fields[i] < 50) {
      EltTys.push_back(ST->getTypeAtIndex(i));
      errs() << i << " element of Structure is Cold Field\n";
    } else {
      EltTys.push_back(ST->getTypeAtIndex(i));
      errs() << i << " element of Structure is Hot Field\n";
    }
  }

  it = std::find(Fields.begin(), Fields.end(), 0);
  if (it != Fields.end()) {
    std::string OldStructureName;
    OldStructureName = ST->getName();
    NewStructTy = StructType::create(M->getContext(), OldStructureName);

    NewStructTy->setBody(EltTys);
    errs() << "Modified Structure Type after removing the dead fields\n";
    NewStructTy->dump();

    CreateNewGlobalVarAndReplaceOldUses(M, NewStructTy, Fields, ST, Context);
  } else if (it == Fields.end()) {
    errs() << "There are No dead Fields\n";
    return true;
  }
  return false;
}
// Function to get the  Main function
static Function *GetMainFunction(Module &M) {

  std::vector<Function *> FunctionVector;
  Function *MainFunction = nullptr;

  for (Function &F : M) {
    if (F.getName() != "main" && !F.isDeclaration())
      FunctionVector.push_back(&F);

    if (F.getName() == "main")
      MainFunction = &F;
  }
  // Erasing all the functions except the main function as the other functions
  // are already inlined
  for (auto it = FunctionVector.begin(); it != FunctionVector.end(); it++) {
    if (auto Func = dyn_cast_or_null<Function>(*it))
      Func->eraseFromParent();
  }
  FunctionVector.clear();

  return MainFunction;
}
// Function to Remove the Dead Fields of a Structure
static bool RemoveDeadFieldsOfStruct(Module &M, LoopInfo *LI,
                                     Function *MainFunction) {
  std::vector<StructType *> Types = M.getIdentifiedStructTypes();
  for (StructType *ST : Types) {
    ST->dump();
    int NumberOfElements = ST->getNumElements();
    std::vector<long unsigned int> Fields(NumberOfElements, 0);
    CalculateFieldWeight(MainFunction, NumberOfElements, LI, Fields);
    if (CheckDeadFields(Fields, MainFunction, ST, M.getContext()))
      return true;
  }
  return false;
}
namespace {
struct StructDLO : public ModulePass {

  static char ID;
  StructDLO() : ModulePass(ID) {}
  bool runOnModule(Module &M) override {
    if (!StructDLOOpt)
      return false;

    Function *MainFunction = GetMainFunction(M);
    if (!MainFunction)
      return false;
    LoopInfo *LI =
        &getAnalysis<LoopInfoWrapperPass>(*MainFunction).getLoopInfo();
    if (RemoveDeadFieldsOfStruct(M, LI, MainFunction))
      return false;

    return false;
  }
  // get the required analysis passes
  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesAll();
    AU.addRequired<LoopInfoWrapperPass>();
  }
};

} // end of namespace

char StructDLO::ID = 0;
static RegisterPass<StructDLO> X("StructDLO", "StructDLOPass");

PreservedAnalyses StructDLOPass::run(Module &M, ModuleAnalysisManager &AM) {
  auto &FAM = AM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();
  PreservedAnalyses PA;
  if (!StructDLOOpt)
    return PA;

  Function *MainFunction = GetMainFunction(M);
  if (!MainFunction)
    return PA;

  auto LookupLoopInfo = [&FAM](Function *MainFunction) -> LoopInfo & {
    return FAM.getResult<LoopAnalysis>(*MainFunction);
  };
  LoopInfo *LI = &LookupLoopInfo(MainFunction);
  if (RemoveDeadFieldsOfStruct(M, LI, MainFunction))
    return PA;

  PA.preserve<LoopAnalysis>();
  return PA;
}

