#!/usr/bin/env bash
export WORKSPACE=$1
[[ "$1" == "" ]] && {
    echo "ERROR: missing workspace"
    exit 1;
}
shift

export SSH_HOST=root@$WORKSPACE.enormous.cloud

[[ "$1" == "clean" ]] && {
    shift
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        $SSH_HOST 'cd /opt/terraform/ && find . -name "*.tf" -exec rm -rf {} \;'
}

[[ "$1" == "publish" ]] && {
    shift
    rsync -a --progress \
        --exclude '.terraform' \
        --exclude '*.hcl' \
        --exclude '*.json' \
        -r $(pwd)/ $SSH_HOST:/opt/
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        $SSH_HOST 'cd /opt/terraform/workspaces/'$WORKSPACE' && terraform init && terraform apply -auto-approve'
}