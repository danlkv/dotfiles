# Directory stack navigation for fish shell
# Save this as ~/.config/fish/functions/dir_stack.fish

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
        echo "Already at beginning of history"
    end
    commandline -f repaint
end

# Go forward in directory stack
function dir_forward --description "Go forward in directory history"
    if test $dir_stack_index -lt (count $dir_stack)
        set dir_stack_index (math $dir_stack_index + 1)
        builtin cd $dir_stack[$dir_stack_index]
        #echo ""
        #echo "→ $dir_stack[$dir_stack_index]"
    else
        echo "Already at end of history"
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
