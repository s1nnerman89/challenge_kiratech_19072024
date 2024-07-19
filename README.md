# challenge_kiratech_19072924
Repository for solving my hiring challenge @ Kiratech

## Fase 1 - Creazione VM da destinare al cluster Kubernetes

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
- I file di configurazione sono stati testati con successo su un nodo Proxmox 8.2.4; le golden images create sono state utilizzate nelle fasi successive.

## Fase 2 - Deployment delle VMs target a partire dalle golden images

### Motivazione delle scelte di progettazione

### Lista delle operazioni svolte