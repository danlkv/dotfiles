mason_registry = require 'mason-registry'
packages = {
    -- "cssls",
    -- "tsserver",
    -- "html",
    "css-lsp",
    "typescript-language-server",
    --"eslint",
    "html-lsp",
    --"svelte",
    "svelte-language-server",
}
-- Install all packages
for _, pkg in ipairs(packages) do
    pkg = mason_registry.get_package(pkg)
    if not pkg:is_installed() then
        print('Installing ' .. pkg.name)
        pkg:install()
    end
end


