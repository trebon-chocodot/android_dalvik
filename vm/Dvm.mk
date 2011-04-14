# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Common definitions for host or target builds of libdvm.
#
# If you enable or disable optional features here, make sure you do
# a "clean" build -- not everything depends on Dalvik.h.  (See Android.mk
# for the exact command.)
#


#
# Compiler defines.
#
LOCAL_CFLAGS += -fstrict-aliasing -Wstrict-aliasing=2 -fno-align-jumps
LOCAL_CFLAGS += -Wall -Wextra -Wno-unused-parameter -Wc++-compat
LOCAL_CFLAGS += -DARCH_VARIANT=\"$(dvm_arch_variant)\"

#
# Optional features.  These may impact the size or performance of the VM.
#

# Make a debugging version when building the simulator (if not told
# otherwise) and when explicitly asked.
dvm_make_debug_vm := false
ifeq ($(strip $(DEBUG_DALVIK_VM)),)
  ifeq ($(dvm_simulator),true)
    dvm_make_debug_vm := true
  endif
else
  dvm_make_debug_vm := $(DEBUG_DALVIK_VM)
endif

ifeq ($(dvm_make_debug_vm),true)
  #
  # "Debug" profile:
  # - debugger enabled
  # - profiling enabled
  # - tracked-reference verification enabled
  # - allocation limits enabled
  # - GDB helpers enabled
  # - LOGV
  # - assert()
  #
  LOCAL_CFLAGS += -DWITH_INSTR_CHECKS
  LOCAL_CFLAGS += -DWITH_EXTRA_OBJECT_VALIDATION
  LOCAL_CFLAGS += -DWITH_TRACKREF_CHECKS
  LOCAL_CFLAGS += -DWITH_EXTRA_GC_CHECKS=1
  #LOCAL_CFLAGS += -DCHECK_MUTEX
  #LOCAL_CFLAGS += -DPROFILE_FIELD_ACCESS
  LOCAL_CFLAGS += -DDVM_SHOW_EXCEPTION=3
  # add some extra stuff to make it easier to examine with GDB
  LOCAL_CFLAGS += -DEASY_GDB
  # overall config may be for a "release" build, so reconfigure these
  LOCAL_CFLAGS += -UNDEBUG -DDEBUG=1 -DLOG_NDEBUG=1 -DWITH_DALVIK_ASSERT
else  # !dvm_make_debug_vm
  #
  # "Performance" profile:
  # - all development features disabled
  # - compiler optimizations enabled (redundant for "release" builds)
  # - (debugging and profiling still enabled)
  #
  #LOCAL_CFLAGS += -DNDEBUG -DLOG_NDEBUG=1
  # "-O2" is redundant for device (release) but useful for sim (debug)
  #LOCAL_CFLAGS += -O2 -Winline
  #LOCAL_CFLAGS += -DWITH_EXTRA_OBJECT_VALIDATION
  LOCAL_CFLAGS += -DDVM_SHOW_EXCEPTION=1
  # if you want to try with assertions on the device, add:
  #LOCAL_CFLAGS += -UNDEBUG -DDEBUG=1 -DLOG_NDEBUG=1 -DWITH_DALVIK_ASSERT
endif  # !dvm_make_debug_vm

# bug hunting: checksum and verify interpreted stack when making JNI calls
#LOCAL_CFLAGS += -DWITH_JNI_STACK_CHECK

