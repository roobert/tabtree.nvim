local M = {}

-- Helper function to determine if a given node is a target for navigation
local function is_target_node(bufnr, node)
	local node_type = node:type()
	local start_row, start_col, _, _ = node:range()
	local line_text = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
	local next_char = line_text:sub(start_col + 2, start_col + 2)

	-- Check if the node is an opening quote and is followed by a matching character or word character
	if
		(node_type == '"' or node_type == "'" or node_type == "`") and (next_char == node_type or next_char:match("%w"))
	then
		return true, 0
	end

	-- Check if the node is an opening bracket
	if node_type == "(" or node_type == "{" or node_type == "[" or node_type == "<" then
		return true, 0
	end

	-- Check if the node is the start of a Python f-string
	if node_type == "string_start" and line_text:sub(start_col + 1, start_col + 1) == "f" then
		return true, 1
	end

	-- Check if the node is the start of a generic string
	if node_type == "string_start" then
		return true, 0
	end

	-- Check if the node is the start of an interpolation
	if node_type == "interpolation" then
		return true, 0
	end

	-- If none of the above conditions are met, return false
	return false, 0
end

-- Function to jump to the next target node in the buffer
function M.jump_to_next_node()
	local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer number
	local parser = vim.treesitter.get_parser(bufnr) -- Initialize the Tree-sitter parser
	local tree = parser:parse()[1]

	if not tree then
		return -- If no tree is found, exit the function
	end

	-- Get the cursor's current line and column position
	local cursor_line = vim.fn.line(".") - 1
	local cursor_col = vim.fn.col(".") - 1
	local cursor_node = tree:root():descendant_for_range(cursor_line, cursor_col, cursor_line, cursor_col)

	local nodes = {}
	-- Recursive function to collect all nodes in the tree
	local function collect_nodes(node)
		table.insert(nodes, node)
		for child in node:iter_children() do
			collect_nodes(child)
		end
	end
	collect_nodes(tree:root())

	local found_cursor_node = false
	for _, node in ipairs(nodes) do
		local is_target, offset = is_target_node(bufnr, node)
		if found_cursor_node and is_target then
			local start_row, start_col, _, _ = node:range()
			-- Set the cursor to the target node's position
			vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col + offset })
			return
		end
		if node == cursor_node then
			found_cursor_node = true
		end
	end
end

-- Function to jump to the previous target node in the buffer
function M.jump_to_previous_node()
	-- Get the current buffer number
	local bufnr = vim.api.nvim_get_current_buf()
	-- Initialize the Tree-sitter parser
	local parser = vim.treesitter.get_parser(bufnr)
	local tree = parser:parse()[1]

	if not tree then
		return
	end

	-- Get the cursor's current line and column position
	local cursor_line = vim.fn.line(".") - 1
	local cursor_col = vim.fn.col(".") - 1
	local cursor_node = tree:root():descendant_for_range(cursor_line, cursor_col, cursor_line, cursor_col)
	local is_cursor_target, cursor_offset = is_target_node(bufnr, cursor_node)
	cursor_col = cursor_col - cursor_offset

	local nodes = {}
	-- Recursive function to collect all nodes in the tree
	local function collect_nodes(node)
		table.insert(nodes, node)
		for child in node:iter_children() do
			collect_nodes(child)
		end
	end
	collect_nodes(tree:root())

	local previous_target_node = nil
	local previous_offset = 0
	-- Iterate over the nodes in reverse to find the previous target node
	for i = #nodes, 1, -1 do
		local node = nodes[i]
		local is_target, offset = is_target_node(bufnr, node)
		local start_row, start_col, _, _ = node:range()
		if is_target and (start_row < cursor_line or (start_row == cursor_line and start_col < cursor_col)) then
			if previous_target_node then
				local start_row, start_col, _, _ = previous_target_node:range()
				-- Set the cursor to the previous target node's position
				vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col + previous_offset })
				return
			end
			previous_target_node = node
			previous_offset = offset
		end
	end
end

return M
