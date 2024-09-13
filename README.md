# plugin-readme

When you mess with the Neovim configuration (instead of working),
it's often needed to read the plugin documentation. This plugin
attempts to make that easier.

List all installed plugins and preview their README file.
Press ENTER and open the plugin github repository in a browser.

## Requirements

* Neovim >= 0.10 (haven't tested it with lower versions)
* Lazy.nvim

## Installation

For now, it supports only `lazy.nvim`.

    {
        "selectnull/plugin-readme.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local readme = require "plugin-readme"
            vim.keymap.set("n", "<leader>p", readme.select_plugin, {})
        end,
    }
