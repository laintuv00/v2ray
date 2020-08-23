_ban_bt_main() {
	if [[ $ban_bt ]]; then
		local _info="$green Activated $none"
	else
		local _info="$red Not running $none"
	fi
	_opt=''
	while :; do
		echo
		echo -e "$yellow 1. $none Turn on BT blocking"
		echo
		echo -e "$yellow 2. $none Turn off BT blocking"
		echo
		echo -e "Current BT blocking status: $_info"
		echo
		read -p "$(echo -e "Please choose [${magenta}1-2$none]:")" _opt
		if [[ -z $_opt ]]; then
			error
		else
			case $_opt in
			1)
				if [[ $ban_bt ]]; then
					echo
					echo -e " Big boss...Is it possible that you didn't see (current BT blocking status: $_info) this handsome reminder...and turn on it"
					echo
				else
					echo
					echo
					echo -e "$yellow  BT blocking = $cyan Turn on $none"
					echo "----------------------------------------------------------------"
					echo
					pause
					backup_config +bt
					ban_bt=true
					config
					echo
					echo
					echo -e "$green  BT blocking is turned on...If something goes wrong... then close it$none"
					echo
				fi
				break
				;;
			2)
				if [[ $ban_bt ]]; then
					echo
					echo
					echo -e "$yellow  BT blocking = $cyan Turn off $none"
					echo "----------------------------------------------------------------"
					echo
					pause
					backup_config -bt
					ban_bt=''
					config
					echo
					echo
					echo -e "$red  BT blocking is turned off...but you can turn it back on anytime...as long as you like $none"
					echo
				else
					echo
					echo -e " Big guy...Is it possible that you didn't see (current BT blocking status: $_info) this handsome reminder... and also turn off it"
					echo
				fi
				break
				;;
			*)
				error
				;;
			esac
		fi
	done
}
