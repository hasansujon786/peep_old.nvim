---@class Lsp
---@field ui PeepUI
local Lsp = {}
Lsp.__index = Lsp

---@param ui table
function Lsp:new(ui)
  return setmetatable({
    -- win_id = nil,
    -- bufnr = nil,
    -- active_list = nil,
    ui = ui,
  }, self)
end

function Lsp:references(method, context)
  vim.validate({ context = { context, 't', true } })
  local params = vim.lsp.util.make_position_params()
  params.context = context or { includeDeclaration = true }
  -- 'textDocument/definition',
  vim.lsp.buf_request(
    0,
    'textDocument/references',
    params,
    function(err, results, ctx, _)
      if err then
        error(err.message)
      end
      if results == nil or vim.tbl_isempty(results) then
        return vim.notify('No references found', nil, { title = 'Peek' })
      end

      self:handle_lsp_results(results, ctx)
    end
  )
end

function Lsp:handle_lsp_results(results, ctx)
  -- -- location may be LocationLink or Location (more useful for the former)
  -- -- local context = 15
  -- -- local before_context = 0

  local location = results
  if vim.tbl_islist(results) then
    location = results[1]
  end

  local uri = location.targetUri or location.uri
  if uri == nil then
    Foo = location
    return
  end
  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end

  self.ui:render({ preview = { bufnr = bufnr } })

  -- -- local range = location.targetRange or location.range
  -- -- local contents = vim.api.nvim_buf_get_lines(
  -- --   bubufnrfnr,
  -- --   range.start.line - before_context,
  -- --   range['end'].line + 1 + context,
  -- --   false
  -- -- )
  -- -- local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  -- -- return vim.lsp.util.open_floating_preview(
  -- --   contents,
  -- --   filetype,
  -- --   { border = ui.border.style }
  -- -- )
end

---@param ui PeepUI
function Lsp:configure(ui)
  self.ui = ui
end

return Lsp
