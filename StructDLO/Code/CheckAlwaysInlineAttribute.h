#include "llvm/IR/PassManager.h"

namespace llvm {

class Module;

/// Pass to convert @llvm.global.annotations to !annotation metadata.
struct CheckAlwaysInlineAttributePass
    : public PassInfoMixin<CheckAlwaysInlineAttributePass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
};

} // namespace llvm
