.PHONY: devcontainer
devcontainer:
	npm run npm:ci:development
	npm run build

.PHONY: start
start:
	npm run build
	npm run start
