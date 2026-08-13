# Directory stack navigation for fish shell.
# Bindings live here rather than in config.fish so the keys and the functions
# they call cannot drift apart. Safe despite config.fish calling
# fish_vi_key_bindings later: that erases preset bindings only, not user ones.

# Global variables for directory stack
set -g dir_stack (pwd)  # Initialize with current directory
set -g dir_stack_index 1  # Current position in stack (1-based)

# Override cd command to use our stack
function cd --description "Change directory with stack navigation"
    # Handle special cases
    if test (count $argv) -eq 0
        set argv $HOME
    end
    
    # If it's "cd -", use our back function instead
    if test "$argv[1]" = "-"
        dir_back
        return
    end
    
    # Attempt to change directory
    if builtin cd $argv
        set current_dir (pwd)
        
        # If we're not at the end of stack, truncate forward history
        if test $dir_stack_index -lt (count $dir_stack)
            set dir_stack $dir_stack[1..$dir_stack_index]
        end
        
        # Add new directory to stack (avoid duplicates of immediate previous)
        if test "$current_dir" != "$dir_stack[$dir_stack_index]"
            set dir_stack $dir_stack $current_dir
            set dir_stack_index (math $dir_stack_index + 1)
        end
    end
end

# Go back in directory stack
function dir_back --description "Go back in directory history"
    if test $dir_stack_index -gt 1
        set dir_stack_index (math $dir_stack_index - 1)
        builtin cd $dir_stack[$dir_stack_index]
        #echo ""
        #echo "← $dir_stack[$dir_stack_index]"
    else
        echo ""
        echo "Already at beginning of history"
        dir_stack_show
    end
    commandline -f repaint
end

# Go forward in directory stack
function dir_forward --description "Go forward in directory history"
    if test $dir_stack_index -lt (count $dir_stack)
        set dir_stack_index (math $dir_stack_index + 1)
        builtin cd $dir_stack[$dir_stack_index]
        #echo ""
        echo "$dir_stack_index → $dir_stack[$dir_stack_index]"
        echo "$(math $dir_stack_index +1) → $dir_stack[$(math $dir_stack_index + 1)]"
    else
        echo ""
        echo "Already at end of history"
        dir_stack_show
    end
    commandline -f repaint
end

# Show directory stack (useful for debugging)
function dir_stack_show --description "Show directory navigation stack"
    echo "Directory Stack:"
    for i in (seq 1 (count $dir_stack))
        if test $i -eq $dir_stack_index
            echo "  → $dir_stack[$i]  (current)"
        else
            echo "    $dir_stack[$i]"
        end
    end
end

# Clear directory stack
function dir_stack_clear --description "Clear directory navigation history"
    set dir_stack (pwd)
    set dir_stack_index 1
    echo "Directory stack cleared"
end

if status is-interactive
    bind -M insert \cb dir_back
    bind -M insert \cn dir_forward

    abbr --add dib dir_back
    abbr --add dif dir_forward # note: df is a command
    abbr --add dis dir_stack_show
    abbr --add dic dir_stack_clear
end
