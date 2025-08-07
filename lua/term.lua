local M = {}

local winutils = require("winutils")

---@class runcmderr
---@field ok boolean
---@field msg string

---@class windowopts
---@field pos string
---@field size number

---@param cmd string
---@param winopts windowopts
---@return runcmderr
function M.runcmd(cmd, winopts)
    if not cmd then return { ok = false, msg = "cmd is nil" } end
    local valid_pos = { "left", "right", "top", "bottom", "float" }
    if not vim.tbl_contains(valid_pos, winopts.pos) then
        return { ok = false, msg = "invalid winpos" }
    end

    local winbuf
    if winopts.pos == "float" then
        winbuf = winutils.open_floating()
    else
        winbuf = winutils.open(winopts.pos)
        if winopts.pos == "left" or winopts.pos == "right" then
            vim.api.nvim_win_set_width(winbuf.win, winopts.size)
        else
            vim.api.nvim_win_set_height(winbuf.win, winopts.size)
        end
    end

    vim.bo[winbuf.buf].bufhidden = "wipe" -- why ain't ts working? 
    vim.cmd("term " .. cmd)

    return { ok = true, msg = "" }
end

return M
