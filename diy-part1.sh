cat >$NETIP <<-EOF
uci set network.lan.ipaddr='192.168.10.1'                                    # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                                  # IPv4 子网掩码
uci set network.lan.gateway='192.168.1.1'                                    # IPv4 网关
uci set network.lan.broadcast='192.168.10.255'                               # IPv4 广播
uci set network.lan.dns='223.5.5.5 114.114.114.114'                          # DNS(多个DNS要用空格分开)
uci set network.lan.delegate='0'                                             # 去掉LAN口使用内置的 IPv6 管理
uci commit network                                                           # 不要删除跟注释,除非上面全部删除或注释掉了
#uci set dhcp.lan.ignore='1'                                                 # 关闭DHCP功能
#uci commit dhcp                                                             # 跟‘关闭DHCP功能’联动,同时启用或者删除跟注释
uci set system.@system[0].hostname='GDOCK-2'                                 # 修改主机名称为GDOCK-2
sed -i 's/\/bin\/login/\/bin\/login -f root/' /etc/config/ttyd               # 设置ttyd免帐号登录，如若开启，进入OPENWRT后可能要重启一次才生效
EOF

sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile            # 选择argon为默认主题

sed -i "s/OpenWrt /${Author} compiled in $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ           # 增加个性名字 ${Author} 默认为你的github帐号

sed -i '/CYXluq4wUazHjmCDBCqXF/d' $ZZZ                                                             # 设置密码为空

#sed -i 's/PATCHVER:=5.4/PATCHVER:=5.10/g' target/linux/x86/Makefile                               # x86机型,默认内核5.4，修改内核为5.10

# K3专用，编译K3的时候只会出K3固件
#sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm_k3|TARGET_DEVICES += phicomm_k3|' target/linux/bcm53xx/image/Makefile


# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF直接加入删除代码，记住这里对应的是固件的文件路径，比如： rm /etc/config/luci
cat >$DELETE <<-EOF
EOF


# 修改插件名字
# sed -i 's/"aMule设置"/"电驴下载"/g' `grep "aMule设置" -rl ./`
# sed -i 's/"网络存储"/"NAS"/g' `grep "网络存储" -rl ./`
# sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
# sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
# sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
# sed -i 's/"TTYD 终端"/"命令窗"/g' `grep "TTYD 终端" -rl ./`
# sed -i 's/"USB 打印服务器"/"打印服务"/g' `grep "USB 打印服务器" -rl ./`
# sed -i 's/"Web 管理"/"Web"/g' `grep "Web 管理" -rl ./`
# sed -i 's/"管理权"/"改密码"/g' `grep "管理权" -rl ./`
# sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
# sed -i 's/"Argon 主题设置"/"Argon设置"/g' `grep "Argon 主题设置" -rl ./`

# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间
cat >${GITHUB_WORKSPACE}/Clear <<-EOF
rm -rf openwrt-ipq40xx-p2w_r619ac-128m-initramfs-fit-zImage.itb
# rm -rf openwrt-ipq40xx-p2w_r619ac-128m-squashfs-nand-factory.ubi
rm -rf openwrt-ipq40xx-p2w_r619ac-128m.manifest
rm -rf config.buildinfo
rm -rf feeds.buildinfo
rm -rf version.buildinfo
rm -rf sha256sums
#rm -rf Source code (zip)
#rm -rf Source code (tar.gz)
EOF

mkdir -p files/etc/hotplug.d/block && curl -fsSL https://raw.githubusercontent.com/281677160/openwrt-package/usb/block/10-mount > files/etc/hotplug.d/block/10-mount

# 添加插件
git clone https://github.com/sirpdboy/netspeedtest package/netspeedtest
