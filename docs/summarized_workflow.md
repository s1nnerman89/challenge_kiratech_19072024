# Workflow

- [] Provision con packer 
- [] Configura con ansible
- [] Provisioning kubernetes con Terraform:
	- [] installa manager e due worker, configura modo cluster
	- [] Crea namespace "kiratech-test"
	- [] Benchmark security opensource e pubblico
- [] Deploy applicazione opensource con 3 servizi tramite Helm
	- [] Impostare HA in modo da minimizzare downtime durante aggiornamenti
- [] Impostare continuous integration su tool a scelta (Drone? forse meglio github runners?)
	- [] Impostare linting di Terraform, Ansible, Helm