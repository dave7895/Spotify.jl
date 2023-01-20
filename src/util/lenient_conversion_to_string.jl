function urlstring(;kwds...)
    #println("-1")
    isempty(kwds) && return ""
    urlstring(kwds)
end
function urlstring(kwds::Base.Pairs)
    #println("-2")
    iter = collect(kwds)
    parts = ["$(urlstring(k))=$(urlstring(v))" for (k,v) in iter if v !== "" && v !== 0 && v !== -1]
    join(parts, "&")
end

function urlstring(d::Dict)
    #println("-3")
    parts = ["$(urlstring(k))=$(urlstring(v))" for (k,v) in d if v !== "" && v !== 0 && v !== -1]
    s = join(parts, "&")
end
function urlstring(v::Vector)
    #println("-4")
    vs = urlstring.(v)
    s = join(vs, "%2C")
    #"\"" * s * "\""
    s
end

function urlstring(s)
    #println("-5")
    "$s"
end

"""
    delimit(xs::Vararg{String,N} where N)

Includes separators if needed, for urlstrings.
"""
function delimit(xs::Vararg{String,N} where N)
    sf = first(xs)
    if sf == ""
        throw("The first argument can not be an empty string")
    end
    others = filter( s -> s!== "", xs[2:end])
    if length(others) == 0
        return first(xs)
    end
    if sf[end] == '/' || sf[end] == '='
        sf * join(others, "&")
    else
        first(xs) * "?" * join(others, "&")
    end
end
###

function bodystring(;kwds...)
    #println("1----------")
    isempty(kwds) && return ""
    bodystring(kwds)
end
function bodystring(kwp::Pair)
    #println("2----------")
    s = bodystring(kwp[1]) * ": " * bodystring(kwp[2])
    s
end
function bodystring(kwval::Vector)
    #println("3----------")
    s = "["
    parts = ["$(bodystring(v))" for v in kwval]
    s *= join(parts, ", ")
    s *= "]"
    s
end
function bodystring(kwds::Base.Pairs)
    #println("4----------")
    s = "{"
    parts = ["$(bodystring(p))" for p in kwds if p[2] !== "" && p[2] !== 0]
    s *= join(parts, ",")
    s *= "}"
    s
end
function bodystring(s::Symbol)
    #println("5----------")
    "\"$s\""
end
function bodystring(d::Dict)
    #println("6----------")
    vect = map(zip(keys(d), values(d))) do (k,v)
        Symbol(k) => convert(String, v)
    end
    bodystring(vect)
end
function bodystring(s::T) where T<: Union{SpUri, SpId, SpCategoryId, SpUserId, SpUrl}
    #println("7----------")
    "\"$(s.s)\""
end
function bodystring(s::String)
    #println("8----------")
    "\"$s\""
end
function bodystring(s::Bool)
    #println("9----------")
    "$s"
end
function bodystring(s::T) where T<:Number
    #println("10----------")
    "$s"
end