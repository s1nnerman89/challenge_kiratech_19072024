# Write-up Fase 5 della Challenge

## Obiettivo: Deployment di un applicazione con almeno tre servizi utilizzando Helm

### Motivazione delle scelte di progettazione

- E' stata scelta `firefly-iii` come app d'esempio in quanto basata su 3 servizi (app, mariadb, redis) come richiesto dalla challenge;
- E' stato usato un server NFS situato su una VM esterna al cluster k8s (VM 'makemake', IP: '192.168.0.104') montato su `/mnt/kiratech-nfs` per garantire la funzionalità di dynamic provisioning.

### Lista delle operazioni svolte

# RICONTROLLARE ORDINE OPERAZIONI

- Aggiunta la repo di k8s-at-home per Helm ESPANDERE
    ``
- Configurato driver NFS per k8s per salvare i PV su un server NFS esterno al cluster
    - Creata storage class ESPANDERE
    - Creato PV Claim ESPANDERE
- Modificato file values ESPANDERE
    - Lista delle modifiche effettuate: ESPANDERE
- Installato Helm ESPANDERE
- Configurata repo k8s-at-home ESPANDERE
- Installato driver `nfs-csi` ESPANDERE
- Creata StorageClass per 'nfs-csi' ESPANDERE
- Configurato PVC per NFS Server su VM 'makemake' ESPANDERE
- Scaricata chart di firefly-iii e relativo file `values.yaml` ESPANDERE
- Effettuate le seguente modifiche al file `values.yaml`: ESPANDERE
    ```
    ```
- Effettuato deployment dell'applicazione tramite comando: ESPANDERE
    ``
- I test del codice creato sono stati eseguiti con successo su un nodo Proxmox 8.2.4 utilizzando l'ambiente di sviluppo descritto nel file README.