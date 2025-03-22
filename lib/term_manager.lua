require("stringBuf")

local llcontrolpkg = require("llcontrol")
local llc = llcontrolpkg.unpack()

local function clearScreen()
  io.stdout:write("\027[2J\027[H")
  io.stdout:flush()
end

local function enterCycle()
  llc.mkfifo("../logs/termlog.temp")
  local log = assert(io.open("../logs/termlog.temp", "w"))
  log:setvbuf("no")
  llc.enableRawMode()
  clearScreen()
  clearScreen()
  return log
end

local function exitCycle(log_to_be_closed)
  llc.remove("../logs/termlog.temp")
  llc.disableRawMode()
  log_to_be_closed:close()
end

---@enum char_interpreter_exit_code
local CHAR_INT_EXIT_CODE = {
  sequence = "sequence",
  continue = "continue",
  next_command = "next command"
}

---
---@param char string
---@param mode string
---@param log_target file*
---@param command_buffer StringBuffer
---@return string
local function charInterpreter(char, mode, log_target, command_buffer)
  local retmode = CHAR_INT_EXIT_CODE.continue

  if mode == "sequence" then

    if char == "D" then
      if command_buffer:movePos(-1) then io.stdout:write("\027[D") end
    elseif char == "C" then
      if command_buffer:movePos(1) then io.stdout:write("\027[C") end
    end

    io.stdout:flush()

  elseif char == "\027" then

    local next_char = io.stdin:read(1)
    if next_char == "[" then
      log_target:write("<sequence>")
      retmode = CHAR_INT_EXIT_CODE.sequence
    else
      log_target:write("<escape>")
      command_buffer:insert(next_char)
    end

  elseif char == "\n" then

    log_target:write("<carriage>")
    retmode = CHAR_INT_EXIT_CODE.next_command

  elseif char == "\127" then

    command_buffer:withdraw()
    io.stdout:write("\0277\027[2K\027[0G")
    command_buffer:writeToio(io.stdout)
    io.stdout:write("\0278\027[D")
    io.stdout:flush()

  else

    log_target:write(char)
    command_buffer:insert(char)
    io.stdout:write("\0277\027[2K\027[0G")
    command_buffer:writeToio(io.stdout)
    io.stdout:write("\0278\027[C")
    io.stdout:flush()

  end

  return retmode
end

function MainCycle(log_target, interpreter)
  local templog = enterCycle()
  while true do
    --- @type StringBuffer
    local command = StringBuffer.new()
    local stat = "continue"

    while true do
      local char = io.stdin:read(1)
      stat = charInterpreter(char, stat, templog, command)
      if stat == "next command" then break end
    end

    io.stdout:write("\r\n")
    io.stdout:write(command:toString() .. "<e>" .. "\r\n")
    templog:write(command:toString() .. "\r\n")

    local action = interpreter(command:toString())
    if action == "halt" then break end

    command:clear()
  end
  exitCycle(templog)
end

local function tempInt(input)
  if input == "stop" then return "halt"
  else return "continue"
  end
end

pcall(MainCycle, nil, tempInt)
llc.disableRawMode()
