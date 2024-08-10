-- Similar to mason-lspconfig
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/ensure_installed.lua#L25
mason_registry = require 'mason-registry'
py_pkg = mason_registry.get_package('pyright')
if not py_pkg:is_installed() then
    print('Installing pyright')
    py_pkg:install()
end


