local target = assert(io.open("int", "w"), "something wrong")
while true do
  local str = io.read()
  if str == "quit" then break end
  target:write(str .. "\n")
  target:flush()
end
target:close()
