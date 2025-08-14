-- window utils

local M = {}

local state = {
    buf = nil,
    win = nil
}

-- opens a centered floating window in
--
-- @param opts (table) optional settings:
--   - height (number): Height of the window in lines.
--   - width (number): Width of the window in columns.
--   - p (number): Percentage (0–1) of the screen to use for both width and
--                 height if `height` and `width` are not explicitly set.
--                 Defaults to 0.6
---@return { buf: integer, win: integer }
local function open_floating(opts)
    opts = opts or {}

    local width = opts.width or math.floor(vim.o.columns * (opts.p or 0.6))
    local height = opts.height or math.floor(vim.o.lines * (opts.p or 0.6))

    -- to center
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    state.win = vim.api.nvim_open_win(state.buf, true,
        {
            style = "minimal",
            relative = "editor",
            width = width,
            height = height,
            row = row,
            col = col,
            border = "rounded",
        }
    )

    return { buf = state.buf, win = state.win }
end

---@param pos winpos
---@return { buf: integer, win: integer }
function M.open(pos)
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        -- close and reopen buffer
        vim.api.nvim_buf_delete(state.buf, { force = true })
    end
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        -- close and reopen window
        vim.api.nvim_win_close(state.win, true)
    end

    state.buf = vim.api.nvim_create_buf(true, false)
    if pos == "float" then
        return open_floating()
    end
    state.win = vim.api.nvim_open_win(state.buf, true, {
        split = pos,
        style = "minimal"
    })

    return { buf = state.buf, win = state.win }
end

return M
