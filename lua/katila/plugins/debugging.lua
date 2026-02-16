return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Setup dap-ui
		dapui.setup({
			controls = {
				enabled = true,
				element = "repl",
				icons = {
					pause = "",
					play = "",
					step_into = "",
					step_over = "",
					step_out = "",
					stop = "",
				},
			},
		})

		-- Setup Go debugging
		require("dap-go").setup()

		-- Setup Python debugging
		local function get_python_path()
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python3"
			else
				return "python3" -- fallback to system python
			end
		end

		require("dap-python").setup(get_python_path())

		-- Auto-open/close UI with dap events
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Keybindings
		local map = vim.keymap.set
		map("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		map("n", "<leader>dc", dap.continue, { desc = "Start/Continue Debugging" })
		map("n", "<leader>dr", dap.repl.open, { desc = "Open DAP REPL" })
		map("n", "<leader>dl", dap.run_last, { desc = "Run Last Debugging Session" })
		map("n", "<leader>dx", dap.terminate, { desc = "Terminate Debugging" })
		map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
	end,
}
