; ModuleID = 'temp.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ArrayInfo.0 = type { i32, double, [200 x i32], float*, i32 }

@.str.2 = private unnamed_addr constant [5 x i8] c" %f \00", align 1
@.str.3 = private unnamed_addr constant [14 x i8] c"\0A Sum is %lf\0A\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@str.1 = private unnamed_addr constant [10 x i8] c"Array is \00", align 1
@arrayInfo.2 = local_unnamed_addr global %struct.ArrayInfo.0 zeroinitializer

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0)
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #0

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #1

; Function Attrs: alwaysinline nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #2 {
vector.ph:
  %0 = alloca i32, align 4
  %1 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i64 0, i64 0), i32* noundef nonnull %0)
  %2 = load i32, i32* %0, align 4
  store i32 %2, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 16
  %3 = sext i32 %2 to i64
  %4 = shl nsw i64 %3, 2
  %5 = call noalias i8* @malloc(i64 noundef %4) #4
  store i8* %5, i8** bitcast (float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3) to i8**), align 16
  store <4 x i32> <i32 10, i32 11, i32 12, i32 13>, <4 x i32>* bitcast (i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 0) to <4 x i32>*), align 16
  store <4 x i32> <i32 14, i32 15, i32 16, i32 17>, <4 x i32>* bitcast (i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 4) to <4 x i32>*), align 16
  br label %vector.body.1

vector.body.1:                                    ; preds = %vector.body.1, %vector.ph
  %index.next17 = phi i64 [ 8, %vector.ph ], [ %index.next.137, %vector.body.1 ]
  %vec.ind16 = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %vector.ph ], [ %vec.ind.next.1.1, %vector.body.1 ]
  %index15 = phi i64 [ 0, %vector.ph ], [ %index.next.1.1, %vector.body.1 ]
  %6 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %index.next17
  %7 = add <4 x i32> %vec.ind16, <i32 18, i32 18, i32 18, i32 18>
  %8 = add <4 x i32> %vec.ind16, <i32 22, i32 22, i32 22, i32 22>
  %9 = bitcast i32* %6 to <4 x i32>*
  store <4 x i32> %7, <4 x i32>* %9, align 16
  %10 = getelementptr inbounds i32, i32* %6, i64 4
  %11 = bitcast i32* %10 to <4 x i32>*
  store <4 x i32> %8, <4 x i32>* %11, align 16
  %index.next.1 = or i64 %index15, 16
  %12 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %index.next.1
  %13 = add <4 x i32> %vec.ind16, <i32 26, i32 26, i32 26, i32 26>
  %14 = add <4 x i32> %vec.ind16, <i32 30, i32 30, i32 30, i32 30>
  %15 = bitcast i32* %12 to <4 x i32>*
  store <4 x i32> %13, <4 x i32>* %15, align 16
  %16 = getelementptr inbounds i32, i32* %12, i64 4
  %17 = bitcast i32* %16 to <4 x i32>*
  store <4 x i32> %14, <4 x i32>* %17, align 16
  %index.next = or i64 %index15, 24
  %18 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %index.next
  %19 = add <4 x i32> %vec.ind16, <i32 34, i32 34, i32 34, i32 34>
  %20 = add <4 x i32> %vec.ind16, <i32 38, i32 38, i32 38, i32 38>
  %21 = bitcast i32* %18 to <4 x i32>*
  store <4 x i32> %19, <4 x i32>* %21, align 16
  %22 = getelementptr inbounds i32, i32* %18, i64 4
  %23 = bitcast i32* %22 to <4 x i32>*
  store <4 x i32> %20, <4 x i32>* %23, align 16
  %index.next.1.1 = add nuw nsw i64 %index15, 32
  %vec.ind.next.1.1 = add <4 x i32> %vec.ind16, <i32 32, i32 32, i32 32, i32 32>
  %24 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %index.next.1.1
  %25 = add <4 x i32> %vec.ind16, <i32 42, i32 42, i32 42, i32 42>
  %26 = add <4 x i32> %vec.ind16, <i32 46, i32 46, i32 46, i32 46>
  %27 = bitcast i32* %24 to <4 x i32>*
  store <4 x i32> %25, <4 x i32>* %27, align 16
  %28 = getelementptr inbounds i32, i32* %24, i64 4
  %29 = bitcast i32* %28 to <4 x i32>*
  store <4 x i32> %26, <4 x i32>* %29, align 16
  %index.next.137 = or i64 %index.next.1.1, 8
  %30 = icmp eq i64 %index.next.137, 200
  br i1 %30, label %init.exit, label %vector.body.1, !llvm.loop !6

