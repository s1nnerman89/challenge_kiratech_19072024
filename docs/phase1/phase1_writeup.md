# Write-up Fase 1 della Challenge

## Obiettivo: Creazione VMs da destinare al cluster Kubernetes tramite HCP Packer

### Motivazione delle scelte di progettazione

- E' stato deciso di realizzare delle golden images delle virtual machines oggetto del progetto in modo da rendere quest'ultimo più robusto e semplificarne il deployment;
- E' stato scelto [`Proxmox`](https://www.proxmox.com/en/) come hypervisor target delle virtual machine poichè è la soluzione con la quale posseggo maggior familiarità;
- E' stato scelto [`Hashicorp Packer`](https://www.hashicorp.com/products/packer) come strumento per la creazione delle virtual machine poichè si tratta della soluzione con la quale posseggo maggior familiarità;
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
- Creato un keypair SSH da utilizzare per la connessione alle VMs target durante le varie fasi della challenge;
- Definito il file delle credenziali di connessione all'API di Proxmox (`credentials.pkr.hcl`);
- Definiti i file di configurazione di Packer per la creazione delle VM con i requisiti richiesti;
    - Lista degli step di provisioning eseguiti da Packer:
    ```
    - Tweak configurazione cloud-init per garantire compatibilità con Packer;
    - Installazione di pacchetti .deb di uso comune;
    - Hardening configurazione ssh;
    - Configurazione di unattended-upgrades;
    - Impostata locale IT e lingua EN;
    - Installato e configurato neofetch per custom MOTD al login;
    - Disabilitato swap (richiesto da Kubernetes);
    - Riconfigurato TZDATA
    ```
- Installati i plugin necessari (definiti nei file di configurazione) per connettere Packer all'API di Proxmox:
    `packer init <.pkr.hcl file>`
- Testata validità configurazione:
    `packer validate -var-file="<cred_file>" <.pkr.hcl file>`
- Create golden images su target Proxmox:
    `packer build -var-file="<cred_file>" <.pkr.hcl file>`
- I test del codice creato sono stati eseguiti con successo su un nodo Proxmox 8.2.4 utilizzando l'ambiente di sviluppo descritto nel file README; le golden images create sono state utilizzate nelle fasi successive.