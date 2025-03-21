Logger = {}
Logger.__index = Logger

function Logger.new(logfile)
  local self = setmetatable({}, Logger)
  self.targetfile = io.open("./logs/" .. logfile, "a")
  return self
end

function Logger:logentry(entry)
  self.targetfile:write(entry)
  self.targetfile:flush()
end

function Logger:close()
  self.targetfile:close()
  self = nil
end