LOCAL_SRC_FILES := \
	AllocTracker.c \
	Atomic.c.arm \
	AtomicCache.c \
	BitVector.c.arm \
	CheckJni.c \
	Ddm.c \
	Debugger.c \
	DvmDex.c \
	Exception.c \
	Hash.c \
	IndirectRefTable.c.arm \
	Init.c \
	InitRefs.c \
	InlineNative.c.arm \
	Inlines.c \
	Intern.c \
	Jni.c \
	JarFile.c \
	LinearAlloc.c \
	Misc.c \
	Native.c \
	PointerSet.c \
	Profile.c \
	Properties.c \
	RawDexFile.c \
	ReferenceTable.c \
	SignalCatcher.c \
	StdioConverter.c \
	Sync.c \
	Thread.c \
	UtfString.c \
	alloc/Alloc.cpp \
	alloc/CardTable.cpp \
	alloc/HeapBitmap.cpp.arm \
	alloc/HeapDebug.cpp \
	alloc/Heap.cpp.arm \
	alloc/DdmHeap.cpp \
	alloc/Verify.cpp \
	alloc/Visit.cpp \
	analysis/CodeVerify.c \
	analysis/DexPrepare.c \
	analysis/DexVerify.c \
	analysis/Liveness.c \
	analysis/Optimize.c \
	analysis/RegisterMap.c \
	analysis/VerifySubs.c \
	analysis/VfyBasicBlock.c \
	hprof/Hprof.cpp \
	hprof/HprofClass.cpp \
	hprof/HprofHeap.cpp \
	hprof/HprofOutput.cpp \
	hprof/HprofString.cpp \
	interp/Interp.c.arm \
	interp/Stack.c \
	jdwp/ExpandBuf.c \
	jdwp/JdwpAdb.c \
	jdwp/JdwpConstants.c \
	jdwp/JdwpEvent.c \
	jdwp/JdwpHandler.c \
	jdwp/JdwpMain.c \
	jdwp/JdwpSocket.c \
	mterp/Mterp.c.arm \
	mterp/out/InterpC-portable.c.arm \
	native/InternalNative.cpp \
	native/dalvik_bytecode_OpcodeInfo.cpp \
	native/dalvik_system_DexFile.cpp \
	native/dalvik_system_VMDebug.cpp \
	native/dalvik_system_VMRuntime.cpp \
	native/dalvik_system_VMStack.cpp \
	native/dalvik_system_Zygote.cpp \
	native/java_lang_Class.cpp \
	native/java_lang_Double.cpp \
	native/java_lang_Float.cpp \
	native/java_lang_Math.cpp \
	native/java_lang_Object.cpp \
	native/java_lang_Runtime.cpp \
	native/java_lang_String.cpp \
	native/java_lang_System.cpp \
	native/java_lang_Throwable.cpp \
	native/java_lang_VMClassLoader.cpp \
	native/java_lang_VMThread.cpp \
	native/java_lang_reflect_AccessibleObject.cpp \
	native/java_lang_reflect_Array.cpp \
	native/java_lang_reflect_Constructor.cpp \
	native/java_lang_reflect_Field.cpp \
	native/java_lang_reflect_Method.cpp \
	native/java_lang_reflect_Proxy.cpp \
	native/java_util_concurrent_atomic_AtomicLong.cpp \
	native/org_apache_harmony_dalvik_NativeTestTarget.cpp \
	native/org_apache_harmony_dalvik_ddmc_DdmServer.cpp \
	native/org_apache_harmony_dalvik_ddmc_DdmVmInternal.cpp \
	native/sun_misc_Unsafe.cpp \
	oo/AccessCheck.cpp \
	oo/Array.cpp \
	oo/Class.cpp \
	oo/Object.cpp \
	oo/Resolve.cpp \
	oo/TypeCheck.cpp \
	reflect/Annotation.cpp \
	reflect/Proxy.cpp \
	reflect/Reflect.cpp \
	test/AtomicTest.c.arm \
	test/TestHash.c \
	test/TestIndirectRefTable.c

WITH_COPYING_GC := $(strip $(WITH_COPYING_GC))

ifeq ($(WITH_COPYING_GC),true)
  LOCAL_CFLAGS += -DWITH_COPYING_GC
  LOCAL_SRC_FILES += \
	alloc/Copying.cpp.arm
else
  LOCAL_SRC_FILES += \
	alloc/HeapSource.cpp \
	alloc/MarkSweep.cpp.arm
endif

WITH_JIT := $(strip $(WITH_JIT))

ifeq ($(WITH_JIT),true)
  LOCAL_CFLAGS += -DWITH_JIT
  LOCAL_SRC_FILES += \
	compiler/Compiler.c \
	compiler/Frontend.c \
	compiler/Utility.c \
	compiler/InlineTransformation.c \
	compiler/IntermediateRep.c \
	compiler/Dataflow.c \
	compiler/SSATransformation.c \
	compiler/Loop.c \
	compiler/Ralloc.c \
	interp/Jit.c
endif

