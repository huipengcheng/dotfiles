function proxy_off
    set -e no_proxy NO_PROXY \
        http_proxy https_proxy all_proxy ftp_proxy rsync_proxy \
        HTTP_PROXY HTTPS_PROXY ALL_PROXY FTP_PROXY RSYNC_PROXY
    echo "Proxy environment variable removed."
end
