#!/bin/bash
# Local install Claude CLI from sh. use drop.sh node if needed.
# No sudo needed.
#
# DEPEND: node
./drop.sh node || exit 1
export PATH=$INSTALL_PREFIX/bin:$PATH

# -- Install claude CLI if missing
# Use --prefix to install into INSTALL_PREFIX without requiring sudo
claude_path=$(PATH=$INSTALL_PREFIX/bin:$PATH command -v claude)
if [ -z "$claude_path" ]; then
    echo "Installing claude CLI via npm into $INSTALL_PREFIX..."
    npm install -g --prefix "$INSTALL_PREFIX" @anthropic-ai/claude-code || {
        echo "!Failed to install claude CLI"
        exit 1
    }
else
    echo "Claude CLI is already here: $claude_path"
fi

