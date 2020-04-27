
#!/bin/bash
current_dir=$(dirname $0)
act_workspace=${ACT_WORKSPACE:-${current_dir/\./$PWD}}
github=( "https://github.com/simonsobs/pixell")

function prepare_workspace() {
    (
        cd ${act_workspace}
        for gh in "${github[@]}"; do
            local http=$(echo ${gh} | awk -F, '{print $1}')
            local branch=$(echo ${gh} | awk -F, '{print $2}')
            local name=$(echo ${http} | awk -F/ '{print $NF}')
            if [ ! -d ${name} ]; then
                msg_notice "Cloning '${name}' into ${ACT_workspace}..."
                git clone ${http}
                [[ ! -z ${branch} ]] && (cd ${name} && git checkout origin/${branch} -b ${branch})
                continue
            else
                msg_notice "Package '${name}' already cloned."
            fi
        done
    )
    cid_file="${act_workspace}/.cid"
    return 0
}

function start_docker() {
    msg_notice "Starting ACT docker..."
    msg_notice "Type exit when you are done"
    [[ -f ${cid_file} ]] && rm -f ${cid_file}

    local docker_options="-it -p 8888:8888"
    return 0
}

function stop_docker() {
    msg_notice "Stopping ACT docker."
    if [ ! -z ${cid_file} ]; then
        cid_value=$(cat ${cid_file})
        docker rm ${cid_value} > /dev/null 2>&1
    fi
    return 0
}

function main() {
    prepare_workspace
    start_docker
    stop_docker
}

main


