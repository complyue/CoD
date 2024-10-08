
EXEC := bin/cod

# Default target
all: $(EXEC)


# Compiler and flags from LLVM
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)
	LLVM_CONFIG := $(shell brew --prefix llvm@18)/bin/llvm-config
    CXXFLAGS := -mmacosx-version-min=12.7
	LDFLAGS := 
else
	LLVM_CONFIG := llvm-config-18
	CXXFLAGS := 
	LDFLAGS := 
endif

CXXFLAGS += $(shell $(LLVM_CONFIG) --cxxflags)
LDFLAGS += $(shell $(LLVM_CONFIG) --ldflags --system-libs --libs all)

LDFLAGS += -lclangAST -lclangBasic -lclangFrontend -lclangInterpreter \
	-lclangAPINotes \
	-lclangARCMigrate \
	-lclangAST \
	-lclangASTMatchers \
	-lclangAnalysis \
	-lclangAnalysisFlowSensitive \
	-lclangAnalysisFlowSensitiveModels \
	-lclangApplyReplacements \
	-lclangBasic \
	-lclangChangeNamespace \
	-lclangCodeGen \
	-lclangCrossTU \
	-lclangDaemon \
	-lclangDaemonTweaks \
	-lclangDependencyScanning \
	-lclangDirectoryWatcher \
	-lclangDoc \
	-lclangDriver \
	-lclangDynamicASTMatchers \
	-lclangEdit \
	-lclangExtractAPI \
	-lclangFormat \
	-lclangFrontend \
	-lclangFrontendTool \
	-lclangHandleCXX \
	-lclangHandleLLVM \
	-lclangIncludeCleaner \
	-lclangIncludeFixer \
	-lclangIncludeFixerPlugin \
	-lclangIndex \
	-lclangIndexSerialization \
	-lclangInterpreter \
	-lclangLex \
	-lclangMove \
	-lclangParse \
	-lclangPseudo \
	-lclangPseudoCLI \
	-lclangPseudoCXX \
	-lclangPseudoGrammar \
	-lclangQuery \
	-lclangReorderFields \
	-lclangRewrite \
	-lclangRewriteFrontend \
	-lclangSema \
	-lclangSerialization \
	-lclangStaticAnalyzerCheckers \
	-lclangStaticAnalyzerCore \
	-lclangStaticAnalyzerFrontend \
	-lclangSupport \
	-lclangTidy \
	-lclangTidyAbseilModule \
	-lclangTidyAlteraModule \
	-lclangTidyAndroidModule \
	-lclangTidyBoostModule \
	-lclangTidyBugproneModule \
	-lclangTidyCERTModule \
	-lclangTidyConcurrencyModule \
	-lclangTidyCppCoreGuidelinesModule \
	-lclangTidyDarwinModule \
	-lclangTidyFuchsiaModule \
	-lclangTidyGoogleModule \
	-lclangTidyHICPPModule \
	-lclangTidyLLVMLibcModule \
	-lclangTidyLLVMModule \
	-lclangTidyLinuxKernelModule \
	-lclangTidyMPIModule \
	-lclangTidyMain \
	-lclangTidyMiscModule \
	-lclangTidyModernizeModule \
	-lclangTidyObjCModule \
	-lclangTidyOpenMPModule \
	-lclangTidyPerformanceModule \
	-lclangTidyPlugin \
	-lclangTidyPortabilityModule \
	-lclangTidyReadabilityModule \
	-lclangTidyUtils \
	-lclangTidyZirconModule \
	-lclangTooling \
	-lclangToolingASTDiff \
	-lclangToolingCore \
	-lclangToolingInclusions \
	-lclangToolingInclusionsStdlib \
	-lclangToolingRefactoring \
	-lclangToolingSyntax \
	-lclangTransformer \
	-lclangdRemoteIndex \
	-lclangdSupport \

CXX := $(shell $(LLVM_CONFIG) --bindir)/clang++

# Directories
SRCDIR := src
BUILDDIR := build

# Find all .cxx source files recursively in SRCDIR
SRCS := $(shell find $(SRCDIR) -name '*.cxx')
# Convert source file paths to object file paths (preserving subdirectory structure)
OBJS := $(patsubst $(SRCDIR)/%.cxx,$(BUILDDIR)/%.o,$(SRCS))


# Ensure the build directory exists
$(BUILDDIR):
	@mkdir -p bin
	@mkdir -p $(BUILDDIR)

# Rule to link the executable
$(EXEC): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(LDFLAGS)

# Rule to build object files, ensuring the target directory exists
$(BUILDDIR)/%.o: $(SRCDIR)/%.cxx
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean up
clean:
	rm -rf $(BUILDDIR) $(EXEC)

.PHONY: all clean
