dofile("lua/config.lua")


local io_file = assert(io.open("doc/objectives_note.html"))
external_documentation_note = io_file:read("*all") -- global
io_file.close()


dofile("lua/documentation.lua")
print(external_documentation_note)
