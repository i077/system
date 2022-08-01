if (vim.g['vscode'] == nil) then
  require('lualine').setup {
    options = {theme = 'auto', component_separators = '', section_separators = ''},

    sections = {
      lualine_a = {
        -- Only show the first character of the current mode
        {'mode', fmt = function(str) return str:sub(1, 1) end}
      },
      lualine_b = {'branch'},
      lualine_c = {{'filename', path = 1}, 'diff'},
      lualine_x = {'encoding', 'filetype'},
      lualine_y = {'diagnostics', 'progress'},
      lualine_z = {'location'}
    },

    tabline = {
      lualine_a = {
        {'tabs', tabs_color = {active = 'lualine_a_normal', inactive = 'lualine_b_normal'}}
      },
      lualine_z = {
        {'windows', windows_color = {active = 'lualine_a_normal', inactive = 'lualine_b_normal'}}
      }
    }
  }
end