LOCAL_C_INCLUDES += \
	$(JNI_H_INCLUDE) \
	dalvik \
	dalvik/vm \
	external/zlib \
	libcore/include \
	$(KERNEL_HEADERS)

ifeq ($(dvm_simulator),true)
  LOCAL_LDLIBS += -lpthread -ldl
  ifeq ($(HOST_OS),linux)
    # need this for clock_gettime() in profiling
    LOCAL_LDLIBS += -lrt
  endif
endif

MTERP_ARCH_KNOWN := false

ifeq ($(dvm_arch),arm)
  #dvm_arch_variant := armv7-a
  #LOCAL_CFLAGS += -march=armv7-a -mfloat-abi=softfp -mfpu=vfp
  LOCAL_CFLAGS += -Werror
  MTERP_ARCH_KNOWN := true
  # Select architecture-specific sources (armv5te, armv7-a, etc.)
  LOCAL_SRC_FILES += \
		arch/arm/CallOldABI.S \
		arch/arm/CallEABI.S \
		arch/arm/HintsEABI.c \
		mterp/out/InterpC-$(dvm_arch_variant).c.arm \
		mterp/out/InterpAsm-$(dvm_arch_variant).S

  ifeq ($(WITH_JIT),true)
    LOCAL_SRC_FILES += \
		compiler/codegen/RallocUtil.c \
		compiler/codegen/arm/$(dvm_arch_variant)/Codegen.c \
		compiler/codegen/arm/$(dvm_arch_variant)/CallingConvention.S \
		compiler/codegen/arm/Assemble.c \
		compiler/codegen/arm/ArchUtility.c \
		compiler/codegen/arm/LocalOptimizations.c \
		compiler/codegen/arm/GlobalOptimizations.c \
		compiler/codegen/arm/ArmRallocUtil.c \
		compiler/template/out/CompilerTemplateAsm-$(dvm_arch_variant).S
  endif
endif

ifeq ($(dvm_arch),x86)
  ifeq ($(dvm_os),linux)
    MTERP_ARCH_KNOWN := true
    LOCAL_CFLAGS += -DDVM_JMP_TABLE_MTERP=1
    LOCAL_SRC_FILES += \
		arch/$(dvm_arch_variant)/Call386ABI.S \
		arch/$(dvm_arch_variant)/Hints386ABI.c \
		mterp/out/InterpC-$(dvm_arch_variant).c \
		mterp/out/InterpAsm-$(dvm_arch_variant).S
    ifeq ($(WITH_JIT),true)
      LOCAL_SRC_FILES += \
		compiler/codegen/x86/Assemble.c \
		compiler/codegen/x86/ArchUtility.c \
		compiler/codegen/x86/ia32/Codegen.c \
		compiler/codegen/x86/ia32/CallingConvention.S \
		compiler/template/out/CompilerTemplateAsm-ia32.S
    endif
  endif
endif

ifeq ($(dvm_arch),sh)
  MTERP_ARCH_KNOWN := true
  LOCAL_SRC_FILES += \
		arch/sh/CallSH4ABI.S \
		arch/generic/Hints.c \
		mterp/out/InterpC-allstubs.c \
		mterp/out/InterpAsm-allstubs.S
endif

ifeq ($(MTERP_ARCH_KNOWN),false)
  # unknown architecture, try to use FFI
  LOCAL_C_INCLUDES += external/libffi/$(dvm_os)-$(dvm_arch)

  ifeq ($(dvm_os)-$(dvm_arch),darwin-x86)
      # OSX includes libffi, so just make the linker aware of it directly.
      LOCAL_LDLIBS += -lffi
  else
      LOCAL_SHARED_LIBRARIES += libffi
  endif

  LOCAL_SRC_FILES += \
		arch/generic/Call.c \
		arch/generic/Hints.c \
		mterp/out/InterpC-allstubs.c

  # The following symbols are usually defined in the asm file, but
  # since we don't have an asm file in this case, we instead just
  # peg them at 0 here, and we add an #ifdef'able define for good
  # measure, too.
  LOCAL_CFLAGS += -DdvmAsmInstructionStart=0 -DdvmAsmInstructionEnd=0 \
	-DdvmAsmSisterStart=0 -DdvmAsmSisterEnd=0 -DDVM_NO_ASM_INTERP=1
endif
