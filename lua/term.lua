local M = {}

local winutils = require("winutils")

---@class runcmderr
---@field ok boolean
---@field msg string

---@param cmd string
---@param opts fireopts
---@return runcmderr
function M.runcmd(cmd, opts)
    if not cmd then return { ok = false, msg = "cmd is nil" } end
    local valid_pos = { "left", "right", "top", "bottom", "float" }
    if not vim.tbl_contains(valid_pos, opts.win.pos) then
        return { ok = false, msg = "invalid winpos" }
    end

    local winbuf
    if opts.win.pos == "float" then
        winbuf = winutils.open_floating()
    else
        winbuf = winutils.open(opts.win.pos)
        if opts.win.pos == "left" or opts.win.pos == "right" then
            vim.api.nvim_win_set_width(winbuf.win, opts.win.size)
        else
            vim.api.nvim_win_set_height(winbuf.win, opts.win.size)
        end
    end

    vim.cmd("term " .. cmd)
    if opts.win.kill_buffer_on_close then vim.bo.bufhidden = "wipe" end

    return { ok = true, msg = "" }
end

return M
