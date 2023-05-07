config system global
    set admintimeout 120
    set hostname "${fgt_vm_name}"
    set timezone 12
    set gui-theme mariner
end

config system admin
    edit admin
        set password ${fgt_ha_password}
    next
end

config system interface
    edit ${fgt_public_port}
        set mode dhcp
        set ip ${fgt_public_ip} ${fgt_public_netmask}
        set allowaccess ping https ssh http fgfm
        set type physical
        set alias "public"
        set lldp-reception enable
        set role wan
        set snmp-index 1
        set mtu-override enable
        set mtu 9001
    next
end

config system interface
    edit ${fgt_ha_port}
        set mode static
        set ip ${fgt_ha_ip} ${fgt_ha_netmask}
        set allowaccess ping https ssh http fgfm
    next
end

%{ if fgt_ha_priority == "255" }

config system accprofile
    edit "tfuserprofile"
        set secfabgrp read-write
        set ftviewgrp read-write
        set authgrp read-write
        set sysgrp read-write
        set netgrp read-write
        set loggrp read-write
        set fwgrp read-write
        set vpngrp read-write
        set utmgrp read-write
        set wanoptgrp read-write
        set wifi read-write
    next
end

config system api-user
    edit "Terraform_RW_User"
        set comments "REST API admin for Terraform"
        set accprofile "tfuserprofile"
        set vdom "root"
        config trusthost
            edit 1
                set ipv4-trusthost ${fortigate_trusthost}
            next
        end
    next
end

%{ endif }
