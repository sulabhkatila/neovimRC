vim.g.mapleader = " "

vim.keymap.set("n", "<C-b>", vim.cmd.Ex)
-- vim.keymap.set("i", "kj", "<Esc>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "<leader>w", vim.cmd.w)
vim.keymap.set("n", "<C-w>", vim.cmd.w)
vim.keymap.set("n", "<leader>q", vim.cmd.wq)

-- Indent the selected block by pressing Tab in visual mode
vim.keymap.set("v", "<Tab>", ">gv")

-- Unindent the selected block by pressing Shift-Tab in visual mode
vim.keymap.set("v", "<S-Tab>", "<gv")

vim.keymap.set("n", "<C-}", "<C-}>zz")
vim.keymap.set("n", "<C-{", "<C-t>zz")

vim.api.nvim_create_user_command("EnableCopilot", function()
	vim.b.copilot_enabled = 1
	print("Copilot enabled")
end, {})

vim.api.nvim_create_user_command("DisableCopilot", function()
	vim.b.copilot_enabled = 0
	print("Copilot disabled")
end, {})

-- Toggle Copilot
vim.api.nvim_create_user_command("ToggleCopilot", function()
	if vim.b.copilot_enabled == 0 then
		vim.cmd("EnableCopilot")
	else
		vim.cmd("DisableCopilot")
	end
end, {})

vim.keymap.set("n", "<C-m>", function()
	vim.cmd("ToggleCopilot")
end, { noremap = true, silent = true })

-- Split navigations
-- vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
-- vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
-- vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
-- vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
