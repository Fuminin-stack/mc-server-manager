require "default"
require "default"

FINALSET = {}

function exitOnFailure(reason, exit_code)
  io.write("Exited, server launching failed, reason: " .. reason .. "\n")
  os.exit(exit_code)
end

function isEmpty(input)
  return input ~= nil
end

function isNumber(input)
  return tonumber(input) ~= nil
end

function haltCheck(input)
  if input == "stop" then
    exitOnFailure("halt by user.", 0)
  end
end

function receive_input()
  
end

function receive_param(parameter, messages, input_analyser)
  while true do
    io.write(messages["entry"] .. "\n")
    
    local input = io.read()
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

io.write("Launching Minecraft server from 'launch.lua'\n")

io.write("java -Xms" .. FINALSET["memory_size"] .. "M -Xmx" .. FINALSET["memory_size"] .. "M -jar " .. DEFAULT["game_loader"] .. " nogui" .. "\n")
