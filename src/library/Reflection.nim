######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2020 Yanis Zafirópulos
#
# @file: library/Reflection.nim
######################################################

# #=======================================
# # Helpers
# #=======================================

# proc printHelp*() {.inline.} =
#     var tbl = initTable[string,string]()

#     for spec in OpSpecs:
#         if spec.name!="":
#             var args = ""
#             if spec.an!="":
#                 args &= spec.an
#             if spec.bn!="":
#                 args &= ", " & spec.bn
#             if spec.cn!="":
#                 args &= ", " & spec.cn

#             tbl[spec.name] = alignLeft("(" & args & ")",35) & spec.desc.replace("~"," ")

#     let sorted = toSeq(tbl.pairs).sorted

#     for pair in sorted:
#         echo fgBold & alignLeft(pair[0],20) & fgWhite & pair[1]

# proc getInfo*(op: OpSpec): Value {.inline.} =
#     var argArray: ValueArray = @[]
#     if op.args >= 1:
#         argArray.add(newDictionary({"name": newString(op.an), "type": newBlock(toSeq((op.a).items).map(proc(x:ValueKind):Value = newType(x)))}.toOrderedTable))

#         if op.args >= 2:
#             argArray.add(newDictionary({"name": newString(op.bn), "type": newBlock(toSeq((op.b).items).map(proc(x:ValueKind):Value = newType(x)))}.toOrderedTable))

#             if op.args >= 3:
#                 argArray.add(newDictionary({"name": newString(op.cn), "type": newBlock(toSeq((op.c).items).map(proc(x:ValueKind):Value = newType(x)))}.toOrderedTable))


#     var ret: Value = newBlock(toSeq((op.ret).items).map(proc(x:ValueKind):Value = newType(x)))         

#     var attrArray: ValueArray = @[]
#     if op.attrs!="":
#         var parts = op.attrs.split("~")
#         for part in parts:
#             var subparts = part.split("->")
#             var descr = subparts[1].strip
#             var subsubparts = subparts[0].split()
#             var name = subsubparts[0]
#             var params: ValueArray = @[]
            
#             for subsub in subsubparts:
#                 if subsub != name:
#                     if subsub.strip!="":
#                         params.add(newType(subsub.strip.replace(":")))

#             attrArray.add(newDictionary({
#                     "name": newString(name.strip.replace(".")),
#                     "action": newString(descr.strip),
#                     "parameters": newBlock(params)
#                 }.toOrderedTable))
#         discard

#     let clearName = op.name.replace("*","")
#     result = newDictionary({
#                     "name"          : newString(clearName),
#                     "description"   : newString(op.desc.replace("~"," ")),
#                     "alias"         : newString(op.alias),
#                     "arguments"     : newBlock(argArray),
#                     "attributes"    : newBlock(attrArray),
#                     "return"        : ret
#                 }.toOrderedTable)

# proc printInfo*(op: OpSpec) {.inline.} =

#     proc countSubstr(s, sub: string): int =
#         var i = 0
#         while true:
#             i = s.find(sub, i)
#             if i < 0:
#                 break
#             i += sub.len # i += 1 for overlapping substrings
#             inc result

#     var params = ""

#     let maxLen = @[op.an.len, op.bn.len, op.cn.len].max() + 1

#     if op.args >= 1:
#         params &= alignLeft(op.an,maxLen) & fgGray & " " & toSeq((op.a).items).map(proc(x:ValueKind):string = ":" & ($(x)).toLowerAscii()).join(" ") & " " & fgWhite
#     if op.args >= 2:
#         params &= "\n|" & ' '.repeat(18+op.name.len) & alignLeft(op.bn,maxLen) & fgGray & " " & toSeq((op.b).items).map(proc(x:ValueKind):string = ":" & ($(x)).toLowerAscii()).join(" ") & " " & fgWhite
#     if op.args >= 3:
#         params &= "\n|" & ' '.repeat(18+op.name.len) & alignLeft(op.cn,maxLen) & fgGray & " " & toSeq((op.c).items).map(proc(x:ValueKind):string = ":" & ($(x)).toLowerAscii()).join(" ") & "" & fgWhite

#     var ret = toSeq((op.ret).items).map(proc(x:ValueKind):string = ":" & ($(x)).toLowerAscii()).join(" ")
#     var formattedDesc = op.desc.replace("~","\n|                 ")

