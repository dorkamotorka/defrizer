; ModuleID = 'af_xdp_kern.c'
source_filename = "af_xdp_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xsks_map = dso_local global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !0
@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 64, i32 0 }, section "maps", align 4, !dbg !15
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !25
@llvm.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sock_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_sock_prog(%struct.xdp_md* nocapture readonly %0) #0 section "xdp_sock" !dbg !54 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !66, metadata !DIExpression()), !dbg !70
  %3 = bitcast i32* %2 to i8*, !dbg !71
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !71
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !72
  %5 = load i32, i32* %4, align 4, !dbg !72, !tbaa !73
  call void @llvm.dbg.value(metadata i32 %5, metadata !67, metadata !DIExpression()), !dbg !70
  store i32 %5, i32* %2, align 4, !dbg !78, !tbaa !79
  call void @llvm.dbg.value(metadata i32* %2, metadata !67, metadata !DIExpression(DW_OP_deref)), !dbg !70
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %3) #3, !dbg !80
  %7 = bitcast i8* %6 to i32*, !dbg !80
  call void @llvm.dbg.value(metadata i32* %7, metadata !68, metadata !DIExpression()), !dbg !70
  %8 = icmp eq i8* %6, null, !dbg !81
  br i1 %8, label %14, label %9, !dbg !83

9:                                                ; preds = %1
  %10 = load i32, i32* %7, align 4, !dbg !84, !tbaa !79
  %11 = add i32 %10, 1, !dbg !84
  store i32 %11, i32* %7, align 4, !dbg !84, !tbaa !79
  %12 = and i32 %10, 1, !dbg !87
  %13 = icmp eq i32 %12, 0, !dbg !87
  br i1 %13, label %14, label %20, !dbg !88

14:                                               ; preds = %9, %1
  call void @llvm.dbg.value(metadata i32* %2, metadata !67, metadata !DIExpression(DW_OP_deref)), !dbg !70
  %15 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i8* nonnull %3) #3, !dbg !89
  %16 = icmp eq i8* %15, null, !dbg !89
  br i1 %16, label %20, label %17, !dbg !91

17:                                               ; preds = %14
  %18 = load i32, i32* %2, align 4, !dbg !92, !tbaa !79
  call void @llvm.dbg.value(metadata i32 %18, metadata !67, metadata !DIExpression()), !dbg !70
  %19 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i64)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 %18, i64 0) #3, !dbg !93
  br label %20, !dbg !94

20:                                               ; preds = %14, %9, %17
  %21 = phi i32 [ %19, %17 ], [ 2, %9 ], [ 2, %14 ], !dbg !70
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !95
  ret i32 %21, !dbg !95
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!50, !51, !52}
!llvm.ident = !{!53}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 8, type: !17, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !14, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "af_xdp_kern.c", directory: "/home/ubuntu/MasterThesis/preoven-thesis/af-xdp")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/ubuntu/MasterThesis/preoven-thesis/af-xdp")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !{!0, !15, !25, !31, !40}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !3, line: 16, type: !17, isLocal: false, isDefinition: true)
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !18, line: 33, size: 160, elements: !19)
!18 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/ubuntu/MasterThesis/preoven-thesis/af-xdp")
!19 = !{!20, !21, !22, !23, !24}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !17, file: !18, line: 34, baseType: !7, size: 32)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !17, file: !18, line: 35, baseType: !7, size: 32, offset: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !17, file: !18, line: 36, baseType: !7, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !17, file: !18, line: 37, baseType: !7, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !17, file: !18, line: 38, baseType: !7, size: 32, offset: 128)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 57, type: !27, isLocal: false, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 32, elements: !29)
!28 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!29 = !{!30}
!30 = !DISubrange(count: 4)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !33, line: 33, type: !34, isLocal: true, isDefinition: true)
!33 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/ubuntu/MasterThesis/preoven-thesis/af-xdp")
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = !DISubroutineType(types: !36)
!36 = !{!37, !37, !38}
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !33, line: 1254, type: !42, isLocal: true, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DISubroutineType(types: !44)
!44 = !{!45, !37, !46, !48}
!45 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!47 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !49)
!49 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!50 = !{i32 7, !"Dwarf Version", i32 4}
!51 = !{i32 2, !"Debug Info Version", i32 3}
!52 = !{i32 1, !"wchar_size", i32 4}
!53 = !{!"clang version 10.0.0-4ubuntu1 "}
!54 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 35, type: !55, scopeLine: 36, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !65)
!55 = !DISubroutineType(types: !56)
!56 = !{!45, !57}
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !59)
!59 = !{!60, !61, !62, !63, !64}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !58, file: !6, line: 2857, baseType: !46, size: 32)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !58, file: !6, line: 2858, baseType: !46, size: 32, offset: 32)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !58, file: !6, line: 2859, baseType: !46, size: 32, offset: 64)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !58, file: !6, line: 2861, baseType: !46, size: 32, offset: 96)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !58, file: !6, line: 2862, baseType: !46, size: 32, offset: 128)
!65 = !{!66, !67, !68}
!66 = !DILocalVariable(name: "ctx", arg: 1, scope: !54, file: !3, line: 35, type: !57)
!67 = !DILocalVariable(name: "index", scope: !54, file: !3, line: 37, type: !45)
!68 = !DILocalVariable(name: "pkt_count", scope: !54, file: !3, line: 38, type: !69)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!70 = !DILocation(line: 0, scope: !54)
!71 = !DILocation(line: 37, column: 5, scope: !54)
!72 = !DILocation(line: 37, column: 22, scope: !54)
!73 = !{!74, !75, i64 16}
!74 = !{!"xdp_md", !75, i64 0, !75, i64 4, !75, i64 8, !75, i64 12, !75, i64 16}
!75 = !{!"int", !76, i64 0}
!76 = !{!"omnipotent char", !77, i64 0}
!77 = !{!"Simple C/C++ TBAA"}
!78 = !DILocation(line: 37, column: 9, scope: !54)
!79 = !{!75, !75, i64 0}
!80 = !DILocation(line: 40, column: 17, scope: !54)
!81 = !DILocation(line: 41, column: 9, scope: !82)
!82 = distinct !DILexicalBlock(scope: !54, file: !3, line: 41, column: 9)
!83 = !DILocation(line: 41, column: 9, scope: !54)
!84 = !DILocation(line: 43, column: 25, scope: !85)
!85 = distinct !DILexicalBlock(scope: !86, file: !3, line: 43, column: 13)
!86 = distinct !DILexicalBlock(scope: !82, file: !3, line: 41, column: 20)
!87 = !DILocation(line: 43, column: 28, scope: !85)
!88 = !DILocation(line: 43, column: 13, scope: !86)
!89 = !DILocation(line: 50, column: 9, scope: !90)
!90 = distinct !DILexicalBlock(scope: !54, file: !3, line: 50, column: 9)
!91 = !DILocation(line: 50, column: 9, scope: !54)
!92 = !DILocation(line: 52, column: 44, scope: !90)
!93 = !DILocation(line: 52, column: 16, scope: !90)
!94 = !DILocation(line: 52, column: 9, scope: !90)
!95 = !DILocation(line: 55, column: 1, scope: !54)
