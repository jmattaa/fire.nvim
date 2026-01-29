local M = {}

local winutils = require "winutils"

---@class runcmderr
---@field ok boolean
---@field msg string

---@param cmd string
---@param opts fireopts
---@return runcmderr
function M.runcmd(cmd, opts)
    if not cmd then return { ok = false, msg = "cmd is nil" } end
    local valid_pos = { "left", "right", "above", "below", "float" }
    if not vim.tbl_contains(valid_pos, opts.win.pos) then
        return { ok = false, msg = "invalid winpos" }
    end

    local winbuf = winutils.open(opts.win.pos)
    if opts.win.pos == "left" or opts.win.pos == "right" then
        vim.api.nvim_win_set_width(winbuf.win, opts.win.size)
    end
    if opts.win.pos == "above" or opts.win.pos == "below" then
        vim.api.nvim_win_set_height(winbuf.win, opts.win.size)
    end

    vim.api.nvim_set_current_buf(winbuf.buf)
    vim.fn.termopen(cmd, {
        on_exit = function()
            vim.schedule(function()
                vim.cmd("stopinsert")
            end)
        end,
    })
    vim.cmd("startinsert")

    if opts.win.kill_buffer_on_close then vim.bo.bufhidden = "wipe" end

    return { ok = true, msg = "" }
end

return M
