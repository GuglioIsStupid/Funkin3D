function math.round(n, deci)
    deci = 10^(deci or 0)
    return math.floor(n*deci+.5)/deci
end

function lerp(a,b,t)
    return a + (b-a)*t
end
function coolLerp(a, b, t)
    return lerp(a, b, t * 60 * love.timer.getDelta())
end
function clamp(a, b, c)
    return math.max(math.min(a, c), b)
end

function table.find(t, v)
    for i, j in pairs(t) do
        if j == v then
            return i
        end
    end
    return nil
end

function unpackLines(t, sep)
    -- t is a table, can have numbers or strings
    -- sep is a string, the separator
    local str = ""
    for i, j in pairs(t) do
        if type(j) == "table" then
            str = str .. unpackLines(j, sep) .. sep
        else
            str = str .. j .. sep
        end
    end
    return str
end