# 🌲 TabTree

![TabTree Demo](https://github.com/roobert/tabtree.nvim/assets/226654/d04dcc45-b0f2-4e12-aaca-8dd95467fbf9)

## Overview

TabTree is a Neovim plugin designed to enhance navigation within code by leveraging the power of Tree-sitter. It allows users to jump between significant code elements, such as brackets, quotes, etc.

Additional language configs welcome as PRs!

## Usage

### Keys

Default key bindings for `Normal` mode, these should not interfere with `nvim-cmp`
`Insert` mode bindings:

| Key       | Action                          |
| --------- | ------------------------------- |
| `<Tab>`   | `require('tabtree').next()`     |
| `<S-Tab>` | `require('tabtree').previous()` |

### Installation

LazyVim example:

```lua
  {
    "roobert/tabtree.nvim",
    config = function()
      require("tabtree").setup()
    end,
  },
```

### Configuration

Override any configuration option by passing an options table to the setup function:

```lua
  {
    "roobert/tabtree.nvim",
    config = function()
      require("tabtree").setup({
        -- print the capture group name when executing next/previous
        --debug = true,

        -- disable key bindings
        --key_bindings_disabled = true,

        key_bindings = {
          next = "<Tab>",
          previous = "<S-Tab>",
        },

        -- use TSPlaygroundToggle to discover the (capture group)
        -- @capture_name can be anything
        language_configs = {
          python = {
            target_query = [[
              (string) @string_capture
              (interpolation) @interpolation_capture
              (parameters) @parameters_capture
              (argument_list) @argument_list_capture
            ]],
            -- experimental feature, to move the cursor in certain situations like when handling python f-strings
            offsets = {
              string_start_capture = 1,
            },
          },
        },

        default_config = {
          target_query = [[
              (string) @string_capture
              (interpolation) @interpolation_capture
              (parameters) @parameters_capture
              (argument_list) @argument_list_capture
          ]],
          offsets = {},
        }
      })
    end,
  },
```

## References

Inspired by [abecodes/tabout.nvim](https://github.com/abecodes/tabout.nvim).
