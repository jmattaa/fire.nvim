-- FIRE 🔥 fire commands at neovim!!
--
-- todo maybe make this a plugin?
-- the .firecmds file contains a list of commands to run with the value of the
-- keybinding in opts (the name of the command) being the key in the
-- .firecmds file
-- NOTE: stop a process with :bd!
local M = {}

local term = require("term")

-- default options but you could defenetly add other scripts with other names
M.options = {
    leader = "<leader>f",
    winpos = "left",
    r = "run",
    b = "build",
    t = "test",
    d = "debug",
}

function M.setup(opts)
    if opts then
        if not opts.leader then opts.leader = M.options.leader end -- ensure leader
        M.options = opts
    end

    -- set up mappings for the commands, find the command in .firecmds file
    for k, v in pairs(M.options) do
        if k == "leader" then goto continue end

        vim.keymap.set("n", M.options.leader .. k, function()
            local cwd = vim.fn.getcwd()
            local filepath = cwd .. "/.firecmds"
            local file = io.open(filepath, "r")
            if not file then
                vim.notify(".firecmds file not found", vim.log.levels.ERROR)
                return
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
                vim.notify("Command '" .. v .. "' not found in .firecmds", vim.log.levels.ERROR)
                return
            end

            term.runcmd(command_to_run, M.options.winpos)
        end)
        ::continue::
    end
end

return M

