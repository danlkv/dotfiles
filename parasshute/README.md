# Parasshute

When you ssh onto a clean machine without root access, check your surroundings.
Do you have access to your favorite tools? Probably not.

Parasshute is a tool that helps you parachute into a clean machine and build
your tools from git.

## Usage

1. See available tools

     ```bash
    ./drop.sh 
    ```

2. Install a tool

     ```bash
    ./drop.sh <tool or shortcut>
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
