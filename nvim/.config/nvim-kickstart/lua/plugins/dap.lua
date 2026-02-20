return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			-- Language specific helpers
			"mfussenegger/nvim-dap-python",
			"leoluz/nvim-dap-go",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("dapui").setup()
			require("nvim-dap-virtual-text").setup()

			-- Automatically open/close UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			---------------------------------------------------------
			-- Python Configuration
			---------------------------------------------------------
			-- Uses debugpy installed via Mason
			local function get_python_path()
				local venv = os.getenv("VIRTUAL_ENV")
				if venv then
					return venv .. "/bin/python"
				end
				return vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			end
			require("dap-python").setup(get_python_path())

			---------------------------------------------------------
			-- Go Configuration
			---------------------------------------------------------
			-- Uses delve installed via Mason
			require("dap-go").setup()

			---------------------------------------------------------
			-- C / C++ / Rust Configuration
			---------------------------------------------------------
			-- Uses codelldb installed via Mason
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					-- Check your mason path if this fails
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			-- Reuse C++ config for C and Rust
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

			---------------------------------------------------------
			-- Keymaps for Debugging
			---------------------------------------------------------
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Breakpoint with Condition" })
			vim.keymap.set("n", "<leader>bc", function()
				dap.clear_breakpoints()
			end, { desc = "Debug: [C]lear all breakpoints" })
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
			vim.keymap.set("n", "<leader>dq", function()
				dap.terminate() -- Kill the debug process
				dapui.close() -- Manually close the UI
			end, { desc = "Debug: [Q]uit session" })

			-- vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			-- vim.fn.sign_define(
			-- 	"DapBreakpointCondition",
			-- 	{ text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
			-- )
			-- vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DapStopped", linehl = "Visual", numhl = "" })
		end,
	},
}
