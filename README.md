<div align="center">

# fire.nvim 🔥

###### fire commands at neovim

</div>

- [fire.nvim 🔥](#firenvim-)
   * [What is this? ](#what-is-this)
   * [Installation](#installation)
   * [Configuration](#configuration)
   * [Usage](#usage)


## What is this? 
It's a simple plugin to quickly open a term window and run commands in it.
And thats it! The idea came from the em**s 
[projectile](https://github.com/bbatsov/projectile) package, where you could
run commands for a project, I never used it but I liked the idea.

## Installation

Note that you must call the setup function for the plugin to work

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use('jmattaa/fire.nvim')
require('fire').setup {} -- uses default config
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
    "jmattaa/fire.nvim",
    config = function()
        require('fire').setup {}
    end
}
```

## Configuration

here is the default configuration
```lua
require('fire').setup {
    leader = "<leader>f", -- the prefix key for triggering fire commands (e.g., <leader>fr for "run")

    win = {
        pos = "bottom", -- position of the terminal window:
                        -- "top", "bottom", "left", "right", or "float"
        size = 10,      -- size of the terminal window:
                        -- if the window is horizontal (top/bottom), size = height in lines
                        -- if vertical (left/right), size = width in columns
                        -- ignored if pos = "float"
        kill_buffer_on_close = true -- if true, the terminal buffer will be deleted when the window is closed.
    },

    commands = {
        r = "run",      -- <leader>fr will run the "run" command from your .firecmds
        b = "build",    -- <leader>fb -> "build"
        t = "test",     -- <leader>ft -> "test"
        d = "debug",    -- <leader>fd -> "debug"

        -- you can define any number of custom commands here.
        -- these are simply aliases that map to commands defined in your `.firecmds` file.
        -- for example:
        -- a = "deploy" -- <leader>fa will run the "deploy" command from .firecmds
    }
}

```

## Usage
By just typing `<leader>fr`, using the default configuration the program will
prompt to asking what command you'd like to associate with the keybinding. 
It will then create a `.firecmds` file where your commands will be stored.

You can edit the `.firecmds` file by hand if you'd like, or just use the 
keybinds to let the program prompt you and automatically create the file for 
you.

An example of what the `.firecmds` file might look like:
```
run echo "run commands"
build gcc main.c
test echo "test commands"
debug echo "debug commands"
```
