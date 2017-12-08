dofile("lua/config.lua")


local io_file = assert(io.open("doc/objectives_note.html"))

-- global
external_documentation_note = io_file:read("*all")

io_file.close()


dofile("lua/documentation.lua")
local note = external_documentation_note
note, _ = string.gsub(note, "<span size=[^>]*>", "== ") -- headers
note, _ = string.gsub(note, "</span>\n", "\n") -- headers (end of line)
note, _ = string.gsub(note, "</*span[^>]*>", "_") -- span
note, _ = string.gsub(note, "<[^>]+>", "") -- all other tags
print(note)
