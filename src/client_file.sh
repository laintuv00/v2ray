# vmess
_load vmess-config.sh
_get_client_file() {
    local _link="$(cat $v2ray_client_config | tr -d [:space:] | base64 -w0)"
    local link="https://233boy.github.io/tools/json.html#${_link}"
    echo
    echo "---------- V2Ray Client configuration file link -------------"
    echo
    echo -e ${cyan}$link${none}
    echo
    echo " V2Ray Client tutorial: https://233v2.com/post/4/"
    echo
    echo
}
