; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -passes="print<cost-model>" 2>&1 -disable-output -mattr=+avx512fp16 | FileCheck %s

define void @test_vXf16(<8 x half> %src128, <16 x half> %src256, <32 x half> %src512, <64 x half> %src1024) {
; CHECK-LABEL: 'test_vXf16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V128 = shufflevector <8 x half> %src128, <8 x half> undef, <8 x i32> <i32 7, i32 6, i32 6, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V256 = shufflevector <16 x half> %src256, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 13, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V512 = shufflevector <32 x half> %src512, <32 x half> undef, <32 x i32> <i32 31, i32 30, i32 20, i32 28, i32 27, i32 26, i32 25, i32 24, i32 23, i32 22, i32 21, i32 20, i32 19, i32 18, i32 17, i32 16, i32 15, i32 14, i32 13, i32 12, i32 11, i32 11, i32 9, i32 8, i32 7, i32 11, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V1024 = shufflevector <64 x half> %src1024, <64 x half> undef, <64 x i32> <i32 63, i32 62, i32 61, i32 60, i32 59, i32 58, i32 57, i32 56, i32 55, i32 54, i32 53, i32 52, i32 51, i32 50, i32 49, i32 48, i32 47, i32 46, i32 45, i32 44, i32 43, i32 42, i32 41, i32 40, i32 39, i32 38, i32 37, i32 36, i32 35, i32 34, i32 33, i32 32, i32 31, i32 30, i32 29, i32 28, i32 27, i32 26, i32 25, i32 24, i32 23, i32 20, i32 21, i32 20, i32 19, i32 18, i32 17, i32 16, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %V128 = shufflevector <8 x half> %src128, <8 x half> undef, <8 x i32> <i32 7, i32 6, i32 6, i32 4, i32 3, i32 2, i32 1, i32 0>
  %V256 = shufflevector <16 x half> %src256, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 13, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %V512 = shufflevector <32 x half> %src512, <32 x half> undef, <32 x i32> <i32 31, i32 30, i32 20, i32 28, i32 27, i32 26, i32 25, i32 24, i32 23, i32 22, i32 21, i32 20, i32 19, i32 18, i32 17, i32 16, i32 15, i32 14, i32 13, i32 12, i32 11, i32 11, i32 9, i32 8, i32 7, i32 11, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %V1024 = shufflevector <64 x half> %src1024, <64 x half> undef, <64 x i32> <i32 63, i32 62, i32 61, i32 60, i32 59, i32 58, i32 57, i32 56, i32 55, i32 54, i32 53, i32 52, i32 51, i32 50, i32 49, i32 48, i32 47, i32 46, i32 45, i32 44, i32 43, i32 42, i32 41, i32 40, i32 39, i32 38, i32 37, i32 36, i32 35, i32 34, i32 33, i32 32, i32 31, i32 30, i32 29, i32 28, i32 27, i32 26, i32 25, i32 24, i32 23, i32 20, i32 21, i32 20, i32 19, i32 18, i32 17, i32 16, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  ret void
}