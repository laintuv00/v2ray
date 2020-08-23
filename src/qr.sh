_qr_create() {
	local vmess="vmess://$(cat /etc/v2ray/vmess_qr.json | base64 -w 0)"
	local link="https://233boy.github.io/tools/qr.html#${vmess}"
	echo
	echo "---------- V2Ray QR code link for V2RayNG v0.4.1+ / Kitsunebi -------------"
	echo
	echo -e ${cyan}$link${none}
	echo
	echo
	echo -e "$red Friendly reminder: Please be sure to check the scanning result (except V2RayNG) $none"
	echo
	echo
	echo " V2Ray Client tutorial: https://233v2.com/post/4/"
	echo
	echo
	rm -rf /etc/v2ray/vmess_qr.json
}
_ss_qr() {
	local ss_link="ss://$(echo -n "${ssciphers}:${sspass}@${ip}:${ssport}" | base64 -w 0)#233v2.com_ss_${ip}"
	local link="https://233boy.github.io/tools/qr.html#${ss_link}"
	echo
	echo "---------- Shadowsocks QR code link -------------"
	echo
	echo -e "$yellow link = $cyan$link$none"
	echo
	echo -e " Tips...$red Shadowsocks Win 4.0.6 $none The client may not recognize the QR code"
	echo
	echo
}
