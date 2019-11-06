#[*****************************************************************
  * Arturo
  * 
  * Programming Language + Interpreter
  * (c) 2019 Yanis Zafirópulos (aka Dr.Kameleon)
  *
  * @file: lib/system/math.nim
  *****************************************************************]#

#[######################################################
    Helpers
  ======================================================]#

proc isPrime*(n: uint32): bool {.noSideEffect.} =
    case n
        of 0, 1: return false
        of 2, 7, 61: return true
        else: discard
 
    var
        nm1 = n-1
        d = nm1.int
        s = 0
        n = n.uint64
 
    while d mod 2 == 0:
        d = d shr 1
        s += 1
 
    for a in [2, 7, 61]:
        var
            x = 1.uint64
            p = a.uint64
            dr = d
 
        while dr > 0:
            if dr mod 2 == 1:
                x = x * p mod n
            p = p * p mod n
            dr = dr shr 1
 
        if x == 1 or x.uint32 == nm1:
            continue
 
        var r = 1
        while true:
            if r >= s: return false

            x = x * x mod n

            if x == 1: return false
            if x.uint32 == nm1: break

            inc(r)
 
    return true
 
proc isPrime*(n: int32): bool {.noSideEffect.} =
    n >= 0 and n.uint32.isPrime


#[######################################################
    Functions
  ======================================================]#

proc Math_acos*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("acos", f.req)

    result = REAL(arccos(R(0)))

proc Math_acosh*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("acosh", f.req)

    result = REAL(arccosh(R(0)))

proc Math_asin*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("asin", f.req)

    result = REAL(arcsin(R(0)))

proc Math_asinh*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("asinh", f.req)

    result = REAL(arcsinh(R(0)))

proc Math_atan*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("atan", f.req)

    result = REAL(arctan(R(0)))

proc Math_atanh*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("atanh", f.req)

    result = REAL(arctanh(R(0)))

proc Math_avg*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("avg", f.req)

    result = A(0)[0]

    var i = 1
    while i < A(0).len:
        result = result + A(0)[i]
        inc(i)

    result = REAL(result.i / A(0).len)

proc Math_ceil*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("ceil", f.req)

    result = REAL(ceil(R(0)))

proc Math_cos*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("cos", f.req)

    result = REAL(cos(R(0)))

proc Math_cosh*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("cosh", f.req)

    result = REAL(cosh(R(0)))

proc Math_csec*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("csec", f.req)

    result = REAL(csc(R(0)))

proc Math_csech*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("csech", f.req)

    result = REAL(csch(R(0)))

proc Math_ctan*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("ctan", f.req)

    result = REAL(cot(R(0)))

proc Math_ctanh*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("ctanh", f.req)

    result = REAL(coth(R(0)))

proc Math_exp*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("exp", f.req)

    result = REAL(exp(R(0)))

proc Math_floor*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("floor", f.req)

    result = REAL(floor(R(0)))

proc Math_gcd*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("gcd", f.req)

    var current = A(0)[0].i
    var i = 1
    while i<A(0).len:
        current = gcd(current,A(0)[i].i)
        inc(i)

    result = INT(current)

proc Math_isEven*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("isEven", f.req)

    if v[0].kind==IV:
        result = BOOL((I(0) mod 2)==0)
    else:
        result = BOOL(BI(0).even())

proc Math_isOdd*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("isOdd", f.req)

    if v[0].kind==IV:
        result = BOOL((I(0) mod 2)!=0)
    else:
        result = BOOL(BI(0).odd())

proc Math_isPrime*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("isPrime", f.req)

    if v[0].kind==IV:
        if isPrime(I(0).uint32): result = TRUE
        else: result = FALSE
    else:
        if probablyPrime(BI(0),25)==0: result = FALSE
        else: result = TRUE

proc Math_lcm*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("lcm", f.req)

    var current = A(0)[0].i
    var i = 1
    while i<A(0).len:
        current = lcm(current,A(0)[i].i)
        inc(i)

    result = INT(current)

proc Math_ln*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("ln", f.req)

    result = REAL(ln(R(0)))

proc Math_log*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("log", f.req)

    result = REAL(log(R(0),R(1)))

proc Math_log2*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("log2", f.req)

    result = REAL(log2(R(0)))

proc Math_log10*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("log10", f.req)

    result = REAL(log10(R(0)))

proc Math_max*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("min", f.req)

    result = A(0)[0]
    var i = 1
    while i<A(0).len:
        if A(0)[i].gt(result):
            result = A(0)[i]
        inc(i)

