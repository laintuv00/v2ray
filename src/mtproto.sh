_view_mtproto_info() {
	if [[ $mtproto ]]; then
		_mtproto_info
	else
		_mtproto_ask
	fi
}
_mtproto_info() {
	[[ -z $ip ]] && get_ip
	echo
	echo "---------- Telegram MTProto Configuration information -------------"
	echo
	echo -e "$yellow Hostname = $cyan${ip}$none"
	echo
	echo -e "$yellow Port = $cyan$mtproto_port$none"
	echo
	echo -e "$yellow Secret = $cyan$mtproto_secret$none"
	echo
	echo -e "$yellow Telegram = ${cyan}https://t.me/proxy?server=${ip}&port=${mtproto_port}&secret=${mtproto_secret}$none"
	echo
}
_mtproto_main() {
	if [[ $mtproto ]]; then

		while :; do
			echo
			echo -e "$yellow 1. $none View Telegram MTProto Configuration information"
			echo
			echo -e "$yellow 2. $none Modify Telegram MTProto Port"
			echo
			echo -e "$yellow 3. $none Modify Telegram MTProto Key"
			echo
			echo -e "$yellow 4. $none Turn Off Telegram MTProto"
			echo
			read -p "$(echo -e "Please choose [${magenta}1-4$none]:")" _opt
			if [[ -z $_opt ]]; then
				error
			else
				case $_opt in
				1)
					_mtproto_info
					break
					;;
				2)
					change_mtproto_port
					break
					;;
				3)
					change_mtproto_secret
					break
					;;
				4)
					disable_mtproto
					break
					;;
				*)
					error
					;;
				esac
			fi

		done
	else
		_mtproto_ask
	fi
}
_mtproto_ask() {
	echo
	echo
	echo -e " $redBoss... you have no configuration Telegram MTProto $none...But now you can configure it ^_^"
	echo
	echo
	new_mtproto_secret="dd$(date | md5sum | cut -c-30)"
	while :; do
		echo -e "Whether to configure ${yellow}Telegram MTProto${none} [${magenta}Y/N$none]"
		read -p "$(echo -e "(Default [${cyan}N$none]):") " new_mtproto
		[[ -z "$new_mtproto" ]] && new_mtproto="n"
		if [[ "$new_mtproto" == [Yy] ]]; then
			echo
			mtproto=true
			mtproto_port_config
			pause
			open_port $new_mtproto_port
			backup_config +mtproto
			mtproto_port=$new_mtproto_port
			mtproto_secret=$new_mtproto_secret
			config
			clear
			_mtproto_info
			break
		elif [[ "$new_mtproto" == [Nn] ]]; then
			echo
			echo -e " $green Unconfigured Telegram MTProto ....$none"
			echo
			break
		else
			error
		fi

	done
}
disable_mtproto() {
	echo

	while :; do
		echo -e "Whether to Turn Off ${yellow}Telegram MTProto${none} [${magenta}Y/N$none]"
		read -p "$(echo -e "(Default [${cyan}N$none]):") " y_n
		[[ -z "$y_n" ]] && y_n="n"
		if [[ "$y_n" == [Yy] ]]; then
			echo
			echo
			echo -e "$yellow Turn Off Telegram MTProto = $cyan Yes  $none"
			echo "----------------------------------------------------------------"
			echo
			pause
			backup_config -mtproto
			del_port $mtproto_port
			mtproto=''
			config
			echo
			echo
			echo
			echo -e "$green Telegram MTProto Turn Off...but you can re-enable Telegram MTProto at any time...as long as you like $none"
			echo
			break
		elif [[ "$y_n" == [Nn] ]]; then
			echo
			echo -e " $green Turn off Telegram MTProto ....$none"
			echo
			break
		else
			error
		fi

	done
}
mtproto_port_config() {
	local random=$(shuf -i20001-65535 -n1)
	echo
	while :; do
		echo -e "Please enter "$yellow"Telegram MTProto"$none" Port ["$magenta"1-65535"$none"]，Cannot be the same as "$yellow"V2Ray"$none" Port"
		read -p "$(echo -e "(DefaultPort: ${cyan}${random}$none):") " new_mtproto_port
		[ -z "$new_mtproto_port" ] && new_mtproto_port=$random
		case $new_mtproto_port in
		$v2ray_port)
			echo
			echo " Cannot be the same as V2Ray Port...."
			error
			;;
		[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
			if [[ $v2ray_transport == [45] ]]; then
				local tls=ture
			fi
			if [[ $tls && $new_mtproto_port == "80" ]] || [[ $tls && $new_mtproto_port == "443" ]]; then
				echo
				echo -e "Since you have selected the "$green"WebSocket + TLS $none port $green HTTP/2"$none" transmission protocol."
				echo
				echo -e "So you cannot choose "$magenta"80"$none"  port  "$magenta"443"$none" Port"
				error
			elif [[ $dynamicPort ]] && [[ $v2ray_dynamicPort_start == $new_mtproto_port || $v2ray_dynamicPort_end == $new_mtproto_port ]]; then
				echo
				echo -e " Sorry，Sorry, this port conflicts with the V2Ray dynamic port：${cyan}$port_range${none}"
				error
			elif [[ $dynamicPort ]] && [[ $v2ray_dynamicPort_start -lt $new_mtproto_port && $new_mtproto_port -le $v2ray_dynamicPort_end ]]; then
				echo
				echo -e " Sorry，The current V2Ray dynamic port range is：${cyan}$port_range${none}"
				error
			elif [[ $shadowsocks && $new_mtproto_port == $ssport ]]; then
				echo
				echo -e "Sorry, this Port conflicts with Shadowsocks Port...Current Shadowsocks Port: ${cyan}$ssport$none"
				error
			elif [[ $socks && $new_mtproto_port == $socks_port ]]; then
				echo
				echo -e "Sorry, this Port conflicts with Socks Port...Current Socks Port: ${cyan}$socks_port$none"
				error
			else
				echo
				echo
				echo -e "$yellow Telegram MTProto Port = $cyan$new_mtproto_port$none"
				echo "----------------------------------------------------------------"
				echo
				break
			fi
			;;
		*)
			error
			;;
		esac

	done

}
change_mtproto_secret() {
	new_mtproto_secret="dd$(date | md5sum | cut -c-30)"
	echo
	while :; do
		read -p "$(echo -e "Whether to Change ${yellow}Telegram MTProto Key${none} [${magenta}Y/N$none]"): " y_n
		[ -z "$y_n" ] && error && continue
		case $y_n in
		n | N)
			echo
			echo -e " cancelled Change.... "
			echo
			break
			;;
		y | Y)
			echo
			echo
			echo -e "$yellow  Change Telegram MTProto Key = $cyan Yes  $none"
			echo "----------------------------------------------------------------"
			echo
			pause
			backup_config mtproto_secret
			mtproto_secret=$new_mtproto_secret
			config
			clear
			_mtproto_info
			break
			;;
		esac
	done
}
change_mtproto_port() {
	echo
	while :; do
		echo -e "Please enterNew "$yellow"Telegram MTProto"$none" Port ["$magenta"1-65535"$none"]"
		read -p "$(echo -e "(current Port: ${cyan}${mtproto_port}$none):") " new_mtproto_port
		[ -z "$new_mtproto_port" ] && error && continue
		case $new_mtproto_port in
		$mtproto_port)
			echo
			echo " Can't keep up with the current Port...."
			error
			;;
		$v2ray_port)
			echo
			echo " Cannot be the same as V2Ray Port...."
			error
			;;
		[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
			if [[ $v2ray_transport == [45] ]]; then
				local tls=ture
			fi
			if [[ $tls && $new_mtproto_port == "80" ]] || [[ $tls && $new_mtproto_port == "443" ]]; then
				echo
				echo -e "Since you have selected the "$green"WebSocket + TLS $none port $green HTTP/2"$none" transmission protocol."
				echo
				echo -e "So you cannot choose "$magenta"80"$none"  port  "$magenta"443"$none" Port"
				error
			elif [[ $dynamicPort ]] && [[ $v2ray_dynamicPort_start == $new_mtproto_port || $v2ray_dynamicPort_end == $new_mtproto_port ]]; then
				echo
				echo -e " Sorry，This Port conflicts with the V2Ray dynamic port, the current V2Ray dynamic port range is：${cyan}$port_range${none}"
				error
			elif [[ $dynamicPort ]] && [[ $v2ray_dynamicPort_start -lt $new_mtproto_port && $new_mtproto_port -le $v2ray_dynamicPort_end ]]; then
				echo
				echo -e " Sorry，This Port conflicts with the V2Ray dynamic port, the current V2Ray dynamic port range is：${cyan}$port_range${none}"
				error
			elif [[ $shadowsocks && $new_mtproto_port == $ssport ]]; then
				echo
				echo -e "Sorry, This Port conflicts with Shadowsocks Port...current Shadowsocks Port: ${cyan}$ssport$none"
				error
			elif [[ $socks && $new_mtproto_port == $socks_port ]]; then
				echo
				echo -e "Sorry, This Port conflicts with Socks Port...current Socks Port: ${cyan}$socks_port$none"
				error
			else
				echo
				echo
				echo -e "$yellow socks Port = $cyan$new_mtproto_port$none"
				echo "----------------------------------------------------------------"
				echo
				pause
				backup_config mtproto_port
				mtproto_port=$new_mtproto_port
				config
				clear
				_mtproto_info
				break
			fi
			;;
		*)
			error
			;;
		esac

	done

}
