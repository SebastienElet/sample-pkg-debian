usage:
	@echo build-dummy-package - build a simple debian package
	@echo publish-gh-repo - create and publish the repository to github gh branch
	@echo all - do all the job

all:install

build-dummy-package:
	rm -rf sample-pkg-debian
	rm -rf sample-pkg-debian_1.0_all.deb
	equivs-control sample-pkg-debian
	sed -i 's/<package name; defaults to equivs-dummy>/sample-pkg-debian/' sample-pkg-debian
	sed -i 's/# Version: <enter version here; defaults to 1.0>/Version: 1.0/' sample-pkg-debian
	sed -i 's/# Maintainer: Your Name <yourname@example.com>/Maintainer: Sébastien ELET <>/' sample-pkg-debian
	equivs-build sample-pkg-debian

publish-gh-repo: build-dummy-package
	git config --global user.email "travis@travis-ci.org"
	git config --global user.name "travis-ci"
	@git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/Nasga/sample-pkg-debian.git $(HOME)/gh-pages > /dev/null
	rm -rf $(HOME)/gh-pages/apt/
	mkdir -p $(HOME)/gh-pages/apt/debian/conf
	echo 'Origin: GithubPackages' >> $(HOME)/gh-pages/apt/debian/conf/distributions
	echo 'Label: GithubPackages' >> $(HOME)/gh-pages/apt/debian/conf/distributions
	echo 'Codename: wheezy' >> $(HOME)/gh-pages/apt/debian/conf/distributions
	echo 'Architectures: i386 amd64' >> $(HOME)/gh-pages/apt/debian/conf/distributions
	echo 'Components: main' >> $(HOME)/gh-pages/apt/debian/conf/distributions
	echo 'Description: Apt repository for sample debian package' >> $(HOME)/gh-pages/apt/debian/conf/distributions
	reprepro --basedir=$(HOME)/gh-pages/apt/debian includedeb wheezy *.deb
	cd $(HOME)/gh-pages && git add apt
	cd $(HOME)/gh-pages && git commit -m 'Update gh-pages with debian repo'
	cd $(HOME)/gh-pages && git push -fv origin gh-pages	

install:publish-gh-repo
	sleep 20
	echo 'deb http://nasga.github.io/sample-pkg-debian/apt/debian/ wheezy main' \
		| sudo tee /etc/apt/sources.list.d/sample-pkg-debian.list
	sudo apt-get update -qq
	sudo apt-get install -qq --force-yes sample-pkg-debian