#     echo fmt("|------------------------------------------------------------------")
#     echo fmt("|    {fgMagenta}{align(op.name,11)}{fgWhite}  {formattedDesc}")
#     if op.alias!="":
#         echo fmt("|          {fgWhite}alias{fgWhite}  {op.alias}")
#     # echo fmt("|")
#     # echo fmt("|                 {formattedDesc}")
#     echo fmt("|------------------------------------------------------------------")
#     let clearName = op.name.replace("*","")
#     echo fmt("|          {fgGreen}usage{fgWhite}  {fgBold}{clearName}{fgWhite} {params}")

#     if op.attrs!="":
#         echo "|"
#         var attrLines = op.attrs.replacef(re":(\w+)", fgGray & ":$1" & fgWhite)
#                             .replacef(re"\.(\w+)", fgBold & ".$1" & fgWhite)
#                             .split("~")
#         var maxattr = attrLines.map(proc (x:string):int = (x.split("->"))[0].len ).max()
#         var maxprop = attrLines.map(proc (x:string):int = (x.split("->"))[0].countSubstr(":") ).max()
#         #maxattr = attrLines.map(proc (x:string):int = (echo x.split("->"); echo (x.split("->"))[0].len; x.split("->"))[0].len ).max()
#         attrLines = attrLines.map(proc (x:string):string = 
#             alignLeft( (x.split("->"))[0], maxattr-((maxprop-(x.split("->"))[0].countSubstr(":"))*11)) & "->" & (x.split("->"))[1]
#         )
#         #echo fmt("maxattr: {maxattr}")
#         var formattedAttrs = attrLines.join("\n|                 ")
                                     
#         echo fmt("|        {fgGreen}options{fgWhite}  {formattedAttrs}")

#     echo "|"
#     echo fmt("|        {fgGreen}returns{fgWhite}  {fgGray}{ret}{fgWhite}")
#     echo fmt("|------------------------------------------------------------------")

#=======================================
# Methods
#=======================================

builtin "attr",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "get given attribute, if it exists",
    args        = {
        "name"  : {String,Literal}
    },
    attrs       = NoAttrs,
    returns     = {Any,Null},
    example     = """
        multiply: function [x][
        ____if? attr? "with" [ 
        ________x * attr "with"
        ____] 
        ____else [ 
        ________2*x 
        ____]
        ]
        
        print multiply 5
        ; 10
        
        print multiply.with: 6 5
        ; 60
    """:
        ##########################################################
        stack.push(popAttr(x.s))

