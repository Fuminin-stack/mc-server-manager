--- @meta

--- @class StringBuffer
--- @field value table
--- @field pos number
--- @field toString fun(self): string
--- @field push fun(self, char: string)
--- @field pop fun(self): string
--- @field getPos fun(self): number
--- @field movePos fun(self, increment: number): number Returns the state of execution:

StringBuffer = {}

--- Constructor of StringBuffer
--- @return StringBuffer
function StringBuffer.new()
  --- @type StringBuffer
  local self = setmetatable({}, StringBuffer)
  self.value = {}
  self.pos = 0
  return self
end

--- Check, trim, and output the input string to a character
--- @param input string
--- @return string 
function StringBuffer.trimInput(input)
  if #input ~= 1 then return input:sub(1,1) else return input end
end

function StringBuffer:toString()
  return table.concat(self.value)
end

function StringBuffer:push(char)
  local input = self.trimInput(char)
  self.value[#self.value+1] = input
end

function StringBuffer:pop()
  local char = self.value[#self.value]
  self.value[#self.value] = nil
  return char
end

function StringBuffer:getPos()
  return self.pos
end

--- <ul><li>0 for success</li><li>64 for failure</li></ul>
--- @param increment integer
--- @return integer
function StringBuffer:movePos(increment)
  local resultPos = self.pos + increment
  if resultPos <= 0 then
    self.pos = 0
    return 64
  elseif resultPos > #self.value then
    self.pos = #self.value
    return 64
  else
    self.pos = resultPos
  end
  return 0
end

function StringBuffer:insert(char)
  table.insert(self.value, self.pos, self.trimInput(char))
  self.pos = self.pos + 1
end

function StringBuffer:toEnd()
  self.pos = #self.value
end
