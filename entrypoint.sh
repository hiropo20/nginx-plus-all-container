#!/usr/bin/env bash

USER=nginx
LOGDIR=/var/log/adm
mkdir -p /var/run/adm /tmp/cores ${LOGDIR}
chmod 755 /var/run/adm /tmp/cores ${LOGDIR}
chown ${USER}:${USER} /var/run/adm /tmp/cores ${LOGDIR}

/bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx
/bin/su -s /bin/bash -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 >> /var/log/app_protect/bd-socket-plugin.log &" nginx

/bin/su -s /bin/bash -c "/usr/bin/adminstall --daemons 1 --memory 200 > ${LOGDIR}/adminstall.log 2>&1" ${USER}
/bin/su -s /bin/bash -c "/usr/bin/admd -d --log info > ${LOGDIR}/admd.log 2>&1 &" ${USER}

/usr/sbin/nginx -g 'daemon off;'