init.exit:                                        ; preds = %vector.body.1
  store i32 99, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 4), align 8
  store double 0.000000e+00, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %.not = icmp eq i32 %2, 0
  br i1 %.not, label %populate.exit, label %.lr.ph91.preheader

.preheader86:                                     ; preds = %._crit_edge92
  %31 = zext i32 %52 to i64
  %.not108 = icmp eq i32 %52, 0
  br i1 %.not108, label %populate.exit, label %.lr.ph97

.lr.ph97:                                         ; preds = %.preheader86
  %32 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 16
  %.pre = load double, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %33 = add nsw i64 %31, -1
  %xtraiter = and i64 %31, 3
  %34 = icmp ult i64 %33, 3
  br i1 %34, label %._crit_edge98.unr-lcssa, label %.lr.ph97.new

.lr.ph97.new:                                     ; preds = %.lr.ph97
  %unroll_iter = and i64 %31, 4294967292
  br label %59

.lr.ph91.preheader:                               ; preds = %init.exit, %._crit_edge92
  %.094 = phi float [ %36, %._crit_edge92 ], [ 9.900000e+01, %init.exit ]
  %.07593 = phi i32 [ %57, %._crit_edge92 ], [ 0, %init.exit ]
  %35 = uitofp i32 %.07593 to float
  %36 = fadd float %.094, %35
  br label %.lr.ph

.lr.ph:                                           ; preds = %._crit_edge, %.lr.ph91.preheader
  %.07789 = phi i32 [ %55, %._crit_edge ], [ 0, %.lr.ph91.preheader ]
  %37 = urem i32 %.07789, 200
  %38 = zext i32 %37 to i64
  %39 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %38
  %40 = load i32, i32* %39, align 4
  %41 = add i32 %40, %.07789
  %42 = uitofp i32 %41 to float
  %43 = add i32 %.07789, %.07593
  br label %44

44:                                               ; preds = %44, %.lr.ph
  %indvars.iv116 = phi i64 [ 0, %.lr.ph ], [ %indvars.iv.next117, %44 ]
  %45 = trunc i64 %indvars.iv116 to i32
  %46 = add i32 %43, %45
  %47 = uitofp i32 %46 to float
  %48 = fadd float %36, %47
  %49 = fadd float %48, %42
  %50 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 16
  %51 = getelementptr inbounds float, float* %50, i64 %indvars.iv116
  store float %49, float* %51, align 4
  %indvars.iv.next117 = add nuw nsw i64 %indvars.iv116, 1
  %52 = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 16
  %53 = zext i32 %52 to i64
  %54 = icmp ult i64 %indvars.iv.next117, %53
  br i1 %54, label %44, label %._crit_edge, !llvm.loop !9

._crit_edge:                                      ; preds = %44
  %55 = add nuw i32 %.07789, 1
  %56 = icmp ult i32 %55, %52
  br i1 %56, label %.lr.ph, label %._crit_edge92, !llvm.loop !10

._crit_edge92:                                    ; preds = %._crit_edge
  %57 = add nuw i32 %.07593, 1
  %58 = icmp ult i32 %57, %52
  br i1 %58, label %.lr.ph91.preheader, label %.preheader86, !llvm.loop !11

