-- Similar to mason-lspconfig
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/ensure_installed.lua#L25
mason_registry = require 'mason-registry'

packages = {
    "clangd",
}
-- Install all packages
for _, pkg in ipairs(packages) do
    pkg = mason_registry.get_package(pkg)
    if not pkg:is_installed() then
        print('Installing ' .. pkg.name)
        pkg:install()
    end
end

require('lspconfig').clangd.setup {}
