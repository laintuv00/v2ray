[[ -z $ip ]] && get_ip
if [[ $shadowsocks ]]; then
	local ss="ss://$(echo -n "${ssciphers}:${sspass}@${ip}:${ssport}" | base64 -w 0)#233v2.com_ss_${ip}"
	echo
	echo "---------- Shadowsocks Configuration information -------------"
	echo
	echo -e "$yellow Server address = $cyan${ip}$none"
	echo
	echo -e "$yellow Server port = $cyan$ssport$none"
	echo
	echo -e "$yellow Password = $cyan$sspass$none"
	echo
	echo -e "$yellow Encryption method = $cyan${ssciphers}$none"
	echo
	echo -e "$yellow SS link = ${cyan}$ss$none"
	echo
	echo -e " Note:$red Shadowsocks Win 4.0.6 $none The client may not recognize the SS link "
	echo
	echo -e " Prompt: Enter $cyan v2ray ssqr $none to generate Shadowsocks QR code link"	
	echo
	echo -e "${yellow}Avoid being walled.. recommended JMS: ${cyan}https://getjms.com${none}"
	echo
fi
