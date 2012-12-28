#!/bin/bash
PATH=$PATH:'/opt/nodejs/bin'

APP_DIR='/opt/kfmjs/kites/dnsHosting/'
APP_FILE='dnsClient.coffee'


PID_FILE="/var/log/dnsApi.pid"
LOG_FILE="/var/log/dnsApi.log"

cd ${APP_DIR}
if [ "$1" == "start" ]; then
    if [[ -e ${PID_FILE} ]] &&  ps aux | grep $(cat ${PID_FILE})|grep -v grep 1>>/dev/null 2>> ${LOG_FILE} ; then
        echo "failed to start $0. already running" >> ${LOG_FILE}
        exit 1
    fi

    if [ -e ${PID_FILE} ];then
        rm ${PID_FILE}
    fi

    echo "starting with coffee ${APP_FILE}" >> ${LOG_FILE}
    if  ! coffee ${APP_FILE} >>${LOG_FILE} 2>&1 ; then
        if [ $? -gt 0 ];then # handle Ctrl+C
            echo "Can't start ${APP_FILE}" >> ${LOG_FILE}
            exit 1
        fi
    fi


elif [ "$1" = "stop" ]; then
    if  kill $(cat ${PID_FILE}) 2>> ${LOG_FILE} ; then
        echo "process ${APP_FILE} killed with 15" >> ${LOG_FILE}
        rm ${PID_FILE}
    else
        echo "Can't kill ${APP_FILE}"
    fi
else
    echo "Usage: $0 start/stop"
fi

