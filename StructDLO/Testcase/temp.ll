; ModuleID = 'out.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ArrayInfo.0 = type { i32, double, [200 x i32], float*, i32 }

@.str = private unnamed_addr constant [15 x i8] c"LB %ld UB %ld\0A\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c" %f \00", align 1
@.str.3 = private unnamed_addr constant [14 x i8] c"\0A Sum is %lf\0A\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@str.1 = private unnamed_addr constant [10 x i8] c"Array is \00", align 1
@arrayInfo.2 = global %struct.ArrayInfo.0 zeroinitializer

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
  store i32 %2, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 8
  %3 = sext i32 %2 to i64
  %4 = shl nsw i64 %3, 2
  %5 = call noalias i8* @malloc(i64 noundef %4) #4
  store i8* %5, i8** bitcast (float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3) to i8**), align 8
  br label %vector.body

vector.body:                                      ; preds = %vector.body.1, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next.1, %vector.body.1 ]
  %vec.ind = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %vector.ph ], [ %vec.ind.next.1, %vector.body.1 ]
  %6 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %index
  %7 = add <4 x i32> %vec.ind, <i32 10, i32 10, i32 10, i32 10>
  %8 = add <4 x i32> %vec.ind, <i32 14, i32 14, i32 14, i32 14>
  %9 = bitcast i32* %6 to <4 x i32>*
  store <4 x i32> %7, <4 x i32>* %9, align 4
  %10 = getelementptr inbounds i32, i32* %6, i64 4
  %11 = bitcast i32* %10 to <4 x i32>*
  store <4 x i32> %8, <4 x i32>* %11, align 4
  %index.next = or i64 %index, 8
  %12 = icmp eq i64 %index.next, 200
  br i1 %12, label %init.exit, label %vector.body.1, !llvm.loop !6

vector.body.1:                                    ; preds = %vector.body
  %13 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %index.next
  %14 = add <4 x i32> %vec.ind, <i32 18, i32 18, i32 18, i32 18>
  %15 = add <4 x i32> %vec.ind, <i32 22, i32 22, i32 22, i32 22>
  %16 = bitcast i32* %13 to <4 x i32>*
  store <4 x i32> %14, <4 x i32>* %16, align 4
  %17 = getelementptr inbounds i32, i32* %13, i64 4
  %18 = bitcast i32* %17 to <4 x i32>*
  store <4 x i32> %15, <4 x i32>* %18, align 4
  %index.next.1 = add nuw nsw i64 %index, 16
  %vec.ind.next.1 = add <4 x i32> %vec.ind, <i32 16, i32 16, i32 16, i32 16>
  br label %vector.body

init.exit:                                        ; preds = %vector.body
  store i32 99, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 4), align 8
  store double 0.000000e+00, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %.not = icmp eq i32 %2, 0
  br i1 %.not, label %populate.exit, label %.lr.ph91.preheader

.preheader86:                                     ; preds = %._crit_edge92
  %.not108 = icmp eq i32 %39, 0
  br i1 %.not108, label %.loopexit, label %.lr.ph97

.lr.ph97:                                         ; preds = %.preheader86
  %19 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 8
  %wide.trip.count = zext i32 %39 to i64
  %.pre = load double, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %20 = add nsw i64 %wide.trip.count, -1
  %xtraiter = and i64 %wide.trip.count, 3
  %21 = icmp ult i64 %20, 3
  br i1 %21, label %._crit_edge98.unr-lcssa, label %.lr.ph97.new

.lr.ph97.new:                                     ; preds = %.lr.ph97
  %unroll_iter = and i64 %wide.trip.count, 4294967292
  br label %46

.lr.ph91.preheader:                               ; preds = %init.exit, %._crit_edge92
  %.094 = phi float [ %23, %._crit_edge92 ], [ 9.900000e+01, %init.exit ]
  %.07593 = phi i32 [ %44, %._crit_edge92 ], [ 0, %init.exit ]
  %22 = uitofp i32 %.07593 to float
  %23 = fadd float %.094, %22
  br label %.lr.ph

.lr.ph:                                           ; preds = %._crit_edge, %.lr.ph91.preheader
  %.07789 = phi i32 [ %42, %._crit_edge ], [ 0, %.lr.ph91.preheader ]
  %24 = urem i32 %.07789, 200
  %25 = zext i32 %24 to i64
  %26 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %25
  %27 = load i32, i32* %26, align 4
  %28 = add i32 %27, %.07789
  %29 = uitofp i32 %28 to float
  %30 = add i32 %.07789, %.07593
  br label %31

