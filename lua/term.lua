local M = {}

local winutils = require("winutils")

---@class runcmderr
---@field ok boolean
---@field msg string

---@param cmd string
---@param winpos "left" | "right" | "top" | "bottom" | "float"
---@return runcmderr
function M.runcmd(cmd, winpos)
    if not cmd then return { ok = false, msg = "cmd is nil" } end
    local valid_pos = { "left", "right", "top", "bottom", "float" }
    if not vim.tbl_contains(valid_pos, winpos) then
        return { ok = false, msg = "invalid winpos" }
    end

    local winbuf
    if winpos == "float" then
        winbuf = winutils.open_floating()
    else
        winbuf = winutils.open(winpos)
    end

    vim.bo[winbuf.buf].bufhidden = "wipe" -- why ain't ts working? 
    vim.cmd("term " .. cmd)

    return { ok = true, msg = "" }
end

return M
