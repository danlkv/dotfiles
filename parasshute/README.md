# Parasshute

When you ssh onto a clean machine without root access, check your surroundings.
Do you have access to your favorite tools? Probably not.

Parasshute is a tool that helps you parachute into a clean machine and build
your tools from git.

See also:

1. [Homebrew](https://docs.brew.sh/Homebrew-on-Linux) - can install packages
   without root access. Quite hackable and more mature, supports
   versions. Not tested, may be portable; not as hackable as bash.
   Plus, `parasshute` allows to specify highly specific plugins like `fish-tide`.
2. [qpkg](https://nullprogram.com/blog/2018/03/27/) - build and install C packages 
   from source dir.

   Pros:
   - Has automatic support for uninstall and check for file collisions.

   Cons:
   - Won't work for custom plugins like `fish-tide`.

## Usage

1. See available tools

     ```bash
    ./drop.sh 
    ```

2. Install a tool

     ```bash
    ./drop.sh <tool or shortcut>
    ```

3. Remove a tool
    
     ```bash
    ./purge.sh -r <tool or shortcut>
    ```

### Shortcuts

Some directories are aliases for packages. For example,

- `./drop.sh all` installs everything.

## Markers

These may be helpful to check

- `NOTE`: general info
- `DEPEND`: info about dependencies

## Dev notes

- terminate bodies of single-line functions with semicolon

### Ideas

Nested structure.

- `nvim` - neovim binary
- `nvim/config` - my nvim config