31:                                               ; preds = %.lr.ph, %31
  %indvars.iv116 = phi i64 [ 0, %.lr.ph ], [ %indvars.iv.next117, %31 ]
  %32 = trunc i64 %indvars.iv116 to i32
  %33 = add i32 %30, %32
  %34 = uitofp i32 %33 to float
  %35 = fadd float %23, %34
  %36 = fadd float %35, %29
  %37 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 8
  %38 = getelementptr inbounds float, float* %37, i64 %indvars.iv116
  store float %36, float* %38, align 4
  %indvars.iv.next117 = add nuw nsw i64 %indvars.iv116, 1
  %39 = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 8
  %40 = zext i32 %39 to i64
  %41 = icmp ult i64 %indvars.iv.next117, %40
  br i1 %41, label %31, label %._crit_edge, !llvm.loop !9

._crit_edge:                                      ; preds = %31
  %42 = add nuw i32 %.07789, 1
  %43 = icmp ult i32 %42, %39
  br i1 %43, label %.lr.ph, label %._crit_edge92, !llvm.loop !10

._crit_edge92:                                    ; preds = %._crit_edge
  %44 = add nuw i32 %.07593, 1
  %45 = icmp ult i32 %44, %39
  br i1 %45, label %.lr.ph91.preheader, label %.preheader86, !llvm.loop !11

46:                                               ; preds = %46, %.lr.ph97.new
  %47 = phi double [ %.pre, %.lr.ph97.new ], [ %63, %46 ]
  %indvars.iv119 = phi i64 [ 0, %.lr.ph97.new ], [ %indvars.iv.next120.3, %46 ]
  %niter = phi i64 [ 0, %.lr.ph97.new ], [ %niter.next.3, %46 ]
  %48 = getelementptr inbounds float, float* %19, i64 %indvars.iv119
  %49 = load float, float* %48, align 4
  %50 = fpext float %49 to double
  %51 = fadd double %47, %50
  store double %51, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120 = or i64 %indvars.iv119, 1
  %52 = getelementptr inbounds float, float* %19, i64 %indvars.iv.next120
  %53 = load float, float* %52, align 4
  %54 = fpext float %53 to double
  %55 = fadd double %51, %54
  store double %55, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120.1 = or i64 %indvars.iv119, 2
  %56 = getelementptr inbounds float, float* %19, i64 %indvars.iv.next120.1
  %57 = load float, float* %56, align 4
  %58 = fpext float %57 to double
  %59 = fadd double %55, %58
  store double %59, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120.2 = or i64 %indvars.iv119, 3
  %60 = getelementptr inbounds float, float* %19, i64 %indvars.iv.next120.2
  %61 = load float, float* %60, align 4
  %62 = fpext float %61 to double
  %63 = fadd double %59, %62
  store double %63, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120.3 = add nuw nsw i64 %indvars.iv119, 4
  %niter.next.3 = add i64 %niter, 4
  %niter.ncmp.3 = icmp eq i64 %niter.next.3, %unroll_iter
  br i1 %niter.ncmp.3, label %._crit_edge98.unr-lcssa, label %46, !llvm.loop !12

._crit_edge98.unr-lcssa:                          ; preds = %46, %.lr.ph97
  %.lcssa147.ph = phi double [ undef, %.lr.ph97 ], [ %63, %46 ]
  %.unr = phi double [ %.pre, %.lr.ph97 ], [ %63, %46 ]
  %indvars.iv119.unr = phi i64 [ 0, %.lr.ph97 ], [ %indvars.iv.next120.3, %46 ]
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %._crit_edge98, label %.epil.preheader

.epil.preheader:                                  ; preds = %._crit_edge98.unr-lcssa, %.epil.preheader
  %64 = phi double [ %68, %.epil.preheader ], [ %.unr, %._crit_edge98.unr-lcssa ]
  %indvars.iv119.epil = phi i64 [ %indvars.iv.next120.epil, %.epil.preheader ], [ %indvars.iv119.unr, %._crit_edge98.unr-lcssa ]
  %epil.iter = phi i64 [ %epil.iter.next, %.epil.preheader ], [ 0, %._crit_edge98.unr-lcssa ]
  %65 = getelementptr inbounds float, float* %19, i64 %indvars.iv119.epil
  %66 = load float, float* %65, align 4
  %67 = fpext float %66 to double
  %68 = fadd double %64, %67
  store double %68, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next120.epil = add nuw nsw i64 %indvars.iv119.epil, 1
  %epil.iter.next = add i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %epil.iter.next, %xtraiter
  br i1 %epil.iter.cmp.not, label %._crit_edge98, label %.epil.preheader, !llvm.loop !13

