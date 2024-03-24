config system global
    set hostname "${hostname}"
end
config system admin
    edit admin
        set password ${admin_password}
    next
end
config system interface
    edit ${port1}
        set mode static
        set ip ${port1_ip} ${port1_mask}
        set allowaccess ping https ssh http fgfm probe-response
        set description "ext"
        set secondary-IP enable
        config secondaryip
        edit 1
        set ip ${external_ilbnh_ip} 255.255.255.255
        set allowaccess probe-response
        next
        end
    next
    edit ${port2}
        set mode static
        set ip ${port2_ip} ${port2_mask}
        set allowaccess ping https ssh http fgfm probe-response
        set description "int"
        set secondary-IP enable
        config secondaryip
        edit 1
        set ip ${internal_ilbnh_ip} 255.255.255.255
        set allowaccess probe-response
        next
        end
    next
    edit ${port3}
        set mode static
        set ip ${port3_ip} ${port3_mask}
        set allowaccess ping https ssh http fgfm probe-response
        set description "sync"
    next
    edit ${port4}
        set mode static
        set ip ${port4_ip} ${port4_mask}
        set allowaccess ping https ssh http fgfm probe-response
        set description "hamgmt"
    next
    edit "loopback"
        set vdom "root"
        set ip 192.168.199.1 255.255.255.255
        set allowaccess ping probe-response
        set type loopback
        set role lan
    next
end
config system ha
    set group-name "hagroup1"
    set mode a-p
    set hbdev "${port3}" 50
    set session-pickup enable
    set ha-mgmt-status enable
    config ha-mgmt-interfaces
        edit 1
            set interface "${hamgmt_port}"
            set gateway ${hamgmt_gateway_ip}
        next
    end
    set override enable
    set priority ${ha_priority}
    set unicast-hb enable
    set unicast-hb-peerip ${hb_ip}
    set unicast-hb-netmask ${hb_netmask}
end
config router static
    edit 1
       set device ${port1}
       set gateway ${port1_gateway}
    next
    edit 2
       set dst ${private_subnet}
       set device ${port2}
       set gateway ${port2_gateway}
    next
    edit 3
       set dst 35.191.0.0 255.255.0.0
       set device ${port2}
       set gateway ${port2_gateway}
    next
    edit 4
       set dst 130.211.0.0 255.255.252.0
       set device ${port2}
       set gateway ${port2_gateway}
    next
   edit 5
       set dst 35.191.0.0 255.255.0.0
       set device ${port1}
       set gateway ${port1_gateway}
    next
    edit 6
       set dst 130.211.0.0 255.255.252.0
       set device ${port1}
       set gateway ${port1_gateway}
    next
    edit 7
       set dst ${public_subnet}
       set device ${port1}
       set gateway ${port1_gateway}
    next
end
config system vdom-exception
    edit 1
        set object system.interface
    next
end
config firewall vip
    edit "lb-probe"
        set extip "${fgt_public_ip}"
        set extintf "port1"
        set portforward enable
        set mappedip "192.168.199.1"
        set extport ${lb_probe_port}
        set mappedport ${lb_probe_port}
    next
end
config system probe-response
set mode http-probe
end
config firewall service custom
    edit "ProbeService-${lb_probe_port}"
        set comment "Default Probe for GCP on port ${lb_probe_port}"
        set tcp-portrange ${lb_probe_port}
    next
end
config firewall policy
    edit 2
        set name "DefaultGCPProbePolicy"
        set srcintf "${port1}"
        set dstintf "loopback"
        set srcaddr "all"
        set dstaddr "lb-probe"
        set action accept
        set schedule "always"
        set service "ProbeService-${lb_probe_port}"
        set nat enable
        set comments "Default Policy to allow GCP loadbalancer probe traffics on port ${lb_probe_port}"
    next
end