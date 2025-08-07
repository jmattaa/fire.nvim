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
    window = {
        pos = "bottom",
        size = 10,
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

            local err = term.runcmd(command_to_run, M.options.window)
            if not err.ok then
                vim.notify(err.msg, vim.log.levels.ERROR)
            end
        end)
    end
end

function M.setup(opts)
    if opts then
        if not opts.leader then opts.leader = M.options.leader end -- ensure leader
        M.options = opts
    end

    set_mappings()
end

return M
