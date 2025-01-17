#=======================================================
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2023 Yanis Zafirópulos
#
# @file: vm/values/custom/vversion.nim
#=======================================================

## The internal `:version` type

#=======================================
# Libraries
#=======================================

import strformat

#=======================================
# Types
#=======================================

type
    VVersion* = ref object
        major*   : int
        minor*   : int
        patch*   : int
        extra*   : string

#=======================================
# Overloads
#=======================================

func `==`*(a, b: VVersion): bool {.inline,enforceNoRaises.} =
    a[] == b[]

func `<`*(a, b: VVersion): bool {.inline,enforceNoRaises.} =
    a.major < b.major or (a.major == b.major and (
        a.minor < b.minor or
        (a.minor == b.minor and a.patch < b.patch)
    ))

func `>`*(a, b: VVersion): bool {.inline,enforceNoRaises.} =
    a.major > b.major or (a.major == b.major and (
        a.minor > b.minor or
        (a.minor == b.minor and a.patch > b.patch)
    ))

func `$`*(v: VVersion): string {.inline,enforceNoRaises.} =
    fmt("{v.major}.{v.minor}.{v.patch}{v.extra}")
