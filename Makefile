.PHONY: bootstrap
bootstrap:
	sh ./etc/script/bootstrap.sh

.PHONY: generate
generate:
	sh ./etc/script/generate.sh

.PHONY: generate-no-open
generate-no-open:
	sh ./etc/script/generate.sh --no-open