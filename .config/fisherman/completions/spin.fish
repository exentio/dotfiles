set -l IFS \t

complete -xc spin -n "__fish_seen_subcommand_from --style" \
    -a "spinners mix arc star pipe flip bounce bar1 bar2 bar3"

complete -xc spin -n "not __fish_seen_subcommand_from --style" -a "\t"

spin -h | __fisher_complete spin
