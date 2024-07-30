# Write-up Fase 2 della Challenge

## Obiettivo: Deployment delle VMs target tramite HCP Terraform a partire dalle golden images

### Motivazione delle scelte di progettazione

- E' stato scelto `Proxmox` come hypervisor target delle virtual machine poichè è la soluzione con la quale posseggo maggior familiarità;
- E' stato scelto `cloud-init` come utility di provisioning delle VMs target poichè è la soluzione con la quale posseggo maggior familiartà e grazie all'ampio supporto di Ubuntu (sistema operativo utilizzato nelle VMs target) verso questa tecnologia;
- I file di configurazione di Terraform (compresi i file di configurazione di cloud-init delle singole VM target) sono stati creati basandomi su configurazioni personali create per il mio homelab.
- k8s richiede indirizzi IP statici; le VM sono state configurate in modalità "dhcp" e l'IP statico viene assegnato automaticamente dal router (pfSense nello scenario di testing) tramite static entry basata sul MAC della virtual machine nel suo DHCP Server. E' stato scelto questo approccio invece che la definizione di un ip statico a livello del SO non per un motivo particolare ma perchè non erano state fornite indicazioni specifiche nel testo della challenge.

### Lista delle operazioni svolte

- Definito file `auto.tfvars` di Terraform per la dichiarazione delle variabili comuni di connessione all'hypervisor e la password dell'utente ansible che verrà utilizzata nella fase 3;
    - In futuro si potrebbe aumentare la sicurezza di questo plan utilizzando un gestore di segreti come HCP Vault per la gestione dei dati sensibili.
- Definito file di configurazione del provider di Terraform per Proxmox;
- Definiti file `.yaml` all'interno della cartella `files` necessari alla configurazione delle VMs target tramite `cloud-init`;
- Definito file `kiratech_cluster.tf` in cui viene dichiarata tutta l'infrastruttura richiesta dallo scope della challenge:
    - 1x VM Ubuntu Server 22.04 con requisiti hardware minimi per nodo 'manager' di Kubernetes;
    - 2x VMs Ubuntu Server 22.04 con requisiti hardware minimi per nodo 'worker' di Kubernetes;
    - 3x Configuration snippets di cloud-init per il provisioning iniziale delle VMs target comprendenti:
        ```
        - Configurazione timezone;
        - Aggiornamento database APT e upgrade pacchetti APT preinstallati;
        - Configurazione di un utente con capacità `sudoer` con password e chiavi ssh autorizzate per l'accesso remoto.
        ```
- Installati i provider necessari al funzionamento del plan Terraform:
    `terraform init`
- Validato plan applicato da Terraform tramite: 
    `terraform plan`
- Applicato plan approvato di Terraform tramite:
    `terraform apply`
- I test del codice creato sono stati eseguiti con successo su un nodo Proxmox 8.2.4 utilizzando l'ambiente di sviluppo descritto nel file README.