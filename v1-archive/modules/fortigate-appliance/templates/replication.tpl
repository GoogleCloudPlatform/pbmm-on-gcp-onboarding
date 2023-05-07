config system ha
    set group-name GCPHA
    set mode a-p
    set hbdev ${fgt_ha_port} 100
    set session-pickup enable
    set session-pickup-connectionless enable
    set override enable
    set priority ${fgt_ha_priority}
    set unicast-hb enable
    set unicast-hb-peerip ${fgt_ha_peerip}
    set unicast-hb-netmask ${fgt_ha_netmask}
end