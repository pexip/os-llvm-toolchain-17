; RUN: opt -passes=objc-arc -S < %s | FileCheck %s

; Generated by compiling:
;
; id baz(ptr X) { return (__bridge_transfer id)X; }
; 
; void foo(id X) {
; ptr Y = 0;
; if (X)
;   Y = (__bridge_retained ptr)X;
; baz(Y);
; }
;
; clang -x objective-c -mllvm -enable-objc-arc-opts=0 -fobjc-arc -S -emit-llvm test.m
;
; And then hand-reduced further. 

declare ptr @llvm.objc.autoreleaseReturnValue(ptr)
declare ptr @llvm.objc.unsafeClaimAutoreleasedReturnValue(ptr)
declare ptr @llvm.objc.retain(ptr)
declare void @llvm.objc.release(ptr)

define void @foo(ptr %X) {
entry:
  %0 = tail call ptr @llvm.objc.retain(ptr %X) 
  %tobool = icmp eq ptr %0, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %1 = tail call ptr @llvm.objc.retain(ptr nonnull %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %Y.0 = phi ptr [ %1, %if.then ], [ null, %entry ]
  %2 = tail call ptr @llvm.objc.autoreleaseReturnValue(ptr %Y.0)
  %3 = tail call ptr @llvm.objc.unsafeClaimAutoreleasedReturnValue(ptr %2)
  tail call void @llvm.objc.release(ptr %0) 
  ret void
}

; CHECK: if.then
; CHECK: tail call ptr @llvm.objc.retain
; CHECK: %Y.0 = phi
; CHECK-NEXT: tail call void @llvm.objc.release
; CHECK-NEXT: tail call void @llvm.objc.release
