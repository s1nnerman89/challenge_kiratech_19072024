# Write-up Fase 4 della Challenge

# DA ULTIMARE

## Obiettivo: Provisioning del cluster k8s utilizzando Terraform

### Motivazione delle scelte di progettazione
 
- E' stato scelto `rke` come provider Terraform perchè consigliato nei forum e nei subreddit della community del self-hosting come buona soluzione per il deployment di un cluster k8s tramite Terraform;
- E' stato scelto `kubernetes` come provider Terraform in quanto è il provider ufficiale di Hashicorp per far interagire Terraform con un cluster k8s;
- E' stato scelto `kube-bench` come benchmark di sicurezza perchè nonostante non fosse dettagliato come NIST, aderire al quale rappresenta per esempio una condizione necessaria in ambienti governativi negli USA, ho ritenuto rappresentasse una buona panoramica su quelle che possono essere le possibili falle di sicurezza derivanti da un cluster k8s configurato con parametri di default;
    - In particolare, è stato scelto il benchamrk `rke2-cis-1.7` perchè consigliato dal creatore per cluster di tipo `rke` ([Fonte:](https://github.com/aquasecurity/kube-bench/blob/main/docs/running.md))
    - Per mancanza di tempo, è stato eseguito il benchmark di sicurezza senza però mettere in pratica le raccomandazioni; il cluster configurato può quindi presentare possibili vulnerabilità non mitigate e prima di un deployment in un vero ambiente di produzione andrebbero per lo meno applicati i suggerimenti proposti dal benchmark.
    - Per motivi di sicurezza non sono stati inclusi i logfile completi di kube-bench, ma sono disponibili su richiesta.

### Lista delle operazioni svolte

- Creazione file provider 'provider.tf' di Terraform;
    - E' stato configurato il logging per il provider 'rke', disabilitato successivamente in produzione;
    - Il provider 'kubernetes' viene configurato tramite il file 'kube_config' generato dal provider 'rke' alla fine del deployment.
- Creazione file variabili 'variables.tf' di Terraform contenenti tutti i parametri usati nel piano dai provider;
- Creazione file 'auto.tfvars' per il passaggio dei valori alle variabili all'interno del piano;
    - In futuro si potrebbe aumentare la sicurezza di questo plan utilizzando un gestore di segreti come HCP Vault per la gestione dei dati sensibili.
- Creazione plan Terraform ESPANDERE
- Terraform init ESPANDERE
- Terraform plan ESPANDERE
- Terraform apply ESPANDERE
- Scaricato `kubectl` usando il comando fornito dalla procedura ufficiale su una VM esterna al cluster:
    `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"` 
- Utilizzato `kubectl` per scaricare da remoto il log d'esecuzione di `kube-bench` tramite il comando:
    `kubectl logs kube-bench-7pdfc -n kiratech-test -s https://192.168.0.103:6443 --insecure-skip-tls-verify=true --kubeconfig=config/kube_config.yaml > logs/kube-bench.log`
- I test sono stati eseguiti con successo su un nodo Proxmox 8.2.4.