_get_latest_version() {
	v2ray_repos_url="https://api.github.com/repos/v2fly/v2ray-core/releases/latest?v=$RANDOM"
	v2ray_latest_ver="$(curl -s $v2ray_repos_url | grep 'tag_name' | cut -d\" -f4)"

	if [[ ! $v2ray_latest_ver ]]; then
		echo
		echo -e " $red Get V2Ray   The latest version failed!!!$none"
		echo
		echo -e " Please try to execute the following command: $green echo 'nameserver 8.8.8.8' >/etc/resolv.conf $none"
		echo
		echo " 	Then re-run the script...."
		echo
		exit 1
	fi
}

_download_v2ray_file() {
	[[ ! $v2ray_latest_ver ]] && _get_latest_version
	v2ray_tmp_file="/tmp/v2ray.zip"
	v2ray_download_link="https://github.com/v2fly/v2ray-core/releases/download/$v2ray_latest_ver/v2ray-linux-${v2ray_bit}.zip"

	if ! wget --no-check-certificate -O "$v2ray_tmp_file" $v2ray_download_link; then
		echo -e "
        $red Failed to download V2Ray...maybe your VPS network is too hot...please try again...$none
        " && exit 1
	fi

	unzip -o $v2ray_tmp_file -d "/usr/bin/v2ray/"
	chmod +x /usr/bin/v2ray/{v2ray,v2ctl}
	if [[ ! $(cat /root/.bashrc | grep v2ray) ]]; then
		echo "alias v2ray=$_v2ray_sh" >>/root/.bashrc
	fi
}

_install_v2ray_service() {
	cp -f "/usr/bin/v2ray/systemd/v2ray.service" "/lib/systemd/system/"
	sed -i "s/on-failure/always/" /lib/systemd/system/v2ray.service
	systemctl enable v2ray
}

_update_v2ray_version() {
	_get_latest_version
	if [[ $v2ray_ver != $v2ray_latest_ver ]]; then
		echo
		echo -e " $green Huh... a new version is found... is desperately updating.......$none"
		echo
		_download_v2ray_file
		do_service restart v2ray
		echo
		echo -e " $green The update is successful...Current V2Ray version: ${cyan}$v2ray_latest_ver$none"
		echo
		echo -e " $yellow Reminder: In order to avoid inexplicable problems...The version of the V2Ray client should be consistent with the version of the server $none"
		echo
	else
		echo
		echo -e " $green No new version found....$none"
		echo
	fi
}

_mkdir_dir() {
	mkdir -p /var/log/v2ray
	mkdir -p /etc/v2ray
}
