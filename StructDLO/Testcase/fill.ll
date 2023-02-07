; ModuleID = 'fill.c'
source_filename = "fill.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ArrayInfo = type { i32, i32, double, i32, [200 x i32], i64, float*, [100 x i8], i64, i32 }

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init(%struct.ArrayInfo* noundef %0) #0 {
  %2 = alloca %struct.ArrayInfo*, align 8
  %3 = alloca i32, align 4
  store %struct.ArrayInfo* %0, %struct.ArrayInfo** %2, align 8
  %4 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %5 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %4, i32 0, i32 1
  store i32 0, i32* %5, align 4
  %6 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %7 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %6, i32 0, i32 0
  %8 = load i32, i32* %7, align 8
  %9 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %10 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %9, i32 0, i32 3
  store i32 %8, i32* %10, align 8
  store i32 0, i32* %3, align 4
  br label %11

11:                                               ; preds = %22, %1
  %12 = load i32, i32* %3, align 4
  %13 = icmp ult i32 %12, 200
  br i1 %13, label %14, label %25

14:                                               ; preds = %11
  %15 = load i32, i32* %3, align 4
  %16 = add i32 %15, 10
  %17 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %18 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %17, i32 0, i32 4
  %19 = load i32, i32* %3, align 4
  %20 = zext i32 %19 to i64
  %21 = getelementptr inbounds [200 x i32], [200 x i32]* %18, i64 0, i64 %20
  store i32 %16, i32* %21, align 4
  br label %22

22:                                               ; preds = %14
  %23 = load i32, i32* %3, align 4
  %24 = add i32 %23, 1
  store i32 %24, i32* %3, align 4
  br label %11, !llvm.loop !6

25:                                               ; preds = %11
  %26 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %27 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %26, i32 0, i32 5
  store i64 0, i64* %27, align 8
  %28 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %29 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %28, i32 0, i32 0
  %30 = load i32, i32* %29, align 8
  %31 = sub nsw i32 %30, 0
  %32 = sext i32 %31 to i64
  %33 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %34 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %33, i32 0, i32 8
  store i64 %32, i64* %34, align 8
  %35 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %36 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %35, i32 0, i32 9
  store i32 99, i32* %36, align 8
  %37 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %38 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %37, i32 0, i32 2
  store double 0.000000e+00, double* %38, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @populate(%struct.ArrayInfo* noundef %0) #0 {
  %2 = alloca %struct.ArrayInfo*, align 8
  %3 = alloca float, align 4
  %4 = alloca float, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store %struct.ArrayInfo* %0, %struct.ArrayInfo** %2, align 8
  %12 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %13 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %12, i32 0, i32 9
  %14 = load i32, i32* %13, align 8
  %15 = sitofp i32 %14 to float
  store float %15, float* %3, align 4
  store i32 0, i32* %5, align 4
  br label %16

16:                                               ; preds = %75, %1
  %17 = load i32, i32* %5, align 4
  %18 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %19 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %18, i32 0, i32 0
  %20 = load i32, i32* %19, align 8
  %21 = icmp ult i32 %17, %20
  br i1 %21, label %22, label %78

22:                                               ; preds = %16
  %23 = load i32, i32* %5, align 4
  %24 = uitofp i32 %23 to float
  %25 = load float, float* %3, align 4
  %26 = fadd float %25, %24
  store float %26, float* %3, align 4
  store i32 0, i32* %6, align 4
  br label %27

27:                                               ; preds = %71, %22
  %28 = load i32, i32* %6, align 4
  %29 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %30 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %29, i32 0, i32 0
  %31 = load i32, i32* %30, align 8
  %32 = icmp ult i32 %28, %31
  br i1 %32, label %33, label %74

33:                                               ; preds = %27
  %34 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %35 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %34, i32 0, i32 4
  %36 = load i32, i32* %6, align 4
  %37 = urem i32 %36, 200
  %38 = zext i32 %37 to i64
  %39 = getelementptr inbounds [200 x i32], [200 x i32]* %35, i64 0, i64 %38
  %40 = load i32, i32* %39, align 4
  %41 = load i32, i32* %6, align 4
  %42 = add i32 %40, %41
  %43 = uitofp i32 %42 to float
  store float %43, float* %4, align 4
  store i32 0, i32* %7, align 4
  br label %44

