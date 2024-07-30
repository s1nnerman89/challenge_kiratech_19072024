# Write-up Fase 5 della Challenge

## Obiettivo: Deployment di un applicazione con almeno tre servizi utilizzando Helm

### Motivazione delle scelte di progettazione

- E' stata scelta la repository [k8s-at-home](https://github.com/k8s-at-home/charts) in quanto dotata di una buona documentazione per il deployment delle applicazioni offerte, una buona presenza su canali di supporto come Discord o Reddit e comunque basata su immagini affidabili come quelle di Bitnami;
- E' stata scelta `firefly-iii` come app d'esempio in quanto basata su 3 servizi (firefly-iii-app, mariadb, redis) come richiesto dalla challenge e per la familiarità avuta con il deployment tramite 'docker-compose' e la sua successiva configurazione;
- E' stato usato un server NFS situato su una VM esterna al cluster k8s (VM 'makemake', IP: '192.168.0.104', configurata sul nodo Proxmox 'pve-1' dello scenario di testing descritto nel README) montato sulla cartella `/mnt/kiratech-nfs` per garantire la funzionalità di dynamic provisioning e assicurare una sorta di HA utilizzando uno storage "decentralizzato" e non locale a uno dei nodi del cluster.
    - Per far eseguire il dynamic provisioning a k8s sul server NFS configurato è stato utilizzato il driver [csi-driver-nfs](https://github.com/kubernetes-csi/csi-driver-nfs), il quale permette la creazione di PersistentVolumes (PV) come subdirectory della root del server NFS utilizzando i PersistentVolumeClaims (PVC);
    - Ovviamente soluzioni realmente decentralizzate di storage come Ceph sarebbero più adatte allo scopo, ma non avendole configurate nell'homelab e avendo dei constraints di tempo ben definiti per lo sviluppo della soluzione alla challenge, si è optato per un sistema più semplice.
- Tutte le password utilizzate in questo deployment sono stringhe di 32 caratteri alfanumerici random generati tramite il comando `pwgen -s 32`.

### Lista delle operazioni svolte

- Installato Helm seguendo la procedura ufficiale:
    ```
    wget -O ./helm.tar.gz https://get.helm.sh/helm-v3.15.3-linux-amd64.tar.gz
    tar -zxvf helm.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm
    ```
- Aggiunta la repo di k8s-at-home per Helm:
    `helm repo add k8s-at-home https://k8s-at-home.com/charts/`
- Aggiornato catalogo repo di Helm:
    `helm repo update`
- Configurato driver NFS per k8s per salvare i PV su un server NFS esterno al cluster seguendo la procedura ufficiale del driver:
    - Installato driver tramite Helm:
        ```
        helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs \
            --namespace kube-system \
            --version v4.8.0 \
            --set externalSnapshotter.enabled=true \
            --set controller.replicas=2
        ```
    - Creata StorageClass (SC) 'k8s_deployments/sc-nfs.yml' per rendere disponibile l'uso del driver:
        `kubectl apply -f k8s_deployments/sc-nfs.yml`
    - Creato PVC k8s_deployments/pvc-nfs-csi.yml sul namespace 'kiratech-test':
        `kubectl apply -n kiratech-test -f k8s_deployments/pvc-nfs-csi.yml`
- Scaricata chart di firefly-iii `helm_charts/firefly-iii/Chart.yaml` e relativo file `helm_charts/firefly-iii/values.yaml`;
    - Il file `helm_charts/firefly-iii/values.yaml` è stato modificato applicando la seguente configurazione:
        ```
        - Applicata strategia 'rollingUpdate' per minimizzare il downtime durante gli aggiornamenti dell'applicazione;
            - Sono stati inoltre configurati i parametri 'revisionHistoryLimit', 'unavailable', 'surge' relativi alla strategia 'rollingUpdate';
        - Abilitati i server 'mariadb' e 'redis';
            - Sono state inoltre configurate le variabili d'ambiente dell'applicazione per permettere l'interazione con i server 'mariadb' e 'redis';
        - Configurate alcune variabili d'ambiente dell'applicazione:
            - Timezone;
            - APPKEY;
        - Abilitata persistenza dei volumi dei server 'mariadb' e 'redis' su server NFS esterno utilizzando il PVC 'pvc-nfs-csi' precedentemente creato;
        - Abilitata authenticazione tramite password per i server 'mariadb' e 'redis';
            - Per 'mariadb' è stato anche creato un utente dedicato chiamato 'firefly' specificatamente per l'app oggetto della challenge.
        ```
    - Trattandosi di un deployment eseguito su un ambiente bare-metal, non è stato possibile configurare l'opzione `LoadBalancer` per il servizio dell'app, la quale funziona solo su ambienti managed come GCP o AWS; una soluzione (non implementata per mancanza di tempo) per aggirare il problema in ambiente bare-metal sarebbe potuta essere l'installazione di `MetalLB`
- Effettuato deployment sul namespace 'kiratech-test' dell'applicazione tramite comando:
    `helm install -n kiratech-test kiratech-firefly-iii k8s-at-home/firefly-iii -f helm_charts/firefly-iii/values.yaml`
- Verificato il corretto deployment dell'applicazione e dei servizi sul namespace 'kiratech-test':
    `kubectl -n kiratech-test get all`
- Eseguito forwarding del pod di 'firefly-iii' sulla macchina locale:
    `kubectl port-forward -n kiratech-test svc/kiratech-firefly3-firefly-iii --address 0.0.0.0 8080:8080`
- I test del codice creato sono stati eseguiti con successo su un nodo Proxmox 8.2.4 utilizzando l'ambiente di sviluppo descritto nel file README.