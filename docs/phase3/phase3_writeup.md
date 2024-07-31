# Write-up Fase 3 della Challenge

## Obiettivo: Configurazione delle VMs come nodi del cluster Kubernetes tramite Ansible

### Motivazione delle scelte di progettazione

- E' stato utilizzato l'utente `ansible` generato al momento della creazione delle golden images con HCP Packer;
- E' stato scelto il playbook [kube-dependencies](https://github.com/torgeirl/kubernetes-playbooks/blob/main/playbooks/kube-dependencies.yml) poichè conteneva tutte le task necessarie alla creazione della VM
    - Prima di eseguirne il deployment, il playbook è stato accuratamente letto per controllare che non contenesse codice insicuro;
    - Sono state eseguite alcune personalizzazioni al codice, in particolare:
        ```
        - Installati docker-ce e docker-ce-cli, versione 5:24.0.9-1~ubuntu.22.04~jammy (Necessario per provider Terraform `rke` usato nella fase 4);
        - Aggiunto utente `ansible` al gruppo `docker` per garantire il funzionamento del provider Terraform `rke` usato nella fase 4;
        - Aggiunta linea '127.0.0.1 localhost' al file `/etc/hosts` per assicurare ai pod k8s la corretta risoluzione dei record DNS;
            - Per una causa non investigata per mancanza di tempo, le VMs sono state configurate senza il record localhost nel loro file hosts; ciò impediva un corretto portforward dal pod k8s alla macchina locale, rendendo quindi impossibile accedere all'applicazione istanziata sul cluster k8s; è stato deciso di applicare il fix come task inclusa nel playbook ansible finchè non si identifica la vera causa di questo comportamento
        ```
        - NOTA: per mancanza di tempo non si è controllato se le task di installazione di kubeadm e kubelet siano ridondanti nel caso di deployment del cluster k8s utilizzando il provider Terraform `rke`; probabilmente si, in quanto il playbook installa le versioni 1.29 degli applicativi mentre il provider Terraform `rke` sembra installare la versione 1.28.7. In futuro si potrebbe pensare di snellire il playbook rimuovendo le task in oggetto.
    - Alcune delle task del playbook (installazione `kubelet`, `kubeadm`) potrebbero esse ridondanti a causa del metodo di deployment del cluster k8s scelto; a causa dei constraints di tempo nell'eseguire la challenge non è stato possibile verificare questa ipotesi ma in futuro si potrebbe ottimizzare ulteriormento il flow d'esecuzione;
    - Dal linting del codice operato durante la fase 6 della challenge, sono emersi diverse criticità a livello di qualità del codice. In futuro si potrebbero applicare i consigli generati dal linter per migliorare la qualità del playbook.
- L'utente di Ansible utilizzato per la connessione alle macchine target è stato configurato durante la creazione del template delle VMs (avvenuta nella fase 1).

### Lista delle operazioni svolte

- Creato file di inventario 'kiratech_inventory.yaml' nella cartella 'inventory';
- Creato file di configurazione di ansible 'ansible.cfg';
    - E' stato utilizzato per disabilitare il check delle fingerprint dei server ssh e snellire il processo di testing.
- Creato file con permessi '600' contenente la password unix dell'utente 'ansible' configurato sulle VMs target;
- Copiata chiave privata ssh creata nella fase 1 utilizzata per la connessione ssh alle VMs target;
    - La chiave è stata impostata con permessi '600';
- Applicate le modifiche precedentemente menzionate al playbook sorgente;
- Eseguito playbook tramite il comando:
    ```
    ansible-playbook \
    -i inventory/kiratech_inventory.yaml \
    -e nodes=all
    -u ansible \
    --private-key ansible_ssh_key.key \
    --become \
    --become-password-file=ansible_sudo_password.txt \
    playbook/config_k8s_dependencies.yml
    ```
- I test del codice creato sono stati eseguiti con successo su un nodo Proxmox 8.2.4 utilizzando l'ambiente di sviluppo descritto nel file README.