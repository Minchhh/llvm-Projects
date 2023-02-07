; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ArrayInfo = type { i32, i32, double, i32, [200 x i32], i64, float*, [100 x i8], i64, i32 }

@.str = private unnamed_addr constant [15 x i8] c"LB %ld UB %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"Array is \0A\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c" %f \00", align 1
@.str.3 = private unnamed_addr constant [14 x i8] c"\0A Sum is %lf\0A\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@arrayInfo = dso_local global %struct.ArrayInfo zeroinitializer, align 8

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @allocate(%struct.ArrayInfo* noundef %0) #0 {
  %2 = alloca %struct.ArrayInfo*, align 8
  store %struct.ArrayInfo* %0, %struct.ArrayInfo** %2, align 8
  %3 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %4 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %3, i32 0, i32 0
  %5 = load i32, i32* %4, align 8
  %6 = sext i32 %5 to i64
  %7 = mul i64 4, %6
  %8 = call noalias i8* @malloc(i64 noundef %7) #3
  %9 = bitcast i8* %8 to float*
  %10 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %11 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %10, i32 0, i32 6
  store float* %9, float** %11, align 8
  ret void
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @printLBUB(%struct.ArrayInfo* noundef %0) #0 {
  %2 = alloca %struct.ArrayInfo*, align 8
  store %struct.ArrayInfo* %0, %struct.ArrayInfo** %2, align 8
  %3 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %4 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %3, i32 0, i32 5
  %5 = load i64, i64* %4, align 8
  %6 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %7 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %6, i32 0, i32 8
  %8 = load i64, i64* %7, align 8
  %9 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0), i64 noundef %5, i64 noundef %8)
  ret void
}

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print(%struct.ArrayInfo* noundef %0) #0 {
  %2 = alloca %struct.ArrayInfo*, align 8
  %3 = alloca i32, align 4
  store %struct.ArrayInfo* %0, %struct.ArrayInfo** %2, align 8
  %4 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0))
  store i32 0, i32* %3, align 4
  br label %5

5:                                                ; preds = %21, %1
  %6 = load i32, i32* %3, align 4
  %7 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %8 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %7, i32 0, i32 0
  %9 = load i32, i32* %8, align 8
  %10 = icmp ult i32 %6, %9
  br i1 %10, label %11, label %24

11:                                               ; preds = %5
  %12 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %13 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %12, i32 0, i32 6
  %14 = load float*, float** %13, align 8
  %15 = load i32, i32* %3, align 4
  %16 = zext i32 %15 to i64
  %17 = getelementptr inbounds float, float* %14, i64 %16
  %18 = load float, float* %17, align 4
  %19 = fpext float %18 to double
  %20 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i64 0, i64 0), double noundef %19)
  br label %21

21:                                               ; preds = %11
  %22 = load i32, i32* %3, align 4
  %23 = add i32 %22, 1
  store i32 %23, i32* %3, align 4
  br label %5, !llvm.loop !6

24:                                               ; preds = %5
  %25 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %26 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %25, i32 0, i32 2
  %27 = load double, double* %26, align 8
  %28 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.3, i64 0, i64 0), double noundef %27)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %3 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i64 0, i64 0), i32* noundef %2)
  %4 = load i32, i32* %2, align 4
  store i32 %4, i32* getelementptr inbounds (%struct.ArrayInfo, %struct.ArrayInfo* @arrayInfo, i32 0, i32 0), align 8
  call void @allocate(%struct.ArrayInfo* noundef @arrayInfo)
  call void @init(%struct.ArrayInfo* noundef @arrayInfo)
  call void @populate(%struct.ArrayInfo* noundef @arrayInfo)
  call void @print(%struct.ArrayInfo* noundef @arrayInfo)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8* noundef, ...) #2

declare void @init(%struct.ArrayInfo* noundef) #2

declare void @populate(%struct.ArrayInfo* noundef) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
