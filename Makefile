.PHONY: devcontainer
devcontainer:
	npm run npm:install
	npm run build

.PHONY: start
start:
	npm run build
	npm run start
