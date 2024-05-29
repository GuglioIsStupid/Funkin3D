-- get arg 
local json = require("libs.json")
local lume = require("libs.lume")

local filePath = "charts/"
-- recursive search for files
local files = {}

local function scanDir(directory)
    -- use os to get list of folders
    local f = io.popen("ls " .. directory)
    print("Scanning directory: " .. directory)
    for file in f:lines() do
        if file:sub(-4) == "json" then
            table.insert(files, directory .. file)
        else
            scanDir(directory .. file .. "/")
        end
    end
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