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
    - [X] Deployment cluster k8s composto da:
        - 1x nodo 'master';
        - 2x nodi 'worker'.
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
I write-up relativi a ogni fase sono stati inclusi nella cartella `docs` presente in tutte le directory delle varie fasi.
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

    | Nome VM          | Indirizzo IP  | Nodo Cluster Proxmox | Ruolo           |
    | ---------------- | ------------- | -------------------- | --------------- |
    | kiratech-mngr-01 | 192.168.0.103 | pve-2                | k8s Master Node |
    | kiratech-wrkr-01 | 192.168.0.101 | pve-2                | k8s Worker Node |
    | kiratech-wrkr-02 | 192.168.0.102 | pve-2                | k8s Worker Node |
    | makemake         | 192.168.0.104 | pve-1                | NFS Server      |

## Disclaimer

Per quanto possibile, questa repository è stata utilizzata come ambiente di sviluppo degli script della challenge, ma soprattutto per gli script delle fasi 1 e 2, in cui è sato riutilizzato mio codice personale presente in altre repository private, l'history delle commit non rispecchia ogni singola modifica effettuata ai vari script.
