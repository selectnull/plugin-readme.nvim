local Module = {}

local lazy = require "lazy"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"

local function create_url(plugin_name)
  return "https://github.com/" .. plugin_name
end

local function open_repo_in_browser(url)
  local open_cmd
  if vim.fn.has "mac" == 1 then
    open_cmd = "open"
  elseif vim.fn.has "unix" == 1 then
    open_cmd = "xdg-open"
  elseif vim.fn.has "win32" == 1 then
    open_cmd = "start"
  else
    print "Unsupported operating system"
    return
  end

  vim.fn.system(open_cmd .. " " .. url)
end

local function filter_plugins(items)
  pickers
    .new({}, {
      prompt_title = "Select a plugin",
      finder = finders.new_table {
        results = items,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
            path = entry.preview_path,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        -- the user presses enter
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            open_repo_in_browser(create_url(selection.display))
          end
        end)
        return true
      end,
      previewer = previewers.new_buffer_previewer {
        title = "README Preview",
        define_preview = function(self, entry, status)
          local content = vim.fn.readfile(entry.path)

          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)
          vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "markdown")
        end,
      },
    })
    :find()
end

Module.select_plugin = function()
  local plugin_names = {}
  for idx, ip in pairs(lazy.plugins()) do
    local name = getmetatable(ip).__index[1]
    table.insert(plugin_names, { name = name, preview_path = ip.dir .. "/README.md" })
  end
  filter_plugins(plugin_names)
end

return Module
