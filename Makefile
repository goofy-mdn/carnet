.DEFAULT_GOAL := help

# SERVER_DEST is defined in a `.env` file and follow this format: user@server.url:/path/to/website
include .env

.PHONY: boop
boop: ## Build the website with Boop! generator
	boop.py --development

.PHONY: clean
clean: ## Clean site files
	rm -rf ./_site

.PHONY: publish
publish:  ## Publish the website online (rsync)
	boop.py
	rsync -P -rvzc --cvs-exclude --delete ./_site/ $(SERVER_DEST)

.PHONY: open
open: boop  ## Open the built site in a web browser
	xdg-open _site/index.html

.PHONY: tree
tree:  ## Display the structure of the website
	tree -I _site --dirsfirst -CA

.PHONY: help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
