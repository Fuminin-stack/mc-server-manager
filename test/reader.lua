local readfile = io.open("int", "r")
if readfile ~= nil  then
  while true do
    local value = readfile:read()
    if value == nil then
      io.write("reached end \n")
      break
    end
    print(value)
  end
end
