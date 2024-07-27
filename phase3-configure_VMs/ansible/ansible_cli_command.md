ansible-playbook \
    -i inventory/kiratech_inventory.yaml \
    -e nodes=all
    -u ansible \
    --private-key ansible_ssh_key.key \
    --become \
    --become-password-file=ansible_sudo_password.txt \
    playbook/config_k8s_dependencies.yml

