return {

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- C/C++ - clangd
      vim.lsp.config.clangd = {
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=false",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_markers = {
          'compile_commands.json',
          'compile_flags.txt',
          '.git'
        },
      }

      -- Kotlin
      vim.lsp.config.kotlin_language_server = {
        filetypes = { "kotlin", "kt", "kts" },
        flags = {
          debounce_text_changes = 150,
        },
        settings = {
          kotlin = {
            compiler = {
              jvm = { target = "21" }
            }
          }
        },
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("settings.gradle", "settings.gradle.kts", "build.gradle",
          "build.gradle.kts", "pom.xml", ".git"),
      }

      -- Haskell
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "gopls",
          "ts_ls",
          "clangd",
          "kotlin_language_server",
          "eslint-lsp",
          "hls" -- haskell-language-server
        },
        automatic_installation = true,
      })
    end,

  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = { "mason.nvim" },
    config = function()
      require("lazydev").setup({
        library = {
          { path = "${3rd}/luv/library", words = { "vim.uv" } },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
  },
  {
    'esmuellert/nvim-eslint',
    config = function()
      require('nvim-eslint').setup({})
    end,
  }
}
