; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX

; fold (mul undef, x) -> 0
define <4 x i32> @combine_vec_mul_undef0(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_undef0:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_undef0:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = mul <4 x i32> undef, %x
  ret <4 x i32> %1
}

; fold (mul x, undef) -> 0
define <4 x i32> @combine_vec_mul_undef1(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_undef1:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_undef1:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, undef
  ret <4 x i32> %1
}

; fold (mul x, 0) -> 0
define <4 x i32> @combine_vec_mul_zero(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_zero:
; SSE:       # BB#0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_zero:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, zeroinitializer
  ret <4 x i32> %1
}

; fold (mul x, 0) -> 0
define <4 x i32> @combine_vec_mul_one(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_one:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_one:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %1
}

; fold (mul x, -1) -> 0-x
define <4 x i32> @combine_vec_mul_negone(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_negone:
; SSE:       # BB#0:
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_negone:
; AVX:       # BB#0:
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %1
}

; fold (mul x, (1 << c)) -> x << c
define <4 x i32> @combine_vec_mul_pow2a(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_pow2a:
; SSE:       # BB#0:
; SSE-NEXT:    paddd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_pow2a:
; AVX:       # BB#0:
; AVX-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_mul_pow2b(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_pow2b:
; SSE:       # BB#0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_pow2b:
; AVX:       # BB#0:
; AVX-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 1, i32 2, i32 4, i32 16>
  ret <4 x i32> %1
}

; fold (mul x, -(1 << c)) -> -(x << c) or (-x) << c
define <4 x i32> @combine_vec_mul_negpow2a(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_negpow2a:
; SSE:       # BB#0:
; SSE-NEXT:    paddd %xmm0, %xmm0
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_negpow2a:
; AVX:       # BB#0:
; AVX-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 -2, i32 -2, i32 -2, i32 -2>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_mul_negpow2b(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_negpow2b:
; SSE:       # BB#0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_negpow2b:
; AVX:       # BB#0:
; AVX-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 -1, i32 -2, i32 -4, i32 -16>
  ret <4 x i32> %1
}

; (mul (shl X, c1), c2) -> (mul X, c2 << c1)
define <4 x i32> @combine_vec_mul_shl_const(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_shl_const:
; SSE:       # BB#0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_const:
; AVX:       # BB#0:
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %1, <i32 1, i32 3, i32 5, i32 7>
  ret <4 x i32> %2
}

; (mul (shl X, C), Y) -> (shl (mul X, Y), C) when the shift has one use.
define <4 x i32> @combine_vec_mul_shl_oneuse0(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_mul_shl_oneuse0:
; SSE:       # BB#0:
; SSE-NEXT:    pmulld %xmm1, %xmm0
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_oneuse0:
; AVX:       # BB#0:
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %1, %y
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_mul_shl_oneuse1(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_mul_shl_oneuse1:
; SSE:       # BB#0:
; SSE-NEXT:    pmulld %xmm1, %xmm0
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_oneuse1:
; AVX:       # BB#0:
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpmulld %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %y, %1
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_mul_shl_multiuse0(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_mul_shl_multiuse0:
; SSE:       # BB#0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    pmulld %xmm0, %xmm1
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_multiuse0:
; AVX:       # BB#0:
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpmulld %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %1, %y
  %3 = add <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @combine_vec_mul_shl_multiuse1(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_mul_shl_multiuse1:
; SSE:       # BB#0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    pmulld %xmm0, %xmm1
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_multiuse1:
; AVX:       # BB#0:
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpmulld %xmm0, %xmm1, %xmm1
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %y, %1
  %3 = add <4 x i32> %1, %2
  ret <4 x i32> %3
}

; fold (mul (add x, c1), c2) -> (add (mul x, c2), c1*c2)

define <4 x i32> @combine_vec_mul_add(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_add:
; SSE:       # BB#0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_add:
; AVX:       # BB#0:
; AVX-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpaddd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = add <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %1, <i32 4, i32 6, i32 2, i32 0>
  ret <4 x i32> %2
}