.PHONY: postcreate
postcreate:
	npm run npm:install:development
	npm run build

.PHONY: start
start:
	npm run build
	npm run start

.PHONY: composeclean
composeclean:
	docker compose down --remove-orphans

.PHONY: composeclear
composeclear: composeclean
	docker compose down --volumes --remove-orphans
