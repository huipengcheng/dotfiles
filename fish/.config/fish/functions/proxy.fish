function proxy -d "Manage proxy environment variables"
    if test (count $argv) -ne 1
        echo "Usage: proxy {on|off|status}" >&2
        return 1
    end

    switch $argv[1]
        case on
            set -l no_proxy_hosts "localhost,127.0.0.1,localaddress,.localdomain.com"
            set -l http_proxy_addr "http://127.0.0.1:10808"
            set -l socks_proxy_addr "socks5://127.0.0.1:10808"

            set -gx no_proxy $no_proxy_hosts
            set -gx NO_PROXY $no_proxy_hosts
            set -gx http_proxy $http_proxy_addr
            set -gx HTTP_PROXY $http_proxy_addr
            set -gx https_proxy $http_proxy_addr
            set -gx HTTPS_PROXY $http_proxy_addr
            set -gx all_proxy $socks_proxy_addr
            set -gx ALL_PROXY $socks_proxy_addr

            echo "Proxy environment variable set."
        case off
            set -e no_proxy NO_PROXY \
                http_proxy https_proxy all_proxy ftp_proxy rsync_proxy \
                HTTP_PROXY HTTPS_PROXY ALL_PROXY FTP_PROXY RSYNC_PROXY

            echo "Proxy environment variable removed."
        case status
            if set -q http_proxy
                echo "proxy: on ($http_proxy)"
            else
                echo "proxy: off"
            end
        case '*'
            echo "Usage: proxy {on|off|status}" >&2
            return 1
    end
end
