# Hiring challenge for Kiratech

## Introduzione

In questa repository è stato caricato tutto il codice necessario alla risoluzione della challenge affidatami dall'hiring manager di Kiratech. 

## Obiettivi della challenge

- [X] Creazione template VMs per macchine del cluster Kubernetes (k8s) tramite **HCP Packer**
    - [X] Template nodo 'master' k8s;
    - [X] Template nodo 'worker' k8s.
- [X] Deployment *template-based* delle VMs da usare come nodi del cluster k8s tramite **HCP Terraform**
    - [X] 1x nodo con requisiti minimi di 'master' per cluster k8s;
    - [X] 2x nodi con requisiti minimi di 'worker' per cluster k8s;
- [X] Provisioning delle VMs del cluster k8s tramite playbook **Ansible**
- [X] Deployment di un cluster k8s sulle VMs target tramite **HCP Terraform**
    - [X] Deployment cluster k8s formato da 1x nodo 'master' e 2x nodi 'worker';
    - [X] Creazione del namespace 'kiratech-test';
    - [X] Esecuzione di un benchmark di sicurezza a scelta.
- [X] Deployment di un applicazione sul cluster k8s tramite **Helm**
    - Requisiti applicazione:
        - Minimizzazione downtime durante aggiornamenti;
        - Utilizzo di almeno tre servizi.
- [X] Creazione di una pipeline di Continuous Integration per il linting del codice tramite un tool a scelta (**DroneCI**)
    - [X] Creazione di uno step della pipeline CI dedicato al linting del codice Terraform;
    - [X] Creazione di uno step della pipeline CI dedicato al linting del codice Ansible;
    - [X] Creazione di uno step della pipeline CI dedicato al linting del codice Helm;

## Struttura della repository

La challenge è stata suddivisa in sei fasi, ognuna organizzata in una propria cartella. Nel caso di uso di tool multipli per raggiungere l'obiettivo della fase, sono state create cartelle separate per ogni tool.
Per ogni fase sono stati inclusi tutti i file di configurazione usati con i vari tool (ad esempio, inventory file di Ansible, `auto.tfvar` file di Terraform, etc.) necessari a riprodurre la task nell'ambiente di sviluppo scelto.
I write-up relativi a ogni fase sono stati inclusi nella cartella `docs` presente nella root di questa repository.
E'stato effettuato uno scrub di tutti i dati sensibili (chiavi ssh, password, API tokens) da tutti i file di configurazione; sono stati mantenuti i file (vuoti) in cui erano presenti i vari segreti utilizzati dai tool della challenge per dare corrispondenza alle paths presenti nei file di configurazione.

## Ambiente di testing

Per completare la challenge sono stati utilizzati i seguenti tool:
    - HCP Packer (v1.10.3)
    - HCP Terraform (v1.8.4)
        - Sono stati inoltre usati i seguenti provider di terraform:
            - TheGameProfi/proxmox (v2.9.16)
            - rancher/rke (v1.5.0)
            - hashicorp/kubernetes (~> v2.31.0)
    - Ansible (v2.16.3)
    - Helm (v3.15.3)
    - Harness DroneCI (v2.24)

Le configurazioni sono state testate in diverse VM Ubuntu Server 22.04 in funzione su un cluster Proxmox 8.2.4 a due nodi. Tutte le VM usate nello scenario sono configurate con indirizzo statico tramite DHCP Server erogato da una macchina virtuale con pfSense, sul quale è stata configurata una static entry basata sull'indirizzo MAC della VM.

Lo scenario della challenge prevede l'uso delle seguenti VMs:

    | Nome VM          | Indirizzo IP  | Ruolo           |
    | ---------------- | ------------- | --------------- |
    | kiratech-mngr-01 | 192.168.0.103 | k8s Master Node |
    | kiratech-wrkr-01 | 192.168.0.101 | k8s Worker Node |
    | kiratech-wrkr-02 | 192.168.0.102 | k8s Worker Node |
    | makemake         | 192.168.0.104 | NFS Server      |

## Fase 4 - Provision del cluster k8s utilizzando Terraform

### Motivazione delle scelte di progettazione

- E' stato scelto `rke` come provider Terraform perchè
- E' stato scelto `kubernetes` come provider Terraform perchè
- E' stato scelto `kube-bench` come benchmark di sicurezza perchè
    - In particolare, è stato scelto il benchamrk `rke2-cis-1.7` perchè consigliato dal creatore per cluster di tipo `rke` ([Fonte:](Recommended for rancher clusters https://github.com/aquasecurity/kube-bench/blob/main/docs/running.md))
- Per motivi di sicurezza non sono stati inclusi i logfile completi di kube-bench, ma sono disponibili su richiesta.

### Lista delle operazioni svolte

- Scaricato `kubectl` usando il comando fornito dalla procedura ufficiale su una VM esterna al cluster:
    `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"` 
- Utilizzato `kubectl` per scaricare da remoto il log d'esecuzione di `kube-bench` tramite il comando:
    `kubectl logs kube-bench-7pdfc -n kiratech-test -s https://192.168.0.103:6443 --insecure-skip-tls-verify=true --kubeconfig=config/kube_config.yaml > logs/kube-bench.log`
- I test sono stati eseguiti con successo su un nodo Proxmox 8.2.4.

## Fase 5 - Deployment di un applicazione con almeno tre servizi utilizzando Helm

### Motivazione delle scelte di progettazione

- E' stata scelta `firefly-iii` come app d'esempio in quanto basata su 3 servizi (app, mariadb, redis) come richiesto dalla challenge
- E' stato usato un server NFS situato su una VM esterna al cluster k8s (VM 'makemake', IP: '192.168.0.104') montato su `/mnt/kiratech-nfs` per garantire la funzionalità di dynamic provisioning

### Lista delle operazioni svolte

- Aggiunta la repo di k8s-at-home per Helm
- Configurato driver NFS per k8s per salvare i PV su un server NFS esterno al cluster
    - Creata storage class
    - Creato PV Claim
- Modificato file values
    - Lista delle modifiche effettuate:
- I test sono stati eseguiti con successo su un nodo Proxmox 8.2.4.

## Fase 6 - Configurazione di una pipeline di Continuous Integration per il linting del codice

### Motivazione delle scelte di progettazione

- E' stato usato `DroneCI` come piattaforma di CI/CD grazie alla familiarità possieduta con questa tecnologia e un istanza già funzionante nel mio homelab
- E' stato scelto `tflint`
- E' stato scelto `chart-testing`
- E' stato scelto `ansible-lint`

### Lista delle operazioni svolte

- I test sono stati eseguiti con successo su un nodo Proxmox 8.2.4.
