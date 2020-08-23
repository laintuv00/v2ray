[[ -z $ip ]] && get_ip
_v2_args() {
	header="none"
	if [[ $is_path ]]; then
		_path="/$path"
	else
		_path="/"
	fi
	case $v2ray_transport in
	1 | 18)
		net="tcp"
		;;
	2 | 19)
		net="tcp"
		header="http"
		host="www.baidu.com"
		;;
	3 | 4 | 20)
		net="ws"
		;;
	5)
		net="h2"
		;;
	6 | 21)
		net="kcp"
		;;
	7 | 22)
		net="kcp"
		header="utp"
		;;
	8 | 23)
		net="kcp"
		header="srtp"
		;;
	9 | 24)
		net="kcp"
		header="wechat-video"
		;;
	10 | 25)
		net="kcp"
		header="dtls"
		;;
	11 | 26)
		net="kcp"
		header="wireguard"
		;;
	12 | 27)
		net="quic"
		;;
	13 | 28)
		net="quic"
		header="utp"
		;;
	14 | 29)
		net="quic"
		header="srtp"
		;;
	15 | 30)
		net="quic"
		header="wechat-video"
		;;
	16 | 31)
		net="quic"
		header="dtls"
		;;
	17 | 32)
		net="quic"
		header="wireguard"
		;;
	esac
}

_v2_info() {
	echo
	echo
	echo "---------- V2Ray Configuration information -------------"
	if [[ $v2ray_transport == [45] ]]; then
		if [[ ! $caddy ]]; then
			echo
			echo -e " $red Warning！$none$yellow Please configure TLS...tutorial: https://233v2.com/post/3/$none"
		fi
		echo
		echo -e "$yellow Address = $cyan${domain}$none"
		echo
		echo -e "$yellow Port) = ${cyan}443${none}"
		echo
		echo -e "$yellow User ID / UUID = $cyan${v2ray_id}$none"
		echo
		echo -e "$yellow Alter Id = ${cyan}${alterId}${none}"
		echo
		echo -e "$yellow Transfer Protocol (Network) = ${cyan}${net}$none"
		echo
		echo -e "$yellow Header type = ${cyan}${header}$none"
		echo
		echo -e "$yellow Fake domain name (host) = ${cyan}${domain}$none"
		echo
		echo -e "$yellow Path = ${cyan}${_path}$none"
		echo
		echo -e "$yellow TLS (Enable TLS) = ${cyan} Turn on $none"
		echo
		if [[ $ban_ad ]]; then
			echo " Note: Ad blocking is turned on.."
			echo
		fi
	else
		echo
		echo -e "$yellow Address) = $cyan${ip}$none"
		echo
		echo -e "$yellow Port) = $cyan$v2ray_port$none"
		echo
		echo -e "$yellow User ID / UUID) = $cyan${v2ray_id}$none"
		echo
		echo -e "$yellow Alter Id) = ${cyan}${alterId}${none}"
		echo
		echo -e "$yellow Transfer Protocol (Network) = ${cyan}${net}$none"
		echo
		echo -e "$yellow Header type) = ${cyan}${header}$none"
		echo
	fi
	if [[ $v2ray_transport -ge 18 ]] && [[ $ban_ad ]]; then
		echo " Note: Dynamic port is enabled...Ad blocking is enabled..."
		echo
	elif [[ $v2ray_transport -ge 18 ]]; then
		echo " Note: Dynamic port is enabled..."
		echo
	elif [[ $ban_ad ]]; then
		echo " Note: Ad blocking is turned on.."
		echo
	fi
	echo "---------- END -------------"
	echo
	echo "V2Ray Client tutorial: https://233v2.com/post/4/"
	echo
	echo -e "Tip: Enter $cyan v2ray url $none to generate vmess URL link/input $cyan v2ray qr $none to generate QR code link"
	echo
	echo -e "${yellow}Avoid being walled... recommended JMS: ${cyan}https://getjms.com${none}"
	echo
}
