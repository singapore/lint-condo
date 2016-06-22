run: build test

build:
	@docker build -t singapore/lint-condo .

test:
	@docker run -v ${PWD}:/src/ singapore/lint-condo

.PHONY: run build test
