creepwars = {}
dofile("lua/utils.lua")
dofile("lua/config.lua")


local io_file = assert(io.open("doc/about.html"))
local note = io_file:read("*all")
io_file.close()


note = loadfile("doc/documentation.lua")(note)
note = string.gsub(note, "<span size=[^>]*>", "== ") -- headers
note = string.gsub(note, "<[^>]+>", "") -- all other tags
note = string.gsub(note, "&lt;", "<")
note = string.gsub(note, "&gt;", ">")
print(note)