._crit_edge98:                                    ; preds = %.epil.preheader, %._crit_edge98.unr-lcssa
  %.lcssa147 = phi double [ %.lcssa147.ph, %._crit_edge98.unr-lcssa ], [ %68, %.epil.preheader ]
  %69 = fcmp olt double %.lcssa147, 5.000000e+03
  br i1 %69, label %.lr.ph100.preheader, label %.loopexit

.lr.ph100.preheader:                              ; preds = %._crit_edge98, %._crit_edge101
  %.082102 = phi i32 [ %86, %._crit_edge101 ], [ 0, %._crit_edge98 ]
  br label %.lr.ph100

.lr.ph100:                                        ; preds = %.lr.ph100.preheader, %.lr.ph100
  %indvars.iv123 = phi i64 [ 0, %.lr.ph100.preheader ], [ %indvars.iv.next124, %.lr.ph100 ]
  %70 = load double, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %71 = fcmp olt double %70, 2.500000e+03
  %72 = trunc i64 %indvars.iv123 to i32
  %73 = add i32 %.082102, %72
  %74 = urem i32 %72, 200
  %75 = zext i32 %74 to i64
  %76 = getelementptr %struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 2, i64 %75
  %77 = load i32, i32* %76, align 4
  %78 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 8
  %79 = getelementptr inbounds float, float* %78, i64 %indvars.iv123
  %. = select i1 %71, i32 2, i32 1
  %80 = xor i32 %77, %.
  %81 = add i32 %73, %80
  %82 = uitofp i32 %81 to float
  store float %82, float* %79, align 4
  %indvars.iv.next124 = add nuw nsw i64 %indvars.iv123, 1
  %83 = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 8
  %84 = zext i32 %83 to i64
  %85 = icmp ult i64 %indvars.iv.next124, %84
  br i1 %85, label %.lr.ph100, label %._crit_edge101, !llvm.loop !15

._crit_edge101:                                   ; preds = %.lr.ph100
  %86 = add nuw i32 %.082102, 1
  %87 = icmp ult i32 %86, %83
  br i1 %87, label %.lr.ph100.preheader, label %.loopexit, !llvm.loop !16

.loopexit:                                        ; preds = %._crit_edge101, %.preheader86, %._crit_edge98
  %.ph = phi i32 [ 0, %.preheader86 ], [ %39, %._crit_edge98 ], [ %83, %._crit_edge101 ]
  %.pr = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 4), align 8
  %88 = icmp sgt i32 %.pr, 99
  %.not110 = icmp eq i32 %.ph, 0
  %or.cond143 = select i1 %88, i1 true, i1 %.not110
  br i1 %or.cond143, label %populate.exit, label %.lr.ph104

.lr.ph104:                                        ; preds = %.loopexit
  %89 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 8
  %wide.trip.count129 = zext i32 %.ph to i64
  %.pre135 = load double, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %90 = add nsw i64 %wide.trip.count129, -1
  %xtraiter151 = and i64 %wide.trip.count129, 3
  %91 = icmp ult i64 %90, 3
  br i1 %91, label %populate.exit.loopexit.unr-lcssa, label %.lr.ph104.new

.lr.ph104.new:                                    ; preds = %.lr.ph104
  %unroll_iter155 = and i64 %wide.trip.count129, 4294967292
  br label %92

92:                                               ; preds = %92, %.lr.ph104.new
  %93 = phi double [ %.pre135, %.lr.ph104.new ], [ %109, %92 ]
  %indvars.iv126 = phi i64 [ 0, %.lr.ph104.new ], [ %indvars.iv.next127.3, %92 ]
  %niter156 = phi i64 [ 0, %.lr.ph104.new ], [ %niter156.next.3, %92 ]
  %94 = getelementptr inbounds float, float* %89, i64 %indvars.iv126
  %95 = load float, float* %94, align 4
  %96 = fpext float %95 to double
  %97 = fadd double %93, %96
  store double %97, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127 = or i64 %indvars.iv126, 1
  %98 = getelementptr inbounds float, float* %89, i64 %indvars.iv.next127
  %99 = load float, float* %98, align 4
  %100 = fpext float %99 to double
  %101 = fadd double %97, %100
  store double %101, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127.1 = or i64 %indvars.iv126, 2
  %102 = getelementptr inbounds float, float* %89, i64 %indvars.iv.next127.1
  %103 = load float, float* %102, align 4
  %104 = fpext float %103 to double
  %105 = fadd double %101, %104
  store double %105, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127.2 = or i64 %indvars.iv126, 3
  %106 = getelementptr inbounds float, float* %89, i64 %indvars.iv.next127.2
  %107 = load float, float* %106, align 4
  %108 = fpext float %107 to double
  %109 = fadd double %105, %108
  store double %109, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127.3 = add nuw nsw i64 %indvars.iv126, 4
  %niter156.next.3 = add i64 %niter156, 4
  %niter156.ncmp.3 = icmp eq i64 %niter156.next.3, %unroll_iter155
  br i1 %niter156.ncmp.3, label %populate.exit.loopexit.unr-lcssa, label %92, !llvm.loop !17

populate.exit.loopexit.unr-lcssa:                 ; preds = %92, %.lr.ph104
  %.unr153 = phi double [ %.pre135, %.lr.ph104 ], [ %109, %92 ]
  %indvars.iv126.unr = phi i64 [ 0, %.lr.ph104 ], [ %indvars.iv.next127.3, %92 ]
  %lcmp.mod154.not = icmp eq i64 %xtraiter151, 0
  br i1 %lcmp.mod154.not, label %populate.exit, label %.epil.preheader150

.epil.preheader150:                               ; preds = %populate.exit.loopexit.unr-lcssa, %.epil.preheader150
  %110 = phi double [ %114, %.epil.preheader150 ], [ %.unr153, %populate.exit.loopexit.unr-lcssa ]
  %indvars.iv126.epil = phi i64 [ %indvars.iv.next127.epil, %.epil.preheader150 ], [ %indvars.iv126.unr, %populate.exit.loopexit.unr-lcssa ]
  %epil.iter152 = phi i64 [ %epil.iter152.next, %.epil.preheader150 ], [ 0, %populate.exit.loopexit.unr-lcssa ]
  %111 = getelementptr inbounds float, float* %89, i64 %indvars.iv126.epil
  %112 = load float, float* %111, align 4
  %113 = fpext float %112 to double
  %114 = fadd double %110, %113
  store double %114, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %indvars.iv.next127.epil = add nuw nsw i64 %indvars.iv126.epil, 1
  %epil.iter152.next = add i64 %epil.iter152, 1
  %epil.iter152.cmp.not = icmp eq i64 %epil.iter152.next, %xtraiter151
  br i1 %epil.iter152.cmp.not, label %populate.exit, label %.epil.preheader150, !llvm.loop !18

populate.exit:                                    ; preds = %populate.exit.loopexit.unr-lcssa, %.epil.preheader150, %init.exit, %.loopexit
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([10 x i8], [10 x i8]* @str.1, i64 0, i64 0))
  %115 = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 8
  %.not109 = icmp eq i32 %115, 0
  br i1 %.not109, label %print.exit, label %.lr.ph106

.lr.ph106:                                        ; preds = %populate.exit, %.lr.ph106
  %indvars.iv131 = phi i64 [ %indvars.iv.next132, %.lr.ph106 ], [ 0, %populate.exit ]
  %116 = load float*, float** getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 3), align 8
  %117 = getelementptr inbounds float, float* %116, i64 %indvars.iv131
  %118 = load float, float* %117, align 4
  %119 = fpext float %118 to double
  %120 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i64 0, i64 0), double noundef %119) #4
  %indvars.iv.next132 = add nuw nsw i64 %indvars.iv131, 1
  %121 = load i32, i32* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 0), align 8
  %122 = zext i32 %121 to i64
  %123 = icmp ult i64 %indvars.iv.next132, %122
  br i1 %123, label %.lr.ph106, label %print.exit, !llvm.loop !19

print.exit:                                       ; preds = %.lr.ph106, %populate.exit
  %124 = load double, double* getelementptr inbounds (%struct.ArrayInfo.0, %struct.ArrayInfo.0* @arrayInfo.2, i64 0, i32 1), align 8
  %125 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([14 x i8], [14 x i8]* @.str.3, i64 0, i64 0), double noundef %124) #4
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
