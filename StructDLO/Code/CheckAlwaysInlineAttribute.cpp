// Module Pass to check AlwaysInline Attribute
#include "llvm/Transforms/Scalar/CheckAlwaysInlineAttribute.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Scalar.h"

using namespace llvm;
void CheckAlwaysInline(Module *M) {
  for (Module::iterator functionIter = M->begin(); functionIter != M->end();
       functionIter++) {
    if (functionIter->isDeclaration())
      continue;

    Attribute attributes =
        functionIter->getFnAttribute(Attribute::AlwaysInline);
    if (!attributes.hasAttribute(Attribute::AlwaysInline)) {
      functionIter->removeFnAttr(llvm::Attribute::OptimizeNone);
      functionIter->removeFnAttr(llvm::Attribute::NoInline);
      functionIter->addFnAttr(llvm::Attribute::AlwaysInline);
      errs() << "AlwaysInline attribute added\n";
    } else {
      errs() << "AlwaysInline attribute already present\n";
    }
  }
}
namespace {
struct CheckAlwaysInlineAttribute : public ModulePass {
  static char ID;
  CheckAlwaysInlineAttribute() : ModulePass(ID) {}

  bool runOnModule(Module &M) override {

    CheckAlwaysInline(&M);

    return false;
  }
};
} // end of namespace

char CheckAlwaysInlineAttribute::ID = 0;
static RegisterPass<CheckAlwaysInlineAttribute>
    X("Check-AlwaysInline-Attribute", "CheckAlwaysInlineAttribute");

PreservedAnalyses
CheckAlwaysInlineAttributePass::run(Module &M, ModuleAnalysisManager &AM) {
  CheckAlwaysInline(&M);
  return PreservedAnalyses::all();
}