59:                                               ; preds = %59, %.lr.ph97.new
  %60 = phi double [ %.pre, %.lr.ph97.new ], [ %76, %59 ]
  %indvars.iv119 = phi i64 [ 0, %.lr.ph97.new ], [ %indvars.iv.next120.3, %59 ]
  %61 = getelementptr inbounds float, float* %32, i64 %indvars.iv119
  %62 = load float, float* %61, align 4
  %63 = fpext float %62 to double
  %64 = fadd double %60, %63
  store double %64, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120 = or i64 %indvars.iv119, 1
  %65 = getelementptr inbounds float, float* %32, i64 %indvars.iv.next120
  %66 = load float, float* %65, align 4
  %67 = fpext float %66 to double
  %68 = fadd double %64, %67
  store double %68, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120.1 = or i64 %indvars.iv119, 2
  %69 = getelementptr inbounds float, float* %32, i64 %indvars.iv.next120.1
  %70 = load float, float* %69, align 4
  %71 = fpext float %70 to double
  %72 = fadd double %68, %71
  store double %72, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120.2 = or i64 %indvars.iv119, 3
  %73 = getelementptr inbounds float, float* %32, i64 %indvars.iv.next120.2
  %74 = load float, float* %73, align 4
  %75 = fpext float %74 to double
  %76 = fadd double %72, %75
  store double %76, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120.3 = add nuw nsw i64 %indvars.iv119, 4
  %niter.ncmp.3 = icmp eq i64 %indvars.iv.next120.3, %unroll_iter
  br i1 %niter.ncmp.3, label %._crit_edge98.unr-lcssa, label %59, !llvm.loop !12

._crit_edge98.unr-lcssa:                          ; preds = %59, %.lr.ph97
  %.lcssa147.ph = phi double [ undef, %.lr.ph97 ], [ %76, %59 ]
  %.unr = phi double [ %.pre, %.lr.ph97 ], [ %76, %59 ]
  %indvars.iv119.unr = phi i64 [ 0, %.lr.ph97 ], [ %unroll_iter, %59 ]
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %._crit_edge98, label %.epil.preheader

.epil.preheader:                                  ; preds = %._crit_edge98.unr-lcssa, %.epil.preheader
  %77 = phi double [ %81, %.epil.preheader ], [ %.unr, %._crit_edge98.unr-lcssa ]
  %indvars.iv119.epil = phi i64 [ %indvars.iv.next120.epil, %.epil.preheader ], [ %indvars.iv119.unr, %._crit_edge98.unr-lcssa ]
  %epil.iter = phi i64 [ %epil.iter.next, %.epil.preheader ], [ 0, %._crit_edge98.unr-lcssa ]
  %78 = getelementptr inbounds float, float* %32, i64 %indvars.iv119.epil
  %79 = load float, float* %78, align 4
  %80 = fpext float %79 to double
  %81 = fadd double %77, %80
  store double %81, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120.epil = add nuw nsw i64 %indvars.iv119.epil, 1
  %epil.iter.next = add nuw nsw i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %epil.iter.next, %xtraiter
  br i1 %epil.iter.cmp.not, label %._crit_edge98, label %.epil.preheader, !llvm.loop !13

._crit_edge98:                                    ; preds = %.epil.preheader, %._crit_edge98.unr-lcssa
  %.lcssa147 = phi double [ %.lcssa147.ph, %._crit_edge98.unr-lcssa ], [ %81, %.epil.preheader ]
  %82 = fcmp olt double %.lcssa147, 5.000000e+03
  br i1 %82, label %.lr.ph100.preheader, label %.loopexit

.lr.ph100.preheader:                              ; preds = %._crit_edge98, %._crit_edge101
  %.082102 = phi i32 [ %99, %._crit_edge101 ], [ 0, %._crit_edge98 ]
  br label %.lr.ph100

