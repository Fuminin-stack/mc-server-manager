os.execute("stty raw -echo -icanon")

local log = assert(io.open("instant_log", "w"))
log:setvbuf("no")

io.stdout:write("\027[2J\027[H")
io.stdout:flush()

while true do

  local command = ""
  local seq_mod = false

  while true do
    local char = io.stdin:read(1)

    if char == nil then break end

    if seq_mod then
      if char == "D" or char == "C" then
        io.stdout:write("\027[D")
      end
      seq_mod = false
      goto continue
    end

    if char == "\027" then
      if io.stdin:read(1) == "[" then
        seq_mod = true
        log:write("\n\rseq mod triggered\n\r")
      end
      -- enter seq mod
      goto continue
    end

    log:write(char)
    if char == "\r" then
      break
    elseif char == "\127" then
      io.stdout:write("\008\032\008")
      io.stdout:flush()
      command = command:sub(1, -2)
    else
      io.stdout:write(char)
      io.flush()
      command = command .. char
    end

    ::continue::
  end

  io.stdout:write("\r\n")
  io.stdout:write(command .. "<e>" .. "\r\n")
  log:write("\n\r")

  if command == "stop" then
    io.flush()
    break
  end

  command = ""
end

log:close()
os.execute("stty sane echo icanon")
