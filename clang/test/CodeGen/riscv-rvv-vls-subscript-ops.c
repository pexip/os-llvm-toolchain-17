// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple riscv64-none-linux-gnu -target-feature +zve64d \
// RUN: -target-feature +f -target-feature +d -disable-O0-optnone \
// RUN: -mvscale-min=4 -mvscale-max=4 -emit-llvm -o - %s | \
// RUN: opt -S -passes=sroa | FileCheck %s

// REQUIRES: riscv-registered-target

#include <stddef.h>
#include <stdint.h>

typedef __rvv_int8m1_t vint8m1_t;
typedef __rvv_uint8m1_t vuint8m1_t;
typedef __rvv_int16m1_t vint16m1_t;
typedef __rvv_uint16m1_t vuint16m1_t;
typedef __rvv_int32m1_t vint32m1_t;
typedef __rvv_uint32m1_t vuint32m1_t;
typedef __rvv_int64m1_t vint64m1_t;
typedef __rvv_uint64m1_t vuint64m1_t;
typedef __rvv_float32m1_t vfloat32m1_t;
typedef __rvv_float64m1_t vfloat64m1_t;

typedef vint8m1_t fixed_int8m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vint16m1_t fixed_int16m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vint32m1_t fixed_int32m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vint64m1_t fixed_int64m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));

typedef vuint8m1_t fixed_uint8m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vuint16m1_t fixed_uint16m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vuint32m1_t fixed_uint32m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vuint64m1_t fixed_uint64m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));

typedef vfloat32m1_t fixed_float32m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vfloat64m1_t fixed_float64m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));

// CHECK-LABEL: @subscript_int8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <32 x i8> @llvm.vector.extract.v32i8.nxv8i8(<vscale x 8 x i8> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <32 x i8> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret i8 [[VECEXT]]
//
int8_t subscript_int8(fixed_int8m1_t a, size_t b) {
  return a[b];
}

// CHECK-LABEL: @subscript_uint8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <32 x i8> @llvm.vector.extract.v32i8.nxv8i8(<vscale x 8 x i8> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <32 x i8> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret i8 [[VECEXT]]
//
uint8_t subscript_uint8(fixed_uint8m1_t a, size_t b) {
  return a[b];
}

// CHECK-LABEL: @subscript_int16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <16 x i16> @llvm.vector.extract.v16i16.nxv4i16(<vscale x 4 x i16> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <16 x i16> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret i16 [[VECEXT]]
//
int16_t subscript_int16(fixed_int16m1_t a, size_t b) {
  return a[b];
}

// CHECK-LABEL: @subscript_uint16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <16 x i16> @llvm.vector.extract.v16i16.nxv4i16(<vscale x 4 x i16> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <16 x i16> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret i16 [[VECEXT]]
//
uint16_t subscript_uint16(fixed_uint16m1_t a, size_t b) {
  return a[b];
}

// CHECK-LABEL: @subscript_int32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <8 x i32> @llvm.vector.extract.v8i32.nxv2i32(<vscale x 2 x i32> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <8 x i32> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret i32 [[VECEXT]]
//
int32_t subscript_int32(fixed_int32m1_t a, size_t b) {
  return a[b];
}

// CHECK-LABEL: @subscript_uint32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <8 x i32> @llvm.vector.extract.v8i32.nxv2i32(<vscale x 2 x i32> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <8 x i32> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret i32 [[VECEXT]]
//
uint32_t subscript_uint32(fixed_uint32m1_t a, size_t b) {
  return a[b];
}

// CHECK-LABEL: @subscript_int64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <4 x i64> @llvm.vector.extract.v4i64.nxv1i64(<vscale x 1 x i64> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <4 x i64> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret i64 [[VECEXT]]
//
int64_t subscript_int64(fixed_int64m1_t a, size_t b) {
  return a[b];
}

// CHECK-LABEL: @subscript_uint64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <4 x i64> @llvm.vector.extract.v4i64.nxv1i64(<vscale x 1 x i64> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <4 x i64> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret i64 [[VECEXT]]
//
uint64_t subscript_uint64(fixed_uint64m1_t a, size_t b) {
  return a[b];
}

// CHECK-LABEL: @subscript_float32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <8 x float> @llvm.vector.extract.v8f32.nxv2f32(<vscale x 2 x float> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <8 x float> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret float [[VECEXT]]
//
float subscript_float32(fixed_float32m1_t a, size_t b) {
  return a[b];
}

// CHECK-LABEL: @subscript_float64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A:%.*]] = call <4 x double> @llvm.vector.extract.v4f64.nxv1f64(<vscale x 1 x double> [[A_COERCE:%.*]], i64 0)
// CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <4 x double> [[A]], i64 [[B:%.*]]
// CHECK-NEXT:    ret double [[VECEXT]]
//
double subscript_float64(fixed_float64m1_t a, size_t b) {
  return a[b];
}