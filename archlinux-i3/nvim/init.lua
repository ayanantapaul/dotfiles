---------------------------------------------------------------------------------------------------
-- options 
----------------------------------------------------------------------------------------------------
vim.opt.termguicolors = true 
vim.cmd.colorscheme('unokai')
vim.api.nvim_set_hl(0, "Normal", {bg = "none"})		-- makes the background transparent 

vim.opt.number = true					-- line numbers 
vim.opt.relativenumber = true				-- relative line numbers 
vim.opt.cursorline = true				-- highlight cursor line 
vim.opt.wrap = false					-- don't wrap lines 
vim.opt.scrolloff = 10					-- keep some lines to the up/down of cursor while scrolling 
vim.opt.sidescrolloff = 10				-- keep some line to the left/right of the cursor 

vim.opt.tabstop = 8					-- tabwidth 
vim.opt.softtabstop = 8					-- i don't know what this is 
vim.opt.shiftwidth = 8					-- indent width 
vim.opt.expandtab = false				-- use tabs and not spaces 
vim.opt.smartindent = true				-- smart auto indent 
vim.opt.autoindent = true				-- auto indent

vim.opt.ignorecase = true				-- case insensitive search 
vim.opt.smartcase = true				-- case sensitive if upper case in string
vim.opt.hlsearch = true					-- highlight search matches 
vim.opt.incsearch = true				-- show matches as you type 

vim.opt.signcolumn = "yes"				-- sign column 
vim.opt.colorcolumn = "80"				-- show a column at 80 position character  
vim.opt.showmatch = true				-- highlight the matching brackets
vim.opt.cmdheight = 1					-- single line cmd line 
vim.opt.autocomplete = false
vim.opt.completeopt = "menu,menuone,noselect,popup"	-- completion options 
vim.opt.showmode = true					-- don't show mode instead have it in status line 
vim.opt.pumheight = 10					-- pop up menu height 
vim.opt.pumblend = 10					-- pop up menu transparency 
vim.opt.winblend = 0					-- floating window transparency
vim.opt.conceallevel = 0				-- don't hide markup
vim.opt.concealcursor = ""				-- don't hide corsorline in markup files
vim.opt.lazyredraw = true				-- do not redraw during macros  
vim.opt.synmaxcol = 300					-- syntax highlighting limit 
vim.opt.fillchars = {eob = " "}				-- hide "~" on empyty lines 
vim.g.have_nerd_font = true				-- true if u have a nerd font else false

vim.opt.backup = false					-- do not create a backup file 
vim.opt.writebackup = false				-- do not write a backup file 
vim.opt.swapfile = false				-- do not create a swapfile
vim.opt.updatetime = 300				-- faster completion 
vim.opt.timeoutlen = 500				-- timeout duration 
vim.opt.ttimeoutlen = 0					-- key code timeout 
vim.opt.autoread = true					-- auto reload changes if outside of neovim 
vim.opt.autowrite = false				-- do not auto save 
vim.opt.confirm = true 

vim.opt.hidden = true					-- allow hidden buffers 
vim.opt.errorbells = false				-- no error sound 
vim.opt.backspace = "indent,eol,start"			-- better backspace behaviour 
vim.opt.autochdir = false				-- do not auto change directories
vim.opt.iskeyword:append("-")				-- include - in words 
vim.opt.path:append("**")				-- include subdirectories in search 
vim.opt.selection = "inclusive"				-- include last char in selection 
vim.opt.mouse = "a"					-- enable mouse support 
vim.opt.clipboard:append("unnamedplus")			-- use system clipboard 
vim.opt.modifiable = true				-- allow buffer modification 
vim.opt.encoding = "UTF-8"				-- set encoding 

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver100,r-cr:hor20,o:hor50,a:blinkwait500-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- cursor blinking and settings

							-- folding: requires treesitter available at runtime; safe fall bck if not 
vim.opt.foldmethod = "expr"				-- use expression for folding 
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"	-- use treesitter for folding 
vim.opt.foldlevel = 99					-- start with all folders open 

vim.opt.wildmenu = true					-- tab completion 
vim.opt.wildmode = "longest:full,full"			-- complete largest common match, full completion list, cycle through wiyh Tab
vim.opt.diffopt:append("linematch:60")			-- improve diff display 
vim.opt.redrawtime = 10000				-- increase neovim redraw tolerance 
vim.opt.maxmempattern = 20000				-- increase max memory 

----------------------------------------------------------------------------------------------------
-- keymaps 
----------------------------------------------------------------------------------------------------

vim.g.mapleader = ' '					-- set <space> as the local leader 
vim.g.maplocalleader = ' '				-- set <space> as the map local leader 
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle file explorer' }) -- file explorer : Neotree

----------------------------------------------------------------------------------------------------
-- plugin manager (vim.pack)
----------------------------------------------------------------------------------------------------

do 
	local function run_build(name, cmd, cwd)
		local result = vim.system(cmd, { cwd = cwd }):wait()
		if result.code ~= 0 then 
			local stderr = result.stderr or ''
			local stdout = result.stdout or ''
			local output = stderr ~= '' and stderr or stdout
			if output == '' then output = 'No output from build command.' end 
			vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
		end
	end

	vim.api.nvim_create_autocmd('PackChanged', {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind
			if kind ~= 'install' and kind ~= 'update' then return end 

			if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
				run_build(name, { 'make' }, ev.data.path)
				return 
			end

			if name == 'LuaSnip' then 
				if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
				return 
			end

			if name == 'nvim-treesitter' then 
				if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
				vim.cmd 'TSUpdate'
				return 
			end
		end,
	})
end

----------------------------------------------------------------------------------------------------
-- plugins 
----------------------------------------------------------------------------------------------------

-- no plugins added
