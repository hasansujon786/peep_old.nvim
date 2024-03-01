local M = {}

-----@class PeepConfig
-----@field

function M.get_default_config()
  local config = {
    name = 'peep',
  }
  return config
end

function M.merge(new_config, config)
  new_config = new_config or {}
  local _config = config or M.get_default_config()
  _config = vim.tbl_extend('force', config, new_config)
  return _config
end

return M