proc Math_min*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("min", f.req)

    result = A(0)[0]
    var i = 1
    while i<A(0).len:
        if A(0)[i].lt(result):
            result = A(0)[i]
        inc(i)

proc Math_product*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("product", f.req)

    result = A(0)[0]

    var i = 1
    while i < A(0).len:
        result = result * A(0)[i]
        inc(i)

proc Math_random*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("random", f.req)

    randomize()

    result = INT(rand(I(0)..I(1)))

proc Math_round*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("round", f.req)

    result = REAL(round(R(0)))

proc Math_sec*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("sec", f.req)

    result = REAL(sec(R(0)))

proc Math_sech*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("sech", f.req)

    result = REAL(sech(R(0)))

proc Math_shl*[F,X,V](f: F, xl: X): V  {.inline.} =
    let v = xl.validate("shl", f.req)

    if v[0].kind==IV:
        result = INT(I(0) shl I(1))
    else:
        result = BIGINT(BI(0) shl culong(I(1)))

proc Math_shlI*[F,X,V](f: F, xl: X): V  {.inline.} =
    let v = xl.validate("shl!", f.req)

    if v[0].kind==IV:
        I(0) = I(0) shl I(1)
        result = v[0]
    else:
        BI(0) = BI(0) shl culong(I(1))
        result = v[0]

proc Math_shr*[F,X,V](f: F, xl: X): V  {.inline.} =
    let v = xl.validate("shl", f.req)

    if v[0].kind==IV:
        result = INT(I(0) shr I(1))
    else:
        result = BIGINT(BI(0) shr culong(I(1)))

proc Math_shrI*[F,X,V](f: F, xl: X): V  {.inline.} =
    let v = xl.validate("shr!", f.req)

    if v[0].kind==IV:
        I(0) = I(0) shr I(1)
        result = v[0]
    else:
        BI(0) = BI(0) shr culong(I(1))
        result = v[0]

proc Math_sin*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("sin", f.req)

    result = REAL(sin(R(0)))

proc Math_sinh*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("sinh", f.req)

    result = REAL(sinh(R(0)))

proc Math_sqrt*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("sqrt", f.req)

    result = REAL(sqrt(R(0)))

proc Math_sum*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("sum", f.req)

    result = A(0)[0]

    var i = 1
    while i < A(0).len:
        result = result + A(0)[i]
        inc(i)

proc Math_tan*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("tan", f.req)

    result = REAL(tan(R(0)))

proc Math_tanh*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("tanh", f.req)

    result = REAL(tanh(R(0)))

#[******************************************************
  ******************************************************
    UnitTests
  ******************************************************
  ******************************************************]#

when defined(unittest):

    suite "Library: system/math":

        test "isPrime":
            check(eq( callFunction("isPrime",@[INT(2)]), TRUE ))
            check(eq( callFunction("isPrime",@[INT(3)]), TRUE ))
            check(eq( callFunction("isPrime",@[INT(4)]), FALSE ))
            check(eq( callFunction("isPrime",@[INT(5)]), TRUE ))
            check(eq( callFunction("isPrime",@[INT(6)]), FALSE ))
            check(eq( callFunction("isPrime",@[INT(7)]), TRUE ))
            check(eq( callFunction("isPrime",@[INT(13)]), TRUE ))
            check(eq( callFunction("isPrime",@[INT(982451653)]), TRUE ))
            check(eq( callFunction("isPrime",@[INT(982451655)]), FALSE ))
            check(eq( callFunction("isPrime",@[BIGINT("170141183460469231731687303715884105727")]), TRUE ))
            check(eq( callFunction("isPrime",@[BIGINT("170141183460469231731687303715884105729")]), FALSE ))
            check(eq( callFunction("isPrime",@[BIGINT("20988936657440586486151264256610222593863921")]), TRUE ))
            check(eq( callFunction("isPrime",@[BIGINT("20988936657440586486151264256610222593863927")]), FALSE ))

        test "product":
            check(eq( callFunction("product",@[ARR(@[INT(1),INT(2),INT(3)])]), INT(6) ))

        test "shl":
            check(eq( callFunction("shl",@[INT(10),INT(2)]), INT(40) ))

        test "shr":
            check(eq( callFunction("shr",@[INT(10),INT(2)]), INT(2) ))

        test "sum":
            check(eq( callFunction("sum",@[ARR(@[INT(1),INT(2),INT(3)])]), INT(6) ))
