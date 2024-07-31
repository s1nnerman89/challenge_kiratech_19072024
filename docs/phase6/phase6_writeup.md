# Write-up Fase 6 della Challenge

# DA ULTIMARE

## Obiettivo: Configurazione di una pipeline di Continuous Integration per il linting del codice

### Motivazione delle scelte di progettazione

# RICONTROLLARE ORDINE, ELIMINARE DOPPIONI ED ESPANDERE

- E' stato scelto DroneCI come piattaforma di Continuous Integration (CI) per la familiarità avuta con lo strumento;
- E' stato scelto Gitea come piattaforma di Source Code Management (SCM) per la familiarità avuta con lo strumento;
- Il file di configurazione di Drone non è stato lasciato nella root della repository in quanto non è stata collegata un'istanza di DroneCI all'account GitHub utilizzato per questa repository ma è stato spostato nella cartella relativa a questa fase della challenge come soluzione;
    - La pipeline sviluppata è stata comunque testata con successo utilizzando le mie personali istanze di SCM (Gitea) e CI (Drone CI) configurate e attive nel mio homelab;
- E' stato scelto [`tflint`](https://github.com/terraform-linters/tflint) come software di linting per il codice Terraform in quanto ampiamente utilizzato per lo scopo e grazie alla disponibilità di un'immagine docker utilizzabile nella pipeline di DroneCI;
- E' stato scelto [`chart-testing`](https://github.com/helm/chart-testing) come software di linting per il codice Helm in quanto strumento ufficiale sviluppato dalla stessa organizzazione di Helm e grazie alla disponibilità di un'immagine docker utilizzabile nella pipeline di DroneCI;
- E' stato scelto [`ansible-lint`](https://github.com/ansible/ansible-lint) come software di linting per il codice Ansible in quanto strumento ufficiale sviluppato dalla stessa organizzazione di Ansible e grazie alla disponibilità di un'immagine docker utilizzabile nella pipeline di DroneCI;
- La pipeline creata è basata sul funzionamento tramite container effimeri Docker per garantire l'esecuzione di codice in sicurezza;
- La pipeline creata viene chiamata ad ogni commit eseguito verso la repository Gitea.

### Lista delle operazioni svolte

# RICONTROLLARE ORDINE, ELIMINARE DOPPIONI ED ESPANDERE

- Generata pipeline di tipo `docker` con triggers di tipo `commit` su branch 'main' su DroneCi;
- Configurato step 'Terraform linter' di linting del codice Terraform;
    - Non sono state incluse le cartelle contenenti i piani Terraform in quanto lanciare `tflint` dovrebbe comunque considerare tutti i file presenti nella repository.
- Configurato step 'Helm Linter' di linting del codice Helm;
    - Esecuzione dello step limitata alle sole cartelle della repository contenenti codice Helm;
- Configurato step 'Ansible Linter' di linting del codice Ansible;
- IMPORTANTE /!\\ - RICONFIGURARE CODICE PIPELINE IN MODO DA TRIGGERARE UNA BUILD AD OGNI PUSH - AGGIORNARE ANCHE QUESTO WRITEUP
- I test del codice creato sono stati eseguiti con successo su un nodo Proxmox 8.2.4 utilizzando l'ambiente di sviluppo descritto nel file README.