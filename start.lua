require "default"
require "logger"

FINALSET = {}

local function exitOnFailure(reason, exit_code)
  io.write("Exited, server launching failed, reason: " .. reason .. "\n")
  os.exit(exit_code)
end

local function isEmpty(input)
  return input ~= nil
end

local function haltCheck(input)
  if input == "stop" then
    exitOnFailure("halt by user.", 0)
  end
end

local function receive_param(parameter, messages, input_analyser)
  io.write(messages.entry .. "\n")
  -- loop for parameters
  while true do
    local input = ""
    -- loop for character
    while true do
      os.execute("stty -icanon")
      local char_input = io.stdin:read(1)
      io.write(char_input)
      io.flush()
    end
  end


  while true do
    io.write(messages["entry"] .. "\n")
    local input = io.stdin.read()
    haltCheck(input)
    if isNumber(input) then 
      return DEFAULT[parameter] 
    end

    local analyse_result = input_analyser(input)
    if analyse_result["check_result"] == "retry" then
      io.write(messages["retry"] .. "\n")
      goto continue
    elseif analyse_result["check_result"] == "success" then
      io.write(messages["success"] .. "\n")
      return analyse_result["received_value"]
    else
      exitOnFailure(analyse_result["error_message"], 1)
    end
    ::continue::
  end
end

for param, def_param in pairs(DEFAULT) do
  FINALSET[param] = receive_param()
end

LAUNCH = "java -Xms" .. FINALSET["memory_size"] .. "M -Xmx" .. FINALSET["memory_size"] .. "M -jar ../" .. DEFAULT["game_loader"] .. " nogui" .. "\n"
io.write(LAUNCH)
