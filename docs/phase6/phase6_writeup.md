# Write-up Fase 6 della Challenge

## Obiettivo: Configurazione di una pipeline di Continuous Integration per il linting del codice

### Motivazione delle scelte di progettazione

# RICONTROLLARE ORDINE, ELIMINARE DOPPIONI ED ESPANDERE

- E' stato scelto DroneCI perchè ESPANDERE
- Il file di configurazione di Drone non è stato lasciato nella root della repository in quanto non è stata collegata un'istanza di DroneCI all'account GitHub utilizzato per questa repository ma è stato spostato nella cartella relativa a questa fase della challenge a mo' di soluzione.
    - La pipeline è stata comunque testata con successo utilizzando le mie personali istanze di SCM (Gitea) e CI (Drone CI) configurate e attive nel mio homelab
- E' stato usato `DroneCI` come piattaforma di CI/CD grazie alla familiarità possieduta con questa tecnologia e un istanza già funzionante nel mio homelab
- E' stato scelto `tflint`
- E' stato scelto `chart-testing`
- E' stato scelto `ansible-lint`

### Lista delle operazioni svolte

# RICONTROLLARE ORDINE, ELIMINARE DOPPIONI ED ESPANDERE

- Generata pipeline di tipo docker su DroneCi
    - La pipeline è stata configurata in modo da venire eseguita ad ogni nuovo commit
- Configurato step di linting del codice Terraform
    - Non sono state incluse le cartelle contenenti i piani Terraform in quanto lanciare `tflint` dovrebbe comunque considerare tutti i file presenti nella repository
- Configurato step di linting del codice Helm
- Configurato step di linting del codice Ansible
- IMPORTANTE /!\\ - RICONFIGURARE CODICE PIPELINE IN MODO DA TRIGGERARE UNA BUILD AD OGNI COMMIT
- I test sono stati eseguiti con successo su un nodo Proxmox 8.2.4.