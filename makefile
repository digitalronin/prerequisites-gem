VERSION := 0.2.0

prerequisites.gemspec: Rakefile.template lib/* spec/*
	(export VERSION=$(VERSION); cat Rakefile.template | envsubst > Rakefile)
	rake package

publish: prerequisites.gemspec
	gem push pkg/prerequisites-$(VERSION).gem

clean:
	rm -rf pkg prerequisites.gemspec Rakefile

.PHONY: publish clean
