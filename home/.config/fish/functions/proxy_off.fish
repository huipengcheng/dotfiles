function proxy_off
    unset http_proxy https_proxy all_proxy ftp_proxy rsync_proxy \
          HTTP_PROXY HTTPS_PROXY ALL_PROXY FTP_PROXY RSYNC_PROXY
    echo -e "Proxy environment variable removed."
end
