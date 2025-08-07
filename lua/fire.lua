-- FIRE 🔥 fire commands at neovim!!
local M = {}

local term = require("term")

---@alias winpos "left" | "right" | "top" | "bottom" | "float"

-- default options but you could defenetly add other scripts with other names
---@class fireopts
---@field leader string?
---@field win {
---pos: winpos?,
---size: number?,
---kill_buffer_on_close: boolean?,
---}?
---@field commands table?
M.options = {
    leader = "<leader>f",
    win = {
        pos = "bottom",
        size = 10,
        kill_buffer_on_close = true
    },
    commands = {
        r = "run",
        b = "build",
        t = "test",
        d = "debug",
    }
}

local function set_mappings()
    for k, v in pairs(M.options.commands) do
        vim.keymap.set("n", M.options.leader .. k, function()
            local cwd = vim.fn.getcwd()
            local filepath = cwd .. "/.firecmds"
            local file = io.open(filepath, "r")

            if not file then
                file = io.open(filepath, "w")
                if not file then
                    vim.notify("Unable to create " .. filepath, vim.log.levels.ERROR)
                    return
                end
                file:close()
                file = io.open(filepath, "r")
                if not file then
                    return
                end
            end

            local commands = {}
            for line in file:lines() do
                local cmd, value = line:match("^(%S+)%s+(.+)$")
                if cmd and value then
                    commands[cmd] = value
                end
            end
            file:close()

            local command_to_run = commands[v]
            if not command_to_run then
                command_to_run =
                    vim.fn.input("Command for " .. v .. ": ")
                if command_to_run == "" then
                    return
                end
                file = io.open(filepath, "a")
                if not file then
                    vim.notify("Unable to open " .. filepath, vim.log.levels.ERROR)
                    return
                end
                file:write(v .. " " .. command_to_run .. "\n")
                file:close()
            end

            local err = term.runcmd(command_to_run, M.options)
            if not err.ok then
                vim.notify(err.msg, vim.log.levels.ERROR)
            end
        end)
    end
end

---@param defaults table
---@param user table
local function tbl_merge(defaults, user)
    for k, v in pairs(user) do
        if type(v) == "table" and type(defaults[k]) == "table" then
            tbl_merge(defaults[k], v)
        else
            defaults[k] = v
        end
    end
end

---@param opts fireopts
function M.setup(opts)
    if opts then
        tbl_merge(M.options, opts)
    end

    set_mappings()
end

return M
