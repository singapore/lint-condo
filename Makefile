run: build test

build:
	@docker build -t singapore/lint-condo .

test:
	@docker run -v `pwd`:/src/ singapore/lint-condo