44:                                               ; preds = %67, %33
  %45 = load i32, i32* %7, align 4
  %46 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %47 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %46, i32 0, i32 0
  %48 = load i32, i32* %47, align 8
  %49 = icmp ult i32 %45, %48
  br i1 %49, label %50, label %70

50:                                               ; preds = %44
  %51 = load i32, i32* %5, align 4
  %52 = load i32, i32* %6, align 4
  %53 = add i32 %51, %52
  %54 = load i32, i32* %7, align 4
  %55 = add i32 %53, %54
  %56 = uitofp i32 %55 to float
  %57 = load float, float* %3, align 4
  %58 = fadd float %56, %57
  %59 = load float, float* %4, align 4
  %60 = fadd float %58, %59
  %61 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %62 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %61, i32 0, i32 6
  %63 = load float*, float** %62, align 8
  %64 = load i32, i32* %7, align 4
  %65 = zext i32 %64 to i64
  %66 = getelementptr inbounds float, float* %63, i64 %65
  store float %60, float* %66, align 4
  br label %67

67:                                               ; preds = %50
  %68 = load i32, i32* %7, align 4
  %69 = add i32 %68, 1
  store i32 %69, i32* %7, align 4
  br label %44, !llvm.loop !8

70:                                               ; preds = %44
  br label %71

71:                                               ; preds = %70
  %72 = load i32, i32* %6, align 4
  %73 = add i32 %72, 1
  store i32 %73, i32* %6, align 4
  br label %27, !llvm.loop !9

74:                                               ; preds = %27
  br label %75

75:                                               ; preds = %74
  %76 = load i32, i32* %5, align 4
  %77 = add i32 %76, 1
  store i32 %77, i32* %5, align 4
  br label %16, !llvm.loop !10

78:                                               ; preds = %16
  store i32 0, i32* %8, align 4
  br label %79

79:                                               ; preds = %98, %78
  %80 = load i32, i32* %8, align 4
  %81 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %82 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %81, i32 0, i32 0
  %83 = load i32, i32* %82, align 8
  %84 = icmp ult i32 %80, %83
  br i1 %84, label %85, label %101

85:                                               ; preds = %79
  %86 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %87 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %86, i32 0, i32 6
  %88 = load float*, float** %87, align 8
  %89 = load i32, i32* %8, align 4
  %90 = zext i32 %89 to i64
  %91 = getelementptr inbounds float, float* %88, i64 %90
  %92 = load float, float* %91, align 4
  %93 = fpext float %92 to double
  %94 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %95 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %94, i32 0, i32 2
  %96 = load double, double* %95, align 8
  %97 = fadd double %96, %93
  store double %97, double* %95, align 8
  br label %98

98:                                               ; preds = %85
  %99 = load i32, i32* %8, align 4
  %100 = add i32 %99, 1
  store i32 %100, i32* %8, align 4
  br label %79, !llvm.loop !11

101:                                              ; preds = %79
  %102 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %103 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %102, i32 0, i32 2
  %104 = load double, double* %103, align 8
  %105 = fcmp olt double %104, 5.000000e+03
  br i1 %105, label %106, label %173

106:                                              ; preds = %101
  store i32 0, i32* %9, align 4
  br label %107

107:                                              ; preds = %169, %106
  %108 = load i32, i32* %9, align 4
  %109 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %110 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %109, i32 0, i32 0
  %111 = load i32, i32* %110, align 8
  %112 = icmp ult i32 %108, %111
  br i1 %112, label %113, label %172

113:                                              ; preds = %107
  store i32 0, i32* %10, align 4
  br label %114

114:                                              ; preds = %165, %113
  %115 = load i32, i32* %10, align 4
  %116 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %117 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %116, i32 0, i32 0
  %118 = load i32, i32* %117, align 8
  %119 = icmp ult i32 %115, %118
  br i1 %119, label %120, label %168

120:                                              ; preds = %114
  %121 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %122 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %121, i32 0, i32 2
  %123 = load double, double* %122, align 8
  %124 = fcmp olt double %123, 2.500000e+03
  br i1 %124, label %125, label %145

