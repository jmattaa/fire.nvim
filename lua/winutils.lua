-- window utils

local M = {}

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

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true,
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

    vim.wo[win].winhighlight = "Normal:Normal,FloatBorder:Normal"

    return { buf = buf, win = win }
end

---@param pos winpos
---@return { buf: integer, win: integer }
function M.open(pos)
    if pos == "float" then
        return open_floating()
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, { split = pos })

    return { buf = buf, win = win }
end

return M
