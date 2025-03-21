local funcs = require("termop").unpack()

funcs.enableRawMode()

while true do
  local char = io.stdin:read(1)
  if char == "q" then break end
  io.stdout:write(char .. char .. "\n");
  io.stdout:flush();
end

funcs.disableRawMode()
os.execute("stty sane echo icanon")
