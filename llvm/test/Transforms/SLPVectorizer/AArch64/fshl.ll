; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -mtriple=arm64-apple-ios -S -passes=slp-vectorizer < %s | FileCheck %s

; fshl instruction cost model is an overestimate causing this test to vectorize when it is not beneficial to do so.
define i64 @fshl(i64 %or1, i64 %or2, i64 %or3  ) {
; CHECK-LABEL: define i64 @fshl
; CHECK-SAME: (i64 [[OR1:%.*]], i64 [[OR2:%.*]], i64 [[OR3:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OR4:%.*]] = tail call i64 @llvm.fshl.i64(i64 [[OR2]], i64 0, i64 1)
; CHECK-NEXT:    [[XOR1:%.*]] = xor i64 [[OR4]], 0
; CHECK-NEXT:    [[OR5:%.*]] = tail call i64 @llvm.fshl.i64(i64 [[OR3]], i64 0, i64 2)
; CHECK-NEXT:    [[XOR2:%.*]] = xor i64 [[OR5]], [[OR1]]
; CHECK-NEXT:    [[ADD1:%.*]] = add i64 [[XOR1]], [[OR1]]
; CHECK-NEXT:    [[ADD2:%.*]] = add i64 0, [[XOR2]]
; CHECK-NEXT:    [[OR6:%.*]] = tail call i64 @llvm.fshl.i64(i64 [[OR1]], i64 [[OR2]], i64 17)
; CHECK-NEXT:    [[XOR3:%.*]] = xor i64 [[OR6]], [[ADD1]]
; CHECK-NEXT:    [[OR7:%.*]] = tail call i64 @llvm.fshl.i64(i64 0, i64 0, i64 21)
; CHECK-NEXT:    [[XOR4:%.*]] = xor i64 [[OR7]], [[ADD2]]
; CHECK-NEXT:    [[ADD3:%.*]] = or i64 [[XOR3]], [[ADD2]]
; CHECK-NEXT:    [[XOR5:%.*]] = xor i64 [[ADD3]], [[XOR4]]
; CHECK-NEXT:    ret i64 [[XOR5]]
;
entry:
  %or4 = tail call i64 @llvm.fshl.i64(i64 %or2, i64 0, i64 1)
  %xor1 = xor i64 %or4, 0
  %or5 = tail call i64 @llvm.fshl.i64(i64 %or3, i64 0, i64 2)
  %xor2 = xor i64 %or5, %or1
  %add1 = add i64 %xor1, %or1
  %add2 = add i64 0, %xor2
  %or6 = tail call i64 @llvm.fshl.i64(i64 %or1, i64 %or2, i64 17)
  %xor3 = xor i64 %or6, %add1
  %or7 = tail call i64 @llvm.fshl.i64(i64 0, i64 0, i64 21)
  %xor4 = xor i64 %or7, %add2
  %add3 = or i64 %xor3, %add2
  %xor5 = xor i64 %add3, %xor4
  ret i64 %xor5
}

declare i64 @llvm.fshl.i64(i64, i64, i64)