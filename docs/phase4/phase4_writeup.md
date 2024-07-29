# Write-up Fase 4 della Challenge

# DA ULTIMARE

## Obiettivo: Provisioning del cluster k8s utilizzando Terraform

### Motivazione delle scelte di progettazione
 
- E' stato scelto `rke` come provider Terraform perchè COMPLETARE
- E' stato scelto `kubernetes` come provider Terraform perchè COMPLETARE
- E' stato scelto `kube-bench` come benchmark di sicurezza perchè COMPLETARE
    - In particolare, è stato scelto il benchamrk `rke2-cis-1.7` perchè consigliato dal creatore per cluster di tipo `rke` ([Fonte:](https://github.com/aquasecurity/kube-bench/blob/main/docs/running.md))
- Per motivi di sicurezza non sono stati inclusi i logfile completi di kube-bench, ma sono disponibili su richiesta.

### Lista delle operazioni svolte

- Creazione file provider ESPANDERE
- Creazione file variabili ESPANDERE
- Creazione file auto.tfvars ESPANDERE
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