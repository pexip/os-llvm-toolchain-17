; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer,dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.7.0"

@.str = private unnamed_addr constant [6 x i8] c"bingo\00", align 1

define void @reduce_compare(ptr nocapture %A, i32 %n) {
; CHECK-LABEL: @reduce_compare(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[N:%.*]] to double
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x double> poison, double [[CONV]], i32 0
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x double> [[TMP0]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = shl nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, ptr [[A:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = load <2 x double>, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[TMP4:%.*]] = fmul <2 x double> [[SHUFFLE]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = fmul <2 x double> [[TMP4]], <double 7.000000e+00, double 4.000000e+00>
; CHECK-NEXT:    [[TMP6:%.*]] = fadd <2 x double> [[TMP5]], <double 5.000000e+00, double 9.000000e+00>
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x double> [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x double> [[TMP6]], i32 1
; CHECK-NEXT:    [[CMP11:%.*]] = fcmp ogt double [[TMP7]], [[TMP8]]
; CHECK-NEXT:    br i1 [[CMP11]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; CHECK:       if.then:
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 (ptr, ...) @printf(ptr @.str)
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[LFTR_WIDEIV:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[LFTR_WIDEIV]], 100
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %conv = sitofp i32 %n to double
  br label %for.body

for.body:                                         ; preds = %for.inc, %entry
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
  %0 = shl nsw i64 %indvars.iv, 1
  %arrayidx = getelementptr inbounds double, ptr %A, i64 %0
  %1 = load double, ptr %arrayidx, align 8
  %mul1 = fmul double %conv, %1
  %mul2 = fmul double %mul1, 7.000000e+00
  %add = fadd double %mul2, 5.000000e+00
  %2 = or i64 %0, 1
  %arrayidx6 = getelementptr inbounds double, ptr %A, i64 %2
  %3 = load double, ptr %arrayidx6, align 8
  %mul8 = fmul double %conv, %3
  %mul9 = fmul double %mul8, 4.000000e+00
  %add10 = fadd double %mul9, 9.000000e+00
  %cmp11 = fcmp ogt double %add, %add10
  br i1 %cmp11, label %if.then, label %for.inc

if.then:                                          ; preds = %for.body
  %call = tail call i32 (ptr, ...) @printf(ptr @.str)
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then
  %indvars.iv.next = add i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp eq i32 %lftr.wideiv, 100
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.inc
  ret void
}

declare i32 @printf(ptr nocapture, ...)

; PR41312 - the order of the reduction ops should not prevent forming a reduction.
; The 'wrong' member of the reduction requires a greater cost if grouped with the
; other candidates in the reduction because it does not have matching predicate
; and/or constant operand.

define float @merge_anyof_v4f32_wrong_first(<4 x float> %x) {
; CHECK-LABEL: @merge_anyof_v4f32_wrong_first(
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x float> [[X:%.*]], i32 3
; CHECK-NEXT:    [[CMP3WRONG:%.*]] = fcmp olt float [[TMP1]], 4.200000e+01
; CHECK-NEXT:    [[TMP2:%.*]] = fcmp ogt <4 x float> [[X]], <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>
; CHECK-NEXT:    [[TMP3:%.*]] = call i1 @llvm.vector.reduce.or.v4i1(<4 x i1> [[TMP2]])
; CHECK-NEXT:    [[OP_RDX:%.*]] = or i1 [[TMP3]], [[CMP3WRONG]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[OP_RDX]], float -1.000000e+00, float 1.000000e+00
; CHECK-NEXT:    ret float [[R]]
;
  %x0 = extractelement <4 x float> %x, i32 0
  %x1 = extractelement <4 x float> %x, i32 1
  %x2 = extractelement <4 x float> %x, i32 2
  %x3 = extractelement <4 x float> %x, i32 3
  %cmp3wrong = fcmp olt float %x3, 42.0
  %cmp0 = fcmp ogt float %x0, 1.0
  %cmp1 = fcmp ogt float %x1, 1.0
  %cmp2 = fcmp ogt float %x2, 1.0
  %cmp3 = fcmp ogt float %x3, 1.0
  %or03 = or i1 %cmp0, %cmp3wrong
  %or031 = or i1 %or03, %cmp1
  %or0312 = or i1 %or031, %cmp2
  %or03123 = or i1 %or0312, %cmp3
  %r = select i1 %or03123, float -1.0, float 1.0
  ret float %r
}

define float @merge_anyof_v4f32_wrong_last(<4 x float> %x) {
; CHECK-LABEL: @merge_anyof_v4f32_wrong_last(
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x float> [[X:%.*]], i32 3
; CHECK-NEXT:    [[CMP3WRONG:%.*]] = fcmp olt float [[TMP1]], 4.200000e+01
; CHECK-NEXT:    [[TMP2:%.*]] = fcmp ogt <4 x float> [[X]], <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>
; CHECK-NEXT:    [[TMP3:%.*]] = call i1 @llvm.vector.reduce.or.v4i1(<4 x i1> [[TMP2]])
; CHECK-NEXT:    [[OP_RDX:%.*]] = or i1 [[TMP3]], [[CMP3WRONG]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[OP_RDX]], float -1.000000e+00, float 1.000000e+00
; CHECK-NEXT:    ret float [[R]]
;
  %x0 = extractelement <4 x float> %x, i32 0
  %x1 = extractelement <4 x float> %x, i32 1
  %x2 = extractelement <4 x float> %x, i32 2
  %x3 = extractelement <4 x float> %x, i32 3
  %cmp3wrong = fcmp olt float %x3, 42.0
  %cmp0 = fcmp ogt float %x0, 1.0
  %cmp1 = fcmp ogt float %x1, 1.0
  %cmp2 = fcmp ogt float %x2, 1.0
  %cmp3 = fcmp ogt float %x3, 1.0
  %or03 = or i1 %cmp0, %cmp3
  %or031 = or i1 %or03, %cmp1
  %or0312 = or i1 %or031, %cmp2
  %or03123 = or i1 %or0312, %cmp3wrong
  %r = select i1 %or03123, float -1.0, float 1.0
  ret float %r
}

define i32 @merge_anyof_v4i32_wrong_middle(<4 x i32> %x) {
; CHECK-LABEL: @merge_anyof_v4i32_wrong_middle(
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x i32> [[X:%.*]], i32 3
; CHECK-NEXT:    [[CMP3WRONG:%.*]] = icmp slt i32 [[TMP1]], 42
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt <4 x i32> [[X]], <i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = call i1 @llvm.vector.reduce.or.v4i1(<4 x i1> [[TMP2]])
; CHECK-NEXT:    [[OP_RDX:%.*]] = or i1 [[TMP3]], [[CMP3WRONG]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[OP_RDX]], i32 -1, i32 1
; CHECK-NEXT:    ret i32 [[R]]
;
  %x0 = extractelement <4 x i32> %x, i32 0
  %x1 = extractelement <4 x i32> %x, i32 1
  %x2 = extractelement <4 x i32> %x, i32 2
  %x3 = extractelement <4 x i32> %x, i32 3
  %cmp3wrong = icmp slt i32 %x3, 42
  %cmp0 = icmp sgt i32 %x0, 1
  %cmp1 = icmp sgt i32 %x1, 1
  %cmp2 = icmp sgt i32 %x2, 1
  %cmp3 = icmp sgt i32 %x3, 1
  %or03 = or i1 %cmp0, %cmp3
  %or033 = or i1 %or03, %cmp3wrong
  %or0332 = or i1 %or033, %cmp2
  %or03321 = or i1 %or0332, %cmp1
  %r = select i1 %or03321, i32 -1, i32 1
  ret i32 %r
}

; Operand/predicate swapping allows forming a reduction, but the
; ideal reduction groups all of the original 'sgt' ops together.

define i32 @merge_anyof_v4i32_wrong_middle_better_rdx(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @merge_anyof_v4i32_wrong_middle_better_rdx(
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x i32> [[Y:%.*]], i32 3
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x i32> [[X:%.*]], i32 3
; CHECK-NEXT:    [[CMP3WRONG:%.*]] = icmp slt i32 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp sgt <4 x i32> [[X]], [[Y]]
; CHECK-NEXT:    [[TMP4:%.*]] = call i1 @llvm.vector.reduce.or.v4i1(<4 x i1> [[TMP3]])
; CHECK-NEXT:    [[OP_RDX:%.*]] = or i1 [[TMP4]], [[CMP3WRONG]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[OP_RDX]], i32 -1, i32 1
; CHECK-NEXT:    ret i32 [[R]]
;
  %x0 = extractelement <4 x i32> %x, i32 0
  %x1 = extractelement <4 x i32> %x, i32 1
  %x2 = extractelement <4 x i32> %x, i32 2
  %x3 = extractelement <4 x i32> %x, i32 3
  %y0 = extractelement <4 x i32> %y, i32 0
  %y1 = extractelement <4 x i32> %y, i32 1
  %y2 = extractelement <4 x i32> %y, i32 2
  %y3 = extractelement <4 x i32> %y, i32 3
  %cmp3wrong = icmp slt i32 %x3, %y3
  %cmp0 = icmp sgt i32 %x0, %y0
  %cmp1 = icmp sgt i32 %x1, %y1
  %cmp2 = icmp sgt i32 %x2, %y2
  %cmp3 = icmp sgt i32 %x3, %y3
  %or03 = or i1 %cmp0, %cmp3
  %or033 = or i1 %or03, %cmp3wrong
  %or0332 = or i1 %or033, %cmp2
  %or03321 = or i1 %or0332, %cmp1
  %r = select i1 %or03321, i32 -1, i32 1
  ret i32 %r
}