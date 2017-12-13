dofile("lua/config.lua")


local io_file = assert(io.open("doc/objectives_note.html"))
local note = io_file:read("*all")
io_file.close()


note = loadfile("lua/documentation.lua")(note)
note, _ = string.gsub(note, "<span size=[^>]*>", "== ") -- headers
note, _ = string.gsub(note, "</span>\n", "\n") -- headers (end of line)
note, _ = string.gsub(note, "</*span[^>]*>", "_") -- span
note, _ = string.gsub(note, "<[^>]+>", "") -- all other tags
note, _ = string.gsub(note, "&lt;", "<") -- all other tags
note, _ = string.gsub(note, "&gt;", ">") -- all other tags
print(note)
