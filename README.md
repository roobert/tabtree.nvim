# 🌲 TabTree

## Overview

TabTree is a Vim plugin designed to enhance navigation within code by leveraging the power of Tree-sitter. It allows users to jump between significant code elements, such as brackets, quotes, and special string literals (e.g., f-strings in Python), with simple keybindings.

## Usage

Default key bindings for Normal mode:

| Key       | Action                          |
| --------- | ------------------------------- |
| `<Tab>`   | `require('tabtree').next()`     |
| `<S-Tab>` | `require('tabtree').previous()` |

## Installation

### LazyVim

```lua
  { "roobert/tabtree.nvim" }
```

### Configuration

```lua
  {
    "roobert/tabtree.nvim",
    config = function()
      require("tabtree").setup({
        -- disable key bindings
        -- key_bindings_disabled = true,

        -- Override default keybindings
        key_bindings = {
          next = "<M-Right>",
          previous = "<M-Left>",
        },
      })
    end,
  }
```

## References

Inspired by [abecodes/tabout.nvim](https://github.com/abecodes/tabout.nvim).
