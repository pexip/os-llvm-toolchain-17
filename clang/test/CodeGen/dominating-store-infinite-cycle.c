// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --version 2
// RUN: %clang_cc1 -triple x86_64-unknown-linux-gnu -S -emit-llvm %s -o - | FileCheck %s

// Test for PR62830 where there are 2 infinite cycles using goto. Make sure
// clang codegen doesn't hang.
int a;

// CHECK-LABEL: define dso_local i32 @main
// CHECK-SAME: () #[[ATTR0:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[RETVAL:%.*]] = alloca i32, align 4
// CHECK-NEXT:    store i32 0, ptr [[RETVAL]], align 4
// CHECK-NEXT:    br label [[L1:%.*]]
// CHECK:       L1:
// CHECK-NEXT:    br label [[L1]]
// CHECK:       L2:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr @a, align 4
// CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[TMP0]], 0
// CHECK-NEXT:    br i1 [[TOBOOL]], label [[IF_END:%.*]], label [[IF_THEN:%.*]]
// CHECK:       if.then:
// CHECK-NEXT:    br label [[L2:%.*]]
// CHECK:       if.end:
// CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[RETVAL]], align 4
// CHECK-NEXT:    ret i32 [[TMP1]]
//
int main() {
L1:
  goto L1;

L2:
  if (!a)
    goto L2;
}