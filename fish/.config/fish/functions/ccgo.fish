function ccgo
    cc $argv -o /tmp/a.out
    and /tmp/a.out
end

# Enable filename completion for ccgo
complete -c ccgo -f
