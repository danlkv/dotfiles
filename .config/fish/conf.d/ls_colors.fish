# Readable ls colors for world-writable dirs (default ow=34;42 is blue-on-green)
if command -q dircolors
    set -gx LS_COLORS (dircolors -b | sed -n "s/^LS_COLORS='\(.*\)';\$/\1/p" | sed 's/ow=34;42/ow=30;103/;s/tw=30;42/tw=30;103/')
end