builtin "attr?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "check if given attribute exists",
    args        = {
        "name"  : {String,Literal}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
        # greet: function [x][
        # ____if? not? attr? 'later [
        # ________print ["Hello" x "!"]
        # ____]
        # ____else [
        # ________print [x "I'm afraid I'll greet you later!"]
        # ____]
        # ]
        #
        # greet.later "John"
        #
        # ; John I'm afraid I'll greet you later!
    """:
        ##########################################################
        if getAttr(x.s) != VNULL:
            stack.push(VTRUE)
        else:
            stack.push(VFALSE)

builtin "attribute?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :attribute",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Attribute))

builtin "attributeLabel?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :attributeLabel",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==AttributeLabel))

builtin "attrs",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "get dictionary of set attributes",
    args        = {
        "name"  : {String,Literal}
    },
    attrs       = NoAttrs,
    returns     = {Dictionary},
    example     = """
        greet: function [x][
        ____print ["Hello" x "!"]
        ____print attrs
        ]
        
        greet.later "John"
        
        ; Hello John!
        ; [
        ;____later:    true
        ; ]
    """:
        ##########################################################
        stack.push(getAttrsDict())

builtin "benchmark",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "benchmark given code",
    args        = {
        "action": {Block}
    },
    attrs       = NoAttrs,
    returns     = {Nothing},
    example     = """
        benchmark [ 
        ____; some process that takes some time
        ____loop 1..10000 => prime? 
        ]
        
        ; [benchmark] time: 0.065s
    """:
        ##########################################################
        benchmark "":
            discard execBlock(x)

builtin "binary?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :binary",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Binary))

builtin "block?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :block",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Block))

builtin "boolean?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :boolean",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Boolean))

builtin "char?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :char",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Char))

builtin "database?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :database",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Database))

builtin "date?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :date",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Date))

builtin "dictionary?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :dictionary",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Dictionary))

builtin "help",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "print help",
    args        = NoArgs,
    attrs       = NoAttrs,
    returns     = {Nothing},
    example     = """
    """:
        ##########################################################
        echo "showing help"

# template Help*():untyped =
#     # EXAMPLE:
#     # help
#     #
#     # ; abs      (value)   get the absolute value for given integer
#     # ; acos     (angle)   calculate the inverse cosine of given angle
#     # ; acosh    (angle)   calculate the inverse hyperbolic cosine of given angle
#     # ; ...
#     #
#     # help 'print
#     # ; |------------------------------------------------------------------
#     # ;           print  print given value to screen with newline
#     # ; |------------------------------------------------------------------
#     # ; |          usage  print value  :any 
#     # ; |
#     # ; |        returns  :null
#     # ; |------------------------------------------------------------------
#     #
    
#     require(opHelp)

#     if x.kind==Literal:

#         var found = false
#         for opspec in OpSpecs:
#             if opspec.name.replace("*","") == x.s:
#                 found = true
#                 opspec.printInfo()
#                 break

#         if not found:
#             echo "no information found for given symbol"

#     else:
#         printHelp()

builtin "info",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "print info for given symbol",
    args        = {
        "symbol": {String,Literal}
    },
    attrs       = NoAttrs,
    returns     = {Nothing},
    example     = """
    """:
        ##########################################################
        echo "showing info for: " & $(x.s)

    # # print info 'print
    # #
    # # ;_[
    # # ;____name:           print
    # # ;____description:    print given value to screen with newline
    # # ;____alias:          
    # # ;____arguments:      [
    # # ;________[
    # # ;____________name:           value
    # # ;____________type:           [
    # # ;________________:any
    # # ;____________]
    # # ;________]
    # # ;____]
    # # ;____attributes:     [
    # # ;____]
    # # ;____return:         [
    # # ;________:null
    # # ;____]
    # # ; ]

    # require(opInfo)

    # for opspec in OpSpecs:
    #     if opspec.name.replace("*","") == x.s:
    #         stack.push(opspec.getInfo())
    #         break

builtin "inline?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :inline",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Inline))

builtin "inspect",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "print full dump of given value to screen",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Nothing},
    example     = """
        inspect 3                 ; 3 :integer
        
        a: "some text"
        inspect a                 ; some text :string
    """:
        ##########################################################
        x.dump(0, false)

builtin "integer?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :integer",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Integer))

builtin "is?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "print full dump of given value to screen",
    args        = {
        "type"  : {Type},
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
        is? :string "hello"       ; => true
        is? :block [1 2 3]        ; => true
        is? :integer "boom"       ; => false
    """:
        ##########################################################
        stack.push(newBoolean(x.t == y.kind))

builtin "floating?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :floating",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Floating))

builtin "function?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :function",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Function))

builtin "label?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :label",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Label))

builtin "literal?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :literal",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Literal))

builtin "null?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :null",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Null))

builtin "path?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :path",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Path))

builtin "pathLabel?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :pathLabel",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==PathLabel))

builtin "set?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "check if given variable is defined",
    args        = {
        "symbol"    : {String,Literal}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
        boom: 12
        print set? 'boom          ; true
        
        print set? 'zoom          ; false
    """:
        ##########################################################
        stack.push(newBoolean(syms.hasKey(x.s)))

builtin "stack",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "get current stack",
    args        = NoArgs,
    attrs       = NoAttrs,
    returns     = {Dictionary},
    example     = """
    """:
        ##########################################################
        stack.push(newBlock(Stack[0..SP-1]))

builtin "standalone?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if current script runs from the command-line",
    args        = NoArgs,
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(PathStack.len == 1))

builtin "string?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :string",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==String))

builtin "symbol?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :symbol",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Symbol))

builtin "symbols",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "get currently defined symbols",
    args        = NoArgs,
    attrs       = NoAttrs,
    returns     = {Dictionary},
    example     = """
        a: 2
        b: "hello"
        
        print symbols
        
        ; [
        ;____a: 2
        ;____b: "hello"
        ;_]
    """:
        ##########################################################
        var symbols: ValueDict = initOrderedTable[string,Value]()
        for k,v in pairs(syms):
            if k[0]!=toUpperAscii(k[0]):
                symbols[k] = v
        stack.push(newDictionary(symbols))

builtin "type",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "get type of given value",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Type},
    example     = """
        print type 18966          ; :integer
        print type "hello world"  ; :string
    """:
        ##########################################################
        stack.push(newType(x.kind))

builtin "type?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :type",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Type))

builtin "word?",
    alias       = unaliased, 
    rule        = PrefixPrecedence,
    description = "checks if given value is of type :word",
    args        = {
        "value" : {Any}
    },
    attrs       = NoAttrs,
    returns     = {Boolean},
    example     = """
    """:
        ##########################################################
        stack.push(newBoolean(x.kind==Word))

