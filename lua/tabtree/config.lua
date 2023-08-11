local M = {}

M.options = {
	debug = false,
	key_bindings = {
		next = "<Tab>",
		previous = "<S-Tab>",
	},
	language_configs = {
		python = {
			target_query = [[
				(string) @string_capture
				(interpolation) @interpolation_capture
				(parameters) @parameters_capture
				(argument_list) @argument_list_capture
			]],
			offsets = {
				string_start_capture = 1,
			},
		},
	},
	default_config = {
		target_query = [[]],
		offsets = {},
	},
}

return M
