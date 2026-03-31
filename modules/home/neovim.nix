{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      rust-analyzer
      nixd
      bash-language-server
      yaml-language-server
      rustfmt
      nixfmt
      gcc
      ripgrep
      lldb
    ];

    plugins = with pkgs.vimPlugins; [
      alpha-nvim
      nvim-web-devicons
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      (nvim-treesitter.withPlugins (
        p: with p; [
          rust
          nix
          bash
          yaml
          toml
          json
          lua
        ]
      ))
      telescope-nvim
      plenary-nvim
      neo-tree-nvim
      nui-nvim
      vim-fugitive
      lualine-nvim
      crates-nvim
      cord-nvim
      which-key-nvim
      trouble-nvim
      nvim-surround
      nvim-notify
      nvim-dap
      nvim-dap-ui
      conform-nvim
      nvim-autopairs
      gitsigns-nvim
      todo-comments-nvim
      toggleterm-nvim
    ];

    initLua = ''
      -- Leader
      vim.g.mapleader = " "

      -- --- OPZIONI CORE ---
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.number = true
      vim.opt.termguicolors = true
      vim.opt.wrap = true
      vim.opt.linebreak = true
      vim.opt.scrolloff = 8
      vim.opt.updatetime = 250

      -- --- NOTIFICHE BELLE (nvim-notify) ---
      local notify = require("notify")
      vim.notify = notify
      notify.setup({
        background_colour = "#000000",
        stages = "fade",
        timeout = 3000,
      })

      -- Trasparenza
      local hl_groups = { "Normal", "NormalFloat", "NormalNC", "SignColumn", "EndOfBuffer", "NeoTreeNormal", "NeoTreeNormalNC" }
      for _, group in ipairs(hl_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end

      -- Helper Keymaps
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      -- --- KEYBINDS EVIEVIM ---
      map("n", "<C-a>", "ggVG", "Select all")
      map("v", "<C-c>", '"+y', "Copy")
      map("v", "<C-x>", '"+x', "Cut")
      map("n", "<C-v>", '"+p', "Paste")
      map("i", "<C-v>", '<C-r>+', "Paste")
      map("n", "<C-z>", "u", "Undo")
      map("n", "<C-y>", "<C-r>", "Redo")
      map("n", "<C-t>", ":Neotree toggle<CR>", "Toggle tree")
      map("n", "<C-q>", ":Alpha<CR>", "Dashboard")
      map("n", "<leader>f", function() vim.lsp.buf.format() end, "Format file")
      map("n", "<Down>", "gj", "Move down")
      map("n", "<Up>", "gk", "Move up")

      -- --- WHICH-KEY ---
      local wk = require("which-key")
      wk.setup({ delay = 0 })
      map("n", "<C-k>", "<cmd>WhichKey<cr>", "Show Keybinds Popup")

      -- LSP Keybinds
      map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
      map("n", "gr", vim.lsp.buf.references, "Go to References")
      map("n", "K", vim.lsp.buf.hover, "Hover Doc")
      map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
      map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

      -- Trouble
      map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics")
      map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics")

      -- DAP
      map("n", "<leader>db", function() require('dap').toggle_breakpoint() end, "Toggle Breakpoint")
      map("n", "<leader>dc", function() require('dap').continue() end, "Continue")
      map("n", "<leader>ds", function() require('dap').step_over() end, "Step Over")
      map("n", "<leader>di", function() require('dap').step_into() end, "Step Into")
      map("n", "<leader>du", function() require('dapui').toggle() end, "Toggle DAP UI")

      -- --- TERMINALE (toggleterm) ---
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<C-j>]],
        direction = "horizontal",
        shade_terminals = true,
        start_insert = true,
        persist_size = true,
      })

      -- In modalità terminale, Ctrl+J per chiudere/nascondere
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], { silent = true, desc = "Toggle terminal" })

      -- --- CONFORM (Format on Save) ---
      require("conform").setup({
        formatters_by_ft = {
          nix  = { "nixfmt" },
          rust = { "rustfmt" },
          sh   = { "shfmt" },
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_fallback = true,
        },
      })

      -- --- AUTOPAIRS ---
      require("nvim-autopairs").setup({
        check_ts = true, -- usa treesitter per contesto
      })
      -- Integrazione con cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- --- GITSIGNS ---
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local bmap = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, silent = true, desc = desc })
          end
          bmap("n", "]c", gs.next_hunk, "Next Hunk")
          bmap("n", "[c", gs.prev_hunk, "Prev Hunk")
          bmap("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
          bmap("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
          bmap("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
          bmap("n", "<leader>hb", gs.blame_line, "Blame Line")
        end,
      })

      -- --- TODO COMMENTS ---
      require("todo-comments").setup()
      map("n", "<leader>td", "<cmd>TodoTelescope<cr>", "Find TODOs")

      -- --- CRATES ---
      require("crates").setup({
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      })

      -- --- DASHBOARD (ALPHA) ---
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')
      dashboard.section.header.val = {
        "                                                   ",
        " \u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2557}\u{2588}\u{2588}\u{2557}   \u{2588}\u{2588}\u{2557}\u{2588}\u{2588}\u{2557}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2557}\u{2588}\u{2588}\u{2557}   \u{2588}\u{2588}\u{2557}\u{2588}\u{2588}\u{2557}\u{2588}\u{2588}\u{2588}\u{2557}   \u{2588}\u{2588}\u{2588}\u{2557}",
        " \u{2588}\u{2588}\u{2554}\u{2550}\u{2550}\u{2550}\u{2550}\u{255D}\u{2588}\u{2588}\u{2551}   \u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2554}\u{2550}\u{2550}\u{2550}\u{2550}\u{255D}\u{2588}\u{2588}\u{2551}   \u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2588}\u{2588}\u{2557} \u{2588}\u{2588}\u{2588}\u{2588}\u{2551}",
        " \u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2557}  \u{2588}\u{2588}\u{2551}   \u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2557}  \u{2588}\u{2588}\u{2551}   \u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2554}\u{2588}\u{2588}\u{2588}\u{2588}\u{2554}\u{2588}\u{2588}\u{2551}",
        " \u{2588}\u{2588}\u{2554}\u{2550}\u{2550}\u{255D}  \u{255A}\u{2588}\u{2588}\u{2557} \u{2588}\u{2588}\u{2554}\u{255D}\u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2554}\u{2550}\u{2550}\u{255D}  \u{255A}\u{2588}\u{2588}\u{2557} \u{2588}\u{2588}\u{2554}\u{255D}\u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2551}\u{255A}\u{2588}\u{2588}\u{2554}\u{255D}\u{2588}\u{2588}\u{2551}",
        " \u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2557} \u{255A}\u{2588}\u{2588}\u{2588}\u{2588}\u{2554}\u{255D} \u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2557} \u{255A}\u{2588}\u{2588}\u{2588}\u{2588}\u{2554}\u{255D} \u{2588}\u{2588}\u{2551}\u{2588}\u{2588}\u{2551} \u{255A}\u{2550}\u{255D} \u{2588}\u{2588}\u{2551}",
        " \u{255A}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{255D}  \u{255A}\u{2550}\u{2550}\u{2550}\u{255D}  \u{255A}\u{2550}\u{255D}\u{255A}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{255D}  \u{255A}\u{2550}\u{2550}\u{2550}\u{255D}  \u{255A}\u{2550}\u{255D}\u{255A}\u{2550}\u{255D}     \u{255A}\u{2550}\u{255D}",
        "                                                   ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("e", "\u{f15b}  New file",     ":enew<CR>"),
        dashboard.button("f", "\u{f002}  Find file",    ":Telescope find_files<CR>"),
        dashboard.button("r", "\u{f7d9}  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("g", "\u{f422}  Find word",    ":Telescope live_grep<CR>"),
        dashboard.button("q", "\u{f011}  Quit",         ":qa<CR>"),
      }
      alpha.setup(dashboard.config)

      -- --- LSP SETUP ---
      local caps = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('nixd', {
        capabilities = caps,
        settings = { nixd = { formatting = { command = { "nixfmt" } } } }
      })
      vim.lsp.config('rust_analyzer', { capabilities = caps })
      vim.lsp.config('bashls', { capabilities = caps })
      vim.lsp.config('yamlls', { capabilities = caps })
      vim.lsp.enable({ 'nixd', 'rust_analyzer', 'bashls', 'yamlls' })

      -- --- COMPLETION ---
      cmp.setup({
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item() else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({{ name = 'nvim_lsp' }, { name = 'luasnip' }, { name = 'crates' }}, {{ name = 'buffer' }})
      })

      -- --- ALTRI PLUGIN ---
      require('lualine').setup()
      require('neo-tree').setup({ filesystem = { follow_current_file = { enabled = true } } })
      require('telescope').setup()
      require('cord').setup({})
      require('nvim-surround').setup()
      require('trouble').setup()

      -- DAP UI
      require('dapui').setup()
      local dap = require('dap')
      dap.listeners.after.event_initialized['dapui_config'] = function() require('dapui').open() end
      dap.listeners.before.event_terminated['dapui_config'] = function() require('dapui').close() end

      -- Treesitter: su NixOS i parser sono precompilati via nix,
      -- non serve setup(). Abilitiamo highlight manualmente per FileType.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust", "nix", "bash", "lua", "yaml", "toml", "json" },
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    '';
  };
}
