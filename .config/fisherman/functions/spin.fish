function spin -d "Spin a background job"
    set -l format " @\r"
    set -l commands
    set -l spinners
    set -l error /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set commands $commands ";$2"

            case s spin style
                set spinners $spinners $2

            case f format
                set format $2

            case error{,-log}
                set error $2

            case h help
                printf "Usage: spin <commands> [--format=<string>] [--style=<style>]\n"
                printf "                       [--error=<file>] [--help]\n\n"

                printf "    -f --format=<string>  Use given <string> to format spinner\n"
                printf "      -s --style=<style>  Set spinner style\n"
                printf "          --error=<file>  Write errors to <file>\n"
                printf "               -h --help  Show usage help\n"
                return

            case \*
                printf "spin: '%s' is not a valid option\n" $1 > /dev/stderr
                spin -h > /dev/stderr
                return 1
        end
    end

    if not set -q commands[1]
        return 1
    end

    if not set -q spinners[1]
        set spinners mix
    end

    switch "$spinners"
        case mix arc star pipe flip bounce
            set -l mix "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
            set -l arc "◜◠◝◞◡◟"
            set -l star "+x*"
            set -l pipe "|/--\\"
            set -l flip "___-``'´-___"
            set -l bounce "▖▘▝▗"

            set spinners $$spinners

        case bar{1,2,3}
            set -l bar
            set -l bar1 "[" "=" " " "]" "%"
            set -l bar2 "[" "#" " " "]" "%"
            set -l bar3 "." "." " " " " "%"

            set -l open $$spinners[1][1]
            set -l fill $$spinners[1][2]
            set -l void $$spinners[1][3]
            set -l close $$spinners[1][4]
            set -l symbol $$spinners[1][5]

            set spinners

            for i in (seq 5 5 100)
                if test -n "$symbol"
                    set symbol "$i%"
                end

                set -l gap (printf "$void%.0s" (seq (math 100 - $i)))

                if test $i -ge 100
                    set gap ""
                end

                set spinners $spinners "$open"(printf "$fill%.0s" (seq $i))"$gap$close $symbol"
            end
    end

    set -l tmp (mktemp -t spin.XXX)

    fish -c "$commands" > /dev/stdout ^ $tmp &

    if not set -q spinners[2]
        set spinners (printf "%s\n" "$spinners" | grep -o .)
    end

    while true
        if status --is-interactive
            for i in $spinners
                printf "$format" | awk -v i=(printf "%s\n" $i | sed 's/=/\\\=/') '
                {
                    gsub("@", i)
                    printf("%s", $0)
                }
                ' > /dev/stderr

                sleep 0.01
            end
        end

        if test -z (jobs)
            break
        end
    end

    if test -s $tmp
        cat $tmp > $error
        command rm -f $tmp
        return 1
    end

    command rm -f $tmp
end
