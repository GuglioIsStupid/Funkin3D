-- get arg 
local arg = {...}

if arg[1] == nil then
    print("Please provide a file path")
    return
end

local json = require("libs.json")
local lume = require("libs.lume")

local filePath = arg[1]

local file = io.open(filePath, "r") 
local fileName = ""

fileName = filePath:match("([^/]+)$")

fileName = fileName:sub(1, #fileName - 5)
print(fileName)

if file == nil then
    print("File not found")
    return
end

local content = file:read("*a")
file:close()

local data = json.decode(content)

local serializedData = lume.serialize(data)

local fileWrite = io.open(fileName .. ".lua", "w")
fileWrite:write("return " .. serializedData)
fileWrite:close()

print("File converted to lua")