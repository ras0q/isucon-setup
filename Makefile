MEMBERS                 := tesso57 toshi-pono ras0q SSlime-s
REPO                    := git@github.com:ras0q/piscon-2023-spring.git
APP                     := isulibrary
SERVICE                 := $(APP).go.service
SERVER_NUM              := 1
DB_ENV_PATH						  := ~/env.sh
PPROTEIN_HTTPLOG        := /var/log/nginx/access.log
PPROTEIN_SLOWLOG        := /var/log/mysql/mysql-slow.log
PPROTEIN_GIT_REPOSITORY := $$HOME

.PHONY: all
all: setup-apt setup-env setup-ssh setup-git setup-repo setup-bin

.PHONY: setup-apt
setup-apt:
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt install -y build-essential percona-toolkit htop git curl wget vim

.PHONY: setup-env
setup-env:
	echo 'export REPO=$(REPO)' >> ~/.bashrc
	echo 'export APP=$(APP)' >> ~/.bashrc
	echo 'export SERVICE=$(SERVICE)' >> ~/.bashrc
	echo 'export SERVER_NUM=$(SERVER_NUM)' >> ~/.bashrc
	echo 'export DB_ENV_PATH=$(DB_ENV_PATH)' >> ~/.bashrc
	echo 'export PPROTEIN_HTTPLOG=$(PPROTEIN_HTTPLOG)' >> ~/.bashrc
	echo 'export PPROTEIN_SLOWLOG=$(PPROTEIN_SLOWLOG)' >> ~/.bashrc
	echo 'export PPROTEIN_GIT_REPOSITORY=$(PPROTEIN_GIT_REPOSITORY)' >> ~/.bashrc

.PHONY: setup-ssh
setup-ssh:
	mkdir -p ~/.ssh
	for member in $(MEMBERS); do echo curl https://github.com/$$member.keys >> ~/.ssh/authorized_keys; done

.PHONY: setup-git
setup-git:
	git config --global user.name "server"
	git config --global user.email "github-actions[bot]@users.noreply.github.com"
	git config --global core.editor "vim"
	git config --global push.default current
	git config --global init.defaultbranch main
	git config --global fetch.prune true
	git config --global alias.lo "log --oneline"

.PHONY: setup-repo
setup-repo:
	cd
	git init
	git remote add origin $REPO

.PHONY: setup-bin
setup-bin:
	mkdir -p ~/bin
	cp ./bin/* ~/bin
	sudo chmod +x ~/bin/*
	echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
