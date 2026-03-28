{
  inputs,
  config,
  pkgs,
  ...
}:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        # Dashboard
        dashboard.alpha.enable = true;

        # Autocomplete
        autocomplete.nvim-cmp.enable = true;

        # Syntax highlighting
        treesitter = {
          enable = true;
          indent.enable = true;
          context.enable = true;
        };

        # Telescope (fuzzy finder)
        telescope.enable = true;

        # File tree
        filetree.neo-tree.enable = true;

        # Git
        git = {
          enable = true;
          gitsigns.enable = true;
        };

        # Statusline
        statusline.lualine.enable = true;

        # Aliases
        viAlias = true;
        vimAlias = true;

        # Lsp
        lsp = {
          enable = true;
        };

        # Languages
        languages = {
          rust = {
            enable = true;
            extensions.crates-nvim.enable = true;
          };
          nix.enable = true;
          bash.enable = true;
          yaml.enable = true;
        };

        # Extra configs
        luaConfigRC.transparent = ''
          vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
          vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
          vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
        '';

        # Wrapping
        luaConfigRC.wrapping = ''
          vim.opt.wrap = true
          vim.opt.linebreak = true
          vim.opt.breakindent = true
        '';

        # Indentation
        luaConfigRC.paste = ''
          vim.opt.smartindent = true
          vim.opt.autoindent = true
          vim.opt.preserveindent = true
        '';

        # Tab = 2 spaces
        luaConfigRC.indentation = ''
          vim.opt.tabstop = 2
          vim.opt.shiftwidth = 2
          vim.opt.expandtab = true
        '';

        # Format on save
        luaConfigRC.fmt = ''
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.nix", "*.rs" },
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        '';

        # Space as leader
        globals = {
          mapleader = " ";
        };

        # Shortcut menu
        luaConfigRC.menu = ''
          vim.keymap.set("n", "<leader>-", function()
            print('<space>e - file tree | <space>f - format | "+y - copy | "+x - cut | "+p - paste')
          end, { desc = "Show keybinds" })
        '';

        # Keybinds
        keymaps = [
          {
            key = "<leader>e";
            mode = "n";
            action = ":Neotree toggle<CR>";
            silent = true;
            desc = "Toggle file tree";
          }
          {
            key = "<Down>";
            mode = "n";
            action = "gj";
            silent = true;
            desc = "Move down visual line";
          }
          {
            key = "<Up>";
            mode = "n";
            action = "gk";
            silent = true;
            desc = "Move up visual line";
          }
          {
            key = "<leader>f";
            mode = "n";
            action = "<cmd>lua vim.lsp.buf.format()<CR>";
            silent = true;
            desc = "Format file";
          }
        ];

        # Discord RPC
        extraPlugins = {
          cord-nvim = {
            package = pkgs.vimPlugins.cord-nvim;
            setup = ''
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
        };
      };
    };
  };
}
