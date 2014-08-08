usage:
	@echo build-dummy-package - build a simple debian package
	@echo publish-gh-repo - create and publish the repository to github gh branch
	@echo all - do all the job
all:publish-gh-repo

build-dummy-package:
	rm -rf sample-pkg-debian
	rm -rf sample-pkg-debian_1.0_all.deb
	equivs-control sample-pkg-debian
	sed -i 's/<package name; defaults to equivs-dummy>/sample-pkg-debian/' sample-pkg-debian
	sed -i 's/# Version: <enter version here; defaults to 1.0>/Version: 1.0/' sample-pkg-debian
	sed -i 's/# Maintainer: Your Name <yourname@example.com>/Maintainer: Sébastien ELET <>/' sample-pkg-debian
	equivs-build sample-pkg-debian
publish-gh-repo: build-dummy-package
	cd $HOME
	git config --global user.email "travis@travis-ci.org"
	git config --global user.name "travis-ci"
	git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/Nasga/sample-pkg-debian
