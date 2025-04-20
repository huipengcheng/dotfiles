function proxy_on
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
    export http_proxy="http://127.0.0.1:10808"
    export HTTP_PROXY="http://127.0.0.1:10808"
    export https_proxy=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export all_proxy="socks5://127.0.0.1:10808"
    export ALL_PROXY="socks5://127.0.0.1:10808"
    echo "Proxy environment variable set."
end
