-- get arg 
local json = require("libs.json")
local lume = require("libs.lume")

local filePath = "charts/"
-- recursive search for files
local files = {}

local isWindows = os.getenv("OS") == "Windows_NT"

local function scanDir(directory)
    local cmdPath = isWindows and directory:gsub("/", "\\") or directory
    print("Scanning directory: " .. directory)

    local fileCmd = isWindows and "dir /B /A:-D \"" or "ls -p \""
    local f = io.popen(fileCmd .. cmdPath .. "\"")
    for file in f:lines() do
        file = file:gsub("\r", "")
        if file ~= "" and file:sub(-4) == "json" then
            table.insert(files, directory .. file)
        end
    end
    f:close()

    local dirCmd = isWindows and "dir /B /A:D \"" or "ls -d */ \""
    local d = io.popen(dirCmd .. cmdPath .. "\"")
    for subdir in d:lines() do
        subdir = subdir:gsub("\r", "")
        if subdir ~= "" and subdir ~= "." and subdir ~= ".." then
            scanDir(directory .. subdir .. "/")
        end
    end
    d:close()
end

scanDir(filePath)

print("Found "..#files.." files")

for i, path in ipairs(files) do
    print("Converting file: " .. path)
    local file = io.open(path, "r")

    if file == nil then
        print("File not found")
        goto continue
    end

    local fileName = ""
    fileName = path:match("([^/]+)$")

    local dirs = string.match(path, "charts/(.*)")
    -- remove fileName from dirs
    dirs = dirs:sub(1, #dirs - #fileName)
    fileName = fileName:sub(1, #fileName - 5)
    -- create directory if it doesn't exist
    os.execute("mkdir exported\\"..dirs:gsub("/", "\\"))
    print("Exporting to: ".."exported/"..dirs)

    print(fileName)

    if file == nil then
        print("File not found")
        return
    end

    local content = file:read("*a")
    file:close()

    local data = json.decode(content)

    local serializedData = lume.serialize(data)

   --[[  local fileWrite = io.open(fileName .. ".lua", "w")
    fileWrite:write("return " .. serializedData)
    fileWrite:close() ]]

    local fileWrite = io.open("exported/"..dirs..fileName .. ".lua", "w")
    fileWrite:write("return" .. serializedData)
    fileWrite:close()

    print("File converted to lua")

    ::continue::
end