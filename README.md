# 🌲 TabTree

![TabTree Demo](https://github.com/roobert/tabtree.nvim/assets/226654/d04dcc45-b0f2-4e12-aaca-8dd95467fbf9)

## Overview

TabTree is a Neovim plugin designed to enhance navigation within code by leveraging the power of Tree-sitter. It allows users to jump between significant code elements, such as brackets, quotes, and special string literals (e.g., f-strings in Python), with simple keybindings.

## Usage

### Keys

Default key bindings for Normal mode, these should not interfere with `nvim-cmp` which
operates in Insert mode:

| Key       | Action                          |
| --------- | ------------------------------- |
| `<Tab>`   | `require('tabtree').next()`     |
| `<S-Tab>` | `require('tabtree').previous()` |

### LazyVim Installation

```lua
  {
    "roobert/tabtree.nvim",
    config = function()
      require("tabtree").setup()
    end,
  },
```

### Configuration

```lua
  {
    "roobert/tabtree.nvim",
    config = function()
      require("tabtree").setup({
        -- disable key bindings
        --key_bindings_disabled = true,

        -- Override default keybindings
        key_bindings = {
          next = "<Tab>",
          previous = "<S-Tab>",
          --next = "<M-Right>",
          --previous = "<M-Left>",
        },
      })
    end,
  },
```

## References

Inspired by [abecodes/tabout.nvim](https://github.com/abecodes/tabout.nvim).
