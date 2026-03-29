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
    ];

    plugins = with pkgs.vimPlugins; [
      alpha-nvim
      nvim-web-devicons
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      (nvim-treesitter.withPlugins (
        p: with p; [ rust nix bash yaml toml json lua ]
      ))
      nvim-treesitter-context
      telescope-nvim
      plenary-nvim
      neo-tree-nvim
      nui-nvim
      vim-fugitive
      lualine-nvim
      crates-nvim
      cord-nvim
    ];

    initLua = ''
      -- Leader
      vim.g.mapleader = " "

      -- Indentation
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.autoindent = true
      vim.opt.preserveindent = true

      -- Wrapping
      vim.opt.wrap = true
      vim.opt.linebreak = true
      vim.opt.breakindent = true

      -- Line numbers
      vim.opt.number = true
      vim.opt.relativenumber = false

      -- Transparent background
      vim.api.nvim_set_hl(0, "Normal",          { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat",     { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC",        { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn",      { bg = "none" })
      vim.api.nvim_set_hl(0, "EndOfBuffer",     { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeNormal",   { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })

      -- Suppress noise
      local orig_notify = vim.notify
      vim.notify = function(msg, ...)
        if msg:match("no matching language servers") then return end
        orig_notify(msg, ...)
      end

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.nix", "*.rs" },
        callback = function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients > 0 then
            vim.lsp.buf.format({ async = false })
          end
        end,
      })

      -- Keybinds
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      -- Ctrl+A select all
      map("n", "<C-a>", "ggVG",                                        "Select all")

      -- Ctrl+C copy to system clipboard
      map("v", "<C-c>", '"+y',                                         "Copy to clipboard")

      -- Ctrl+X cut to system clipboard
      map("v", "<C-x>", '"+x',                                         "Cut to clipboard")

      -- Ctrl+V paste from system clipboard
      map("n", "<C-v>", '"+p',                                         "Paste from clipboard")
      map("i", "<C-v>", '<C-r>+',                                      "Paste from clipboard")

      -- Ctrl+Z undo
      map("n", "<C-z>", "u",                                           "Undo")
      map("i", "<C-z>", "<C-o>u",                                      "Undo")

      -- Ctrl+Y redo
      map("n", "<C-y>", "<C-r>",                                       "Redo")
      map("i", "<C-y>", "<C-o><C-r>",                                  "Redo")

      -- Ctrl+T open file tree
      map("n", "<C-t>", ":Neotree toggle<CR>",                         "Toggle file tree")

      -- Ctrl+Q go back to dashboard
      map("n", "<C-q>", ":Alpha<CR>",                                  "Go to dashboard")

      -- Ctrl+K show keybinds
      map("n", "<C-k>", function()
        print("C-a: select all | C-c: copy | C-x: cut | C-v: paste | C-z: undo | C-y: redo | C-t: tree | C-q: dashboard | <space>f: format")
      end,                                                              "Show keybinds")

      -- Format
      map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>",       "Format file")
      map("n", "<Down>",    "gj",                                       "Move down visual line")
      map("n", "<Up>",      "gk",                                       "Move up visual line")

      -- Alpha (dashboard)
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

      -- Cursore sulla prima voce
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.cmd("normal! gg")
        end,
      })

      -- Lualine
      require('lualine').setup()

      -- Neo-tree
      require('neo-tree').setup({
        close_if_last_window = true,
        filesystem = {
          follow_current_file = { enabled = true },
        },
      })

      -- Crates
      require('crates').setup()

      -- Telescope
      require('telescope').setup()

      -- Treesitter
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust", "nix", "bash", "yaml", "toml", "json", "lua" },
        callback = function()
          vim.treesitter.start()
        end,
      })
      require('treesitter-context').setup({ enable = false })

      -- nvim-cmp
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>']      = cmp.mapping.confirm({ select = true }),
          ['<Tab>']     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'crates' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })

      -- LSP
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      vim.lsp.config('rust_analyzer', { capabilities = capabilities })
      vim.lsp.config('nixd', { capabilities = capabilities })
      vim.lsp.config('bashls', { capabilities = capabilities })
      vim.lsp.config('yamlls', { capabilities = capabilities })

      vim.lsp.enable({ 'rust_analyzer', 'nixd', 'bashls', 'yamlls' })

      -- Discord RPC
      require('cord').setup({
        editor = {
          client = 'neovim',
          tooltip = 'I use Neovim btw',
        },
        display = {
          show_time = true,
          show_repository = true,
          show_cursor_position = true,
        },
        idle = {
          enable = true,
          timeout = 1800000,
        },
      })
    '';
  };
}