.lr.ph100:                                        ; preds = %.lr.ph100, %.lr.ph100.preheader
  %indvars.iv123 = phi i64 [ 0, %.lr.ph100.preheader ], [ %indvars.iv.next124, %.lr.ph100 ]
  %83 = load double, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %84 = fcmp olt double %83, 2.500000e+03
  %85 = trunc i64 %indvars.iv123 to i32
  %86 = add i32 %.082102, %85
  %87 = urem i32 %85, 200
  %88 = zext i32 %87 to i64
  %89 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %88
  %90 = load i32, i32* %89, align 4
  %91 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 16
  %92 = getelementptr inbounds float, float* %91, i64 %indvars.iv123
  %. = select i1 %84, i32 2, i32 1
  %93 = xor i32 %., %90
  %94 = add i32 %86, %93
  %95 = uitofp i32 %94 to float
  store float %95, float* %92, align 4
  %indvars.iv.next124 = add nuw nsw i64 %indvars.iv123, 1
  %96 = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 16
  %97 = zext i32 %96 to i64
  %98 = icmp ult i64 %indvars.iv.next124, %97
  br i1 %98, label %.lr.ph100, label %._crit_edge101, !llvm.loop !15

._crit_edge101:                                   ; preds = %.lr.ph100
  %99 = add nuw i32 %.082102, 1
  %100 = icmp ult i32 %99, %96
  br i1 %100, label %.lr.ph100.preheader, label %.loopexit, !llvm.loop !16

.loopexit:                                        ; preds = %._crit_edge101, %._crit_edge98
  %.ph = phi i32 [ %52, %._crit_edge98 ], [ %96, %._crit_edge101 ]
  %.pr = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 4), align 8
  %101 = icmp sgt i32 %.pr, 99
  %.not110 = icmp eq i32 %.ph, 0
  %or.cond143 = select i1 %101, i1 true, i1 %.not110
  br i1 %or.cond143, label %populate.exit, label %.lr.ph104

.lr.ph104:                                        ; preds = %.loopexit
  %102 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 16
  %wide.trip.count129 = zext i32 %.ph to i64
  %.pre135 = load double, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %103 = add nsw i64 %wide.trip.count129, -1
  %xtraiter151 = and i64 %wide.trip.count129, 3
  %104 = icmp ult i64 %103, 3
  br i1 %104, label %populate.exit.loopexit.unr-lcssa, label %.lr.ph104.new

.lr.ph104.new:                                    ; preds = %.lr.ph104
  %unroll_iter155 = and i64 %wide.trip.count129, 4294967292
  br label %105

105:                                              ; preds = %105, %.lr.ph104.new
  %106 = phi double [ %.pre135, %.lr.ph104.new ], [ %122, %105 ]
  %indvars.iv126 = phi i64 [ 0, %.lr.ph104.new ], [ %indvars.iv.next127.3, %105 ]
  %107 = getelementptr inbounds float, float* %102, i64 %indvars.iv126
  %108 = load float, float* %107, align 4
  %109 = fpext float %108 to double
  %110 = fadd double %106, %109
  store double %110, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127 = or i64 %indvars.iv126, 1
  %111 = getelementptr inbounds float, float* %102, i64 %indvars.iv.next127
  %112 = load float, float* %111, align 4
  %113 = fpext float %112 to double
  %114 = fadd double %110, %113
  store double %114, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127.1 = or i64 %indvars.iv126, 2
  %115 = getelementptr inbounds float, float* %102, i64 %indvars.iv.next127.1
  %116 = load float, float* %115, align 4
  %117 = fpext float %116 to double
  %118 = fadd double %114, %117
  store double %118, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127.2 = or i64 %indvars.iv126, 3
  %119 = getelementptr inbounds float, float* %102, i64 %indvars.iv.next127.2
  %120 = load float, float* %119, align 4
  %121 = fpext float %120 to double
  %122 = fadd double %118, %121
  store double %122, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127.3 = add nuw nsw i64 %indvars.iv126, 4
  %niter156.ncmp.3 = icmp eq i64 %indvars.iv.next127.3, %unroll_iter155
  br i1 %niter156.ncmp.3, label %populate.exit.loopexit.unr-lcssa, label %105, !llvm.loop !17

