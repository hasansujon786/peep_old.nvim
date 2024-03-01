local Peep = {}
local Config = require('peep.config')
Peep.__index = Peep

function Peep:new()
  local config = Config.get_default_config()

  local peep = setmetatable({
    config = config,
    hooks_setup = false,
    -- data = Data.Data:new(),
    -- logger = Log,
    -- ui = Ui:new(config.settings),
    -- _extensions = Extensions.extensions,
    -- lists = {},
  }, self)

  return peep
end

local _peep = Peep:new()

function Peep:setup(new_config)
  if self ~= _peep then
    self = _peep
  end

  self.config = Config.merge(new_config, self.config)

  return self
end

return _peep