125:                                              ; preds = %120
  %126 = load i32, i32* %9, align 4
  %127 = load i32, i32* %10, align 4
  %128 = add i32 %126, %127
  %129 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %130 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %129, i32 0, i32 4
  %131 = load i32, i32* %10, align 4
  %132 = urem i32 %131, 200
  %133 = zext i32 %132 to i64
  %134 = getelementptr inbounds [200 x i32], [200 x i32]* %130, i64 0, i64 %133
  %135 = load i32, i32* %134, align 4
  %136 = xor i32 %135, 2
  %137 = add i32 %128, %136
  %138 = uitofp i32 %137 to float
  %139 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %140 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %139, i32 0, i32 6
  %141 = load float*, float** %140, align 8
  %142 = load i32, i32* %10, align 4
  %143 = zext i32 %142 to i64
  %144 = getelementptr inbounds float, float* %141, i64 %143
  store float %138, float* %144, align 4
  br label %165

145:                                              ; preds = %120
  %146 = load i32, i32* %9, align 4
  %147 = load i32, i32* %10, align 4
  %148 = add i32 %146, %147
  %149 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %150 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %149, i32 0, i32 4
  %151 = load i32, i32* %10, align 4
  %152 = urem i32 %151, 200
  %153 = zext i32 %152 to i64
  %154 = getelementptr inbounds [200 x i32], [200 x i32]* %150, i64 0, i64 %153
  %155 = load i32, i32* %154, align 4
  %156 = xor i32 %155, 1
  %157 = add i32 %148, %156
  %158 = uitofp i32 %157 to float
  %159 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %160 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %159, i32 0, i32 6
  %161 = load float*, float** %160, align 8
  %162 = load i32, i32* %10, align 4
  %163 = zext i32 %162 to i64
  %164 = getelementptr inbounds float, float* %161, i64 %163
  store float %158, float* %164, align 4
  br label %165

165:                                              ; preds = %145, %125
  %166 = load i32, i32* %10, align 4
  %167 = add i32 %166, 1
  store i32 %167, i32* %10, align 4
  br label %114, !llvm.loop !12

168:                                              ; preds = %114
  br label %169

169:                                              ; preds = %168
  %170 = load i32, i32* %9, align 4
  %171 = add i32 %170, 1
  store i32 %171, i32* %9, align 4
  br label %107, !llvm.loop !13

172:                                              ; preds = %107
  br label %173

173:                                              ; preds = %172, %101
  %174 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %175 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %174, i32 0, i32 9
  %176 = load i32, i32* %175, align 8
  %177 = icmp slt i32 %176, 100
  br i1 %177, label %178, label %202

178:                                              ; preds = %173
  store i32 0, i32* %11, align 4
  br label %179

179:                                              ; preds = %198, %178
  %180 = load i32, i32* %11, align 4
  %181 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %182 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %181, i32 0, i32 0
  %183 = load i32, i32* %182, align 8
  %184 = icmp ult i32 %180, %183
  br i1 %184, label %185, label %201

185:                                              ; preds = %179
  %186 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %187 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %186, i32 0, i32 6
  %188 = load float*, float** %187, align 8
  %189 = load i32, i32* %11, align 4
  %190 = zext i32 %189 to i64
  %191 = getelementptr inbounds float, float* %188, i64 %190
  %192 = load float, float* %191, align 4
  %193 = fpext float %192 to double
  %194 = load %struct.ArrayInfo*, %struct.ArrayInfo** %2, align 8
  %195 = getelementptr inbounds %struct.ArrayInfo, %struct.ArrayInfo* %194, i32 0, i32 2
  %196 = load double, double* %195, align 8
  %197 = fadd double %196, %193
  store double %197, double* %195, align 8
  br label %198

198:                                              ; preds = %185
  %199 = load i32, i32* %11, align 4
  %200 = add i32 %199, 1
  store i32 %200, i32* %11, align 4
  br label %179, !llvm.loop !14

201:                                              ; preds = %179
  br label %202

202:                                              ; preds = %201, %173
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