populate.exit.loopexit.unr-lcssa:                 ; preds = %105, %.lr.ph104
  %.unr153 = phi double [ %.pre135, %.lr.ph104 ], [ %122, %105 ]
  %indvars.iv126.unr = phi i64 [ 0, %.lr.ph104 ], [ %unroll_iter155, %105 ]
  %lcmp.mod154.not = icmp eq i64 %xtraiter151, 0
  br i1 %lcmp.mod154.not, label %populate.exit, label %.epil.preheader150

.epil.preheader150:                               ; preds = %populate.exit.loopexit.unr-lcssa, %.epil.preheader150
  %123 = phi double [ %127, %.epil.preheader150 ], [ %.unr153, %populate.exit.loopexit.unr-lcssa ]
  %indvars.iv126.epil = phi i64 [ %indvars.iv.next127.epil, %.epil.preheader150 ], [ %indvars.iv126.unr, %populate.exit.loopexit.unr-lcssa ]
  %epil.iter152 = phi i64 [ %epil.iter152.next, %.epil.preheader150 ], [ 0, %populate.exit.loopexit.unr-lcssa ]
  %124 = getelementptr inbounds float, float* %102, i64 %indvars.iv126.epil
  %125 = load float, float* %124, align 4
  %126 = fpext float %125 to double
  %127 = fadd double %123, %126
  store double %127, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127.epil = add nuw nsw i64 %indvars.iv126.epil, 1
  %epil.iter152.next = add nuw nsw i64 %epil.iter152, 1
  %epil.iter152.cmp.not = icmp eq i64 %epil.iter152.next, %xtraiter151
  br i1 %epil.iter152.cmp.not, label %populate.exit, label %.epil.preheader150, !llvm.loop !18

populate.exit:                                    ; preds = %.epil.preheader150, %.preheader86, %populate.exit.loopexit.unr-lcssa, %.loopexit, %init.exit
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([10 x i8], [10 x i8]* @str.1, i64 0, i64 0))
  %128 = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 16
  %.not109 = icmp eq i32 %128, 0
  br i1 %.not109, label %print.exit, label %.lr.ph106

.lr.ph106:                                        ; preds = %populate.exit, %.lr.ph106
  %indvars.iv131 = phi i64 [ %indvars.iv.next132, %.lr.ph106 ], [ 0, %populate.exit ]
  %129 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 16
  %130 = getelementptr inbounds float, float* %129, i64 %indvars.iv131
  %131 = load float, float* %130, align 4
  %132 = fpext float %131 to double
  %133 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i64 0, i64 0), double noundef %132) #4
  %indvars.iv.next132 = add nuw nsw i64 %indvars.iv131, 1
  %134 = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 16
  %135 = zext i32 %134 to i64
  %136 = icmp ult i64 %indvars.iv.next132, %135
  br i1 %136, label %.lr.ph106, label %print.exit, !llvm.loop !19

print.exit:                                       ; preds = %.lr.ph106, %populate.exit
  %137 = load double, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %138 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([14 x i8], [14 x i8]* @.str.3, i64 0, i64 0), double noundef %137) #4
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @__isoc99_scanf(i8* nocapture noundef readonly, ...) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) local_unnamed_addr #3

attributes #0 = { inaccessiblememonly mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) "alloc-family"="malloc" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { alwaysinline nofree nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nounwind }
attributes #4 = { nounwind }

!llvm.ident = !{!0, !0}
!llvm.module.flags = !{!1, !2, !3, !4, !5}

!0 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.isvectorized", i32 1}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !14}
!14 = !{!"llvm.loop.unroll.disable"}
!15 = distinct !{!15, !7}
!16 = distinct !{!16, !7}
!17 = distinct !{!17, !7}
!18 = distinct !{!18, !14}
!19 = distinct !{!19, !7}
