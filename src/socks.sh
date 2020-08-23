_view_socks_info() {
	if [[ $socks ]]; then
		_socks_info
	else
		_socks_ask
	fi
}
_socks_info() {
	[[ -z $ip ]] && get_ip
	echo
	echo "---------- Socks Configuration information -------------"
	echo
	echo -e "$yellow Hostname = $cyan${ip}$none"
	echo
	echo -e "$yellow Port = $cyan$socks_port$none"
	echo
	echo -e "$yellow Username = $cyan$socks_username$none"
	echo
	echo -e "$yellow Password = $cyan$socks_userpass$none"
	echo
	echo -e "$yellow Telegram proxy configuration link = ${cyan}tg://socks?server=${ip}&port=${socks_port}&user=${socks_username}&pass=${socks_userpass}$none"
	echo
}
_socks_main() {
	if [[ $socks ]]; then

		while :; do
			echo
			echo -e "$yellow 1. $none View Socks Configuration information"
			echo
			echo -e "$yellow 2. $none Modify Socks Port"
			echo
			echo -e "$yellow 3. $none Modify Socks Username"
			echo
			echo -e "$yellow 4. $none Modify Socks Password"
			echo
			echo -e "$yellow 5. $none Turn Off Socks"
			echo
			read -p "$(echo -e "Please choose [${magenta}1-4$none]:")" _opt
			if [[ -z $_opt ]]; then
				error
			else
				case $_opt in
				1)
					_socks_info
					break
					;;
				2)
					change_socks_port_config
					break
					;;
				3)
					change_socks_user_config
					break
					;;
				4)
					change_socks_pass_config
					break
					;;
				5)
					disable_socks
					break
					;;
				*)
					error
					;;
				esac
			fi

		done
	else
		_socks_ask
	fi
}
_socks_ask() {
	echo
	echo
	echo -e " $redBoss...you did not configure Socks $none...but you can configure it now ^_^"
	echo
	echo

	while :; do
		echo -e "Whether to configure ${yellow}Socks${none} [${magenta}Y/N$none]"
		read -p "$(echo -e "(default [${cyan}N$none]):") " new_socks
		[[ -z "$new_socks" ]] && new_socks="n"
		if [[ "$new_socks" == [Yy] ]]; then
			echo
			socks=true
			socks_port_config
			socks_user_config
			socks_pass_config
			pause
			open_port $new_socks_port
			backup_config +socks
			socks_port=$new_socks_port
			socks_username=$new_socks_username
			socks_userpass=$new_socks_userpass
			config
			clear
			_socks_info
			break
		elif [[ "$new_socks" == [Nn] ]]; then
			echo
			echo -e " $green Unconfigured Socks ....$none"
			echo
			break
		else
			error
		fi

	done
}
disable_socks() {
	echo

	while :; do
		echo -e "Whether to Turn Off ${yellow}Socks${none} [${magenta}Y/N$none]"
		read -p "$(echo -e "(default [${cyan}N$none]):") " y_n
		[[ -z "$y_n" ]] && y_n="n"
		if [[ "$y_n" == [Yy] ]]; then
			echo
			echo
			echo -e "$yellow  Turn Off Socks = $cyan Yes $none"
			echo "----------------------------------------------------------------"
			echo
			pause
			backup_config -socks
			del_port $socks_port
			socks=''
			config
			echo
			echo
			echo
			echo -e "$green Socks turn off...but you can re-enable Socks at any time...as long as you like$none"
			echo
			break
		elif [[ "$y_n" == [Nn] ]]; then
			echo
			echo -e " $green Turn Off Socks ....$none"
			echo
			break
		else
			error
		fi

	done
}
socks_port_config() {
	local random=$(shuf -i20001-65535 -n1)
	echo
	while :; do
		echo -e "Please enter "$yellow"Socks"$none" Port ["$magenta"1-65535"$none"]，Cannot be the same as the "$yellow"V2Ray"$none" Port"
		read -p "$(echo -e "(defaultPort: ${cyan}${random}$none):") " new_socks_port
		[ -z "$new_socks_port" ] && new_socks_port=$random
		case $new_socks_port in
		$v2ray_port)
			echo
			echo " Cannot be the same as the V2Ray Port...."
			error
			;;
		[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
			if [[ $v2ray_transport == [45] ]]; then
				local tls=ture
			fi
			if [[ $tls && $new_socks_port == "80" ]] || [[ $tls && $new_socks_port == "443" ]]; then
				echo
				echo -e "Because you have chosen "$green"WebSocket + TLS $none or $green HTTP/2"$none" Transfer Protocol."
				echo
				echo -e "So cannot choose "$magenta"80"$none"  or  "$magenta"443"$none" Port"
				error
			elif [[ $dynamicPort ]] && [[ $v2ray_dynamicPort_start == $new_socks_port || $v2ray_dynamicPort_end == $new_socks_port ]]; then
				echo
				echo -e " Sorry，This Port conflicts with the V2Ray dynamic port, the current V2Ray dynamic port range is：${cyan}$port_range${none}"
				error
			elif [[ $dynamicPort ]] && [[ $v2ray_dynamicPort_start -lt $new_socks_port && $new_socks_port -le $v2ray_dynamicPort_end ]]; then
				echo
				echo -e " Sorry，This Port conflicts with the V2Ray dynamic port, the current V2Ray dynamic port range is：${cyan}$port_range${none}"
				error
			elif [[ $shadowsocks && $new_socks_port == $ssport ]]; then
				echo
				echo -e "Sorry, This Port conflicts with Shadowsocks Port...current Shadowsocks Port: ${cyan}$ssport$none"
				error
			elif [[ $mtproto && $new_socks_port == $mtproto_port ]]; then
				echo
				echo -e "Sorry, This port conflicts with the MTProto port...Current MTProto port: ${cyan}$mtproto_port$none"
				error
			else
				echo
				echo
				echo -e "$yellow Socks Port = $cyan$new_socks_port$none"
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
socks_user_config() {
	echo
	while :; do
		read -p "$(echo -e "Please enter$yellow Username $none...(default Username: ${cyan}233blog$none)"): " new_socks_username
		[ -z "$new_socks_username" ] && new_socks_username="233blog"
		case $new_socks_username in
		*[/$]* | *\&*)
			echo
			echo -e " Because this script is too spicy..So Username cannot contain $red / $none or $red $ $none or $red & $none these three symbols.... "
			echo
			error
			;;
		*)
			echo
			echo
			echo -e "$yellow Username = $cyan$new_socks_username$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		esac
	done

}
socks_pass_config() {
	echo
	while :; do
		read -p "$(echo -e "Please enter$yellowPassword$none...(defaultPassword: ${cyan}233blog.com$none)"): " new_socks_userpass
		[ -z "$new_socks_userpass" ] && new_socks_userpass="233blog.com"
		case $new_socks_userpass in
		*[/$]* | *\&*)
			echo
			echo -e " Because this script is too spicy..So Password cannot contain $red / $none or $red $ $none or $red & $none these three symbols.... "
			echo
			error
			;;
		*)
			echo
			echo
			echo -e "$yellow Password = $cyan$new_socks_userpass$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		esac
	done
}
change_socks_user_config() {
	echo
	while :; do
		read -p "$(echo -e "Please enter $yellow Username $none...(current Username: ${cyan}$socks_username$none)"): " new_socks_username
		[ -z "$new_socks_username" ] && error && continue
		case $new_socks_username in
		$socks_username)
			echo
			echo -e " Boss...it is the same as the current username... Modify it "
			echo
			error
			;;
		*[/$]* | *\&*)
			echo
			echo -e " Because this script is too spicy..So Username cannot contain $red / $none or $red $ $none or $red & $none these three symbols.... "
			echo
			error
			;;
		*)
			echo
			echo
			echo -e "$yellow Username = $cyan$new_socks_username$none"
			echo "----------------------------------------------------------------"
			echo
			pause
			backup_config socks_username
			socks_username=$new_socks_username
			config
			clear
			_socks_info
			break
			;;
		esac
	done
}
change_socks_pass_config() {
	echo
	while :; do
		read -p "$(echo -e "Please enter$yellowPassword$none...(current Password: ${cyan}$socks_userpass$none)"): " new_socks_userpass
		[ -z "$new_socks_userpass" ] && error && continue
		case $new_socks_userpass in
		$socks_userpass)
			echo
			echo -e " Boss...it is the same as the current Password... Modify it "
			echo
			error
			;;
		*[/$]* | *\&*)
			echo
			echo -e " Because this script is too spicy..So Password cannot contain $red / $none or $red $ $none or $red & $none these three symbols.... "
			echo
			error
			;;
		*)
			echo
			echo
			echo -e "$yellow Password = $cyan$new_socks_userpass$none"
			echo "----------------------------------------------------------------"
			echo
			pause
			backup_config socks_userpass
			socks_userpass=$new_socks_userpass
			config
			clear
			_socks_info
			break
			;;
		esac
	done
}
change_socks_port_config() {
	echo
	while :; do
		echo -e "Please enter new "$yellow"Socks"$none" Port ["$magenta"1-65535"$none"]"
		read -p "$(echo -e "(current Port: ${cyan}${socks_port}$none):") " new_socks_port
		[ -z "$new_socks_port" ] && error && continue
		case $new_socks_port in
		$socks_port)
			echo
			echo " Cannot be the same as thecurrent Port...."
			error
			;;
		$v2ray_port)
			echo
			echo " Cannot be the same as the V2Ray Port...."
			error
			;;
		[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
			if [[ $v2ray_transport == [45] ]]; then
				local tls=ture
			fi
			if [[ $tls && $new_socks_port == "80" ]] || [[ $tls && $new_socks_port == "443" ]]; then
				echo
				echo -e "Because you have chosen "$green"WebSocket + TLS $none or $green HTTP/2"$none" Transfer Protocol."
				echo
				echo -e "So cannot choose "$magenta"80"$none"  or  "$magenta"443"$none" Port"
				error
			elif [[ $dynamicPort ]] && [[ $v2ray_dynamicPort_start == $new_socks_port || $v2ray_dynamicPort_end == $new_socks_port ]]; then
				echo
				echo -e " Sorry, this port conflicts with the V2Ray dynamic port. The current V2Ray dynamic port range is：${cyan}$port_range${none}"
				error
			elif [[ $dynamicPort ]] && [[ $v2ray_dynamicPort_start -lt $new_socks_port && $new_socks_port -le $v2ray_dynamicPort_end ]]; then
				echo
				echo -e " Sorry, this port conflicts with the V2Ray dynamic port. The current V2Ray dynamic port range is：${cyan}$port_range${none}"
				error
			elif [[ $shadowsocks && $new_socks_port == $ssport ]]; then
				echo
				echo -e "Sorry, this port conflicts with the Shadowsocks port...Current Shadowsocks port: ${cyan}$ssport$none"
				error
			elif [[ $mtproto && $new_socks_port == $mtproto_port ]]; then
				echo
				echo -e "Sorry, this port conflicts with the MTProto port...Current MTProto port: ${cyan}$mtproto_port$none"
				error
			else
				echo
				echo
				echo -e "$yellow socks Port = $cyan$new_socks_port$none"
				echo "----------------------------------------------------------------"
				echo
				pause
				backup_config socks_port
				socks_port=$new_socks_port
				config
				clear
				_socks_info
				break
			fi
			;;
		*)
			error
			;;
		esac

	done

}
