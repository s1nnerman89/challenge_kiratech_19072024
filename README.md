# challenge_kiratech_19072924
Repository for solving my hiring challenge @ Kiratech

## Fase 1 - Creazione VM da destinare al cluster Kubernetes tramite HCP Packer

### Motivazione delle scelte di progettazione

- E' stato deciso di realizzare delle golden images delle virtual machines oggetto del progetto in modo da rendere quest'ultimo più robusto e semplificarne il deployment;
- E' stato scelto `Proxmox` come hypervisor target delle virtual machine poichè è la soluzione con la quale posseggo maggior familiarità;
- E' stato scelto `Hashicorp Packer` come strumento per la creazione delle virtual machine poichè si tratta della soluzione con la quale posseggo maggior familiarità;
- I file di configurazione di Packer sono stati creati basandomi su configurazioni personali create per il mio homelab.

### Lista delle operazioni svolte

- Definite le virtual machine target con requisiti basati sul minimo indicato da Kubernetes:
    - `kiratech-mngr-template` - Template per la macchina Kubernetes con ruolo 'manager' con i seguenti requisiti:
        - CPU: 4 CPU
        - RAM: 4 GB
        - HDD: 64 GB
    - `kiratech-wrkr-template` - Template per le macchine Kubernetes con ruolo 'worker' con i seguenti requisiti:
        - CPU: 2 CPU
        - RAM: 2 GB
        - HDD: 64 GB
- Definito il file delle credenziali di connessione all'API di Proxmox (`credentials.pkr.hcl`);
- Definiti i file di configurazione di Packer per la creazione delle VM con i requisiti richiesti;
    - Sono stati aggiunti alcuni step di provisioning per la configurazione di `unattended-upgrades`, l'hardening del daemon `sshd` e l'installazione di Docker Engine e alcuni pacchetti di uso comune;
- Installati i plugin necessari (definiti nei file di configurazione) per connettere Packer all'API di Proxmox
    `packer init <.pkr.hcl file>`
- Testata validità configurazione:
    `packer validate -var-file="<cred_file>" <.pkr.hcl file>`
- Create golden images su target Proxmox:
    `packer build -var-file="<cred_file>" <.pkr.hcl file>`
- I test sono stati eseguiti con successo su un nodo Proxmox 8.2.4; le golden images create sono state utilizzate nelle fasi successive.

## Fase 2 - Deployment delle VMs target tramite HCP Terraform a partire dalle golden images

### Motivazione delle scelte di progettazione

- E' stato scelto `Proxmox` come hypervisor target delle virtual machine poichè è la soluzione con la quale posseggo maggior familiarità;
- E' stato scelto `cloud-init` come utility di provisioning delle VMs target poichè è la soluzione con la quale posseggo maggior familiartà e grazie all'ampio supporto di Ubuntu (sistema operativo utilizzato nelle VMs target) verso questa tecnologia;
- I file di configurazione di Terraform (compresi i file di configurazione di cloud-init delle singole VM target) sono stati creati basandomi su configurazioni personali create per il mio homelab.
- k8s richiede indirizzi IP statici; le VM sono state configurate in modalità "dhcp" e l'IP statico viene assegnato automaticamente dal router (pfSense nello scenario di testing) tramite static entry basata sul MAC della virtual machine nel suo DHCP Server. E' stato scelto questo approccio invece che la definizione di un ip statico a livello del SO non per un motivo particolare ma perchè non erano state fornite indicazioni specifiche nel testo della challenge.

### Lista delle operazioni svolte

- Definito file `auto.tfvars` di Terraform per la dichiarazione delle variabili comuni di connessione all'hypervisor e la password dell'utente ansible che verrà utilizzata nella fase 3
- Definito file di configurazione del provider di Terraform per Proxmox
- Definiti file `.yaml` all'interno della cartella `files` necessari alla configurazione delle VMs target tramite `cloud-init`
- Definito file `kiratech_cluster.tf` in cui viene dichiarata tutta l'infrastruttura richiesta dallo scope della challenge:
    - 1x VM Ubuntu Server 22.04 con requisiti hardware minimi per nodo 'manager' di Kubernetes;
    - 2x VMs Ubuntu Server 22.04 con requisiti hardware minimi per nodo 'worker' di Kubernetes;
    - 3x Configuration snippets di cloud-init per il provisioning iniziale delle VMs target comprendente:
        - Configurazione timezone;
        - Aggiornamento database APT e upgrade pacchetti APT preinstallati;
        - Configurazione di un utente con capacità `sudoer` con password e chiavi ssh autorizzate per l'accesso remoto;
- Validato plan applicato da Terraform tramite: 
    `terraform plan`
- Applicato plan approvato di Terraform tramite:
    `terraform apply`
- I test sono stati eseguiti con successo su un nodo Proxmox 8.2.4.

## Fase 3 - Configurazione delle VMs come nodi del cluster Kubernetes tramite Ansible

### Motivazione delle scelte di progettazione

- E' stato utilizzato l'utente `ansible` generato al momento della creazione delle golden images con HCP Packer;

### Lista delle operazioni svolte
