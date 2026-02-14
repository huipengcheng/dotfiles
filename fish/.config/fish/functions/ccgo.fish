function ccgo
    cc $argv -o /tmp/a.out
    and /tmp/a.out
end

# 给 ccgo 自动补全文件名
complete -c ccgo -f
