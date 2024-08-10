# Splitting configuration into modules by languages

- Python
- Webdev (html, css, js)
- Rust

This makes it easier to enable/disable just the modules you need on a given machine.

To enable a module, add the following to this folder's init.lua:


## Mason

mason-lspconfig provides a simple way to automatically install lsp servers.
This is done using `ensure_installed` configuration parameter.
But this needs a hard-coded list of servers to install.

Instead, we use the `mason-registry.get_package()` to get the Mason package
`mason-core.Package:install()` function to install the package. 

This is done similarly in `mason-lspconfig`: 
https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/ensure_installed.lua#L25


