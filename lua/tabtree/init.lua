local M = {}
local config = require("tabtree.config")

local function get_language_config(lang)
	local lang_config = config.options.language_configs[lang] or config.options.default_config
	return lang_config.target_query, lang_config.offsets
end

function M.setup(options)
	if options == nil then
		options = {}
	end

	for k, v in pairs(options) do
		config.options[k] = v
	end

	if config.options["key_bindings_disabled"] == true then
		return
	end

	vim.api.nvim_set_keymap(
		"n",
		config.options.key_bindings["next"],
		":lua require('tabtree').next()<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		config.options.key_bindings["previous"],
		":lua require('tabtree').previous()<CR>",
		{ noremap = true, silent = true }
	)
end

local function move_cursor(capture, node, offsets, query)
	local capture_name = query.captures[capture] or ""
	local start_row, start_col, _, _ = node:range()
	local offset = offsets[capture_name] or 0
	if config.options.debug then
		print("capture_name: " .. capture_name .. " offset: " .. offset)
	end
	vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col + offset })
end

function M.next()
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local lang = vim.treesitter.language.get_lang(ft)
  if lang == nil then
    error("no parsers found for ".. ft)
    return
  end
	local target_query, offsets = get_language_config(lang)
	local parser = vim.treesitter.get_parser(bufnr, lang)
	local tree = parser:parse()[1]
	local cursor_line = vim.fn.line(".") - 1
	local cursor_col = vim.fn.col(".") - 1
	local query = vim.treesitter.query.parse(lang, target_query)

	for capture, node in query:iter_captures(tree:root(), bufnr) do
		local start_row, start_col, _, _ = node:range()
		if start_row > cursor_line or (start_row == cursor_line and start_col > cursor_col) then
			move_cursor(capture, node, offsets, query)
			return
		end
	end
end

function M.previous()
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local lang = vim.treesitter.language.get_lang(ft)
  if lang == nil then
    error("no parsers found for ".. ft)
    return
  end
	local target_query, offsets = get_language_config(lang)
	local parser = vim.treesitter.get_parser(bufnr, lang)
	local tree = parser:parse()[1]
	local cursor_line = vim.fn.line(".") - 1
	local cursor_col = vim.fn.col(".") - 1
	local query = vim.treesitter.query.parse(lang, target_query)
	local nodes = {}
	local captures = {}

	for capture, node in query:iter_captures(tree:root(), bufnr) do
		table.insert(nodes, 1, node) -- insert at the beginning
		table.insert(captures, 1, capture) -- insert at the beginning
	end

	for i = 1, #nodes do
		local node = nodes[i]
		local capture = captures[i]
		local start_row, start_col, _, _ = node:range()
		if start_row < cursor_line or (start_row == cursor_line and start_col < cursor_col) then
			move_cursor(capture, node, offsets, query)
			return
		end
	end
end

return M
