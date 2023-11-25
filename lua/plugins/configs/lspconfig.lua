dofile(vim.g.base46_cache .. "lsp")
require "nvchad_ui.lsp"

local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad_ui.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}


local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

-- CUSTOM

-- rust: rust_analyzer + rustfmt
lspconfig.rust_analyzer.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    filetypes = {"rust"},
    root_dir = lspconfig.util.root_pattern("Cargo.toml"),
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    },
})


-- c/cpp: clangd
lspconfig.clangd.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    M.capabilities.offsetEncoding == {"utf16"},
    cmd = {
        "/home/lucas/.local/share/nvim/mason/packages/clangd/clangd_17.0.3/bin/clangd",
        "-offset-encoding=utf-16",
    },
})


-- webdevel: emmet_ls + rome + tailwindcss + prettier
lspconfig.emmet_ls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    filetypes = {"css", "html", "javascript", "javascriptreact", "typescriptreact"},
    init_options = {
      html = {
        options = {
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          ["bem.enabled"] = true,
        },
      },
    }
})

lspconfig.rome.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
})

lspconfig.tailwindcss.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
})


-- python: ruff + black
lspconfig.tailwindcss.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
})


-- latex: texlab (lsp) + latexindent (formatter)
lspconfig.texlab.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
})


-- sql: sqlls
lspconfig.sqlls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
})


-- verilog: svlangserver
lspconfig.svls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
})


-- assembly: asm-lsp
lspconfig.asm_lsp.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
})


-- go: gopls
lspconfig.gopls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
})

return M
