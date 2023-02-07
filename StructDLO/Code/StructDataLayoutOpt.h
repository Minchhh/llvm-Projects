#include "llvm/IR/PassManager.h"

namespace llvm {
class Module;

struct StructDLOPass : public PassInfoMixin<StructDLOPass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
};
} // end namespace llvm
