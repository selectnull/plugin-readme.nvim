# plugin-readme

List all installed plugins and preview their README file.
Press ENTER and open the plugin github repository in a browser.

## Requirements

* Neovim >= 0.10
* Lazy.nvim

## Installation

For now, it supports only `lazy.nvim`.

    {
        "selectnull/plugin-readme.nvim",
        config = function()
            local readme = require "plugin-readme"
            vim.keymap.set("n", "<leader>p", readme.select_plugin, {})
        end,
    }
