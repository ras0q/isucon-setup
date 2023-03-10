MEMBERS      := tesso57 toshi-pono ras0q
REPO_URL     := git@github.com:ras0q/piscon-2023-spring.git
REPO_DIR     := ~
APP          := isulibrary
SERVICE      := $(APP).go.service
SERVER_NUM   := 1
DB_ENV_PATH  := ~/env.sh
HTTPLOG_PATH := /var/log/nginx/access.log
SLOWLOG_PATH := /var/log/mysql/mysql-slow.log
LOGS_DIR     := ~/logs

.PHONY: all
all: setup-apt setup-env setup-ssh setup-git setup-repo setup-bin

.PHONY: setup-apt
setup-apt:
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt install -y build-essential percona-toolkit htop git curl wget vim

.PHONY: setup-env
setup-env:
	echo 'export REPO_URL=$(REPO_URL)' >> ~/.bashrc
	echo 'export REPO_DIR=$(REPO_DIR)' >> ~/.bashrc
	echo 'export APP=$(APP)' >> ~/.bashrc
	echo 'export SERVICE=$(SERVICE)' >> ~/.bashrc
	echo 'export SERVER_NUM=$(SERVER_NUM)' >> ~/.bashrc
	echo 'export DB_ENV_PATH=$(DB_ENV_PATH)' >> ~/.bashrc
	echo 'export HTTPLOG_PATH=$(HTTPLOG_PATH)' >> ~/.bashrc
	echo 'export SLOWLOG_PATH=$(SLOWLOG_PATH)' >> ~/.bashrc
	echo 'export LOGS_DIR=$(LOGS_DIR)' >> ~/.bashrc
	# for pprotein
	echo 'export PPROTEIN_HTTPLOG=$(HTTPLOG_PATH)' >> ~/.bashrc
	echo 'export PPROTEIN_SLOWLOG=$(SLOWLOG_PATH)' >> ~/.bashrc
	echo 'export PPROTEIN_GIT_REPOSITORY=$(REPO_DIR)' >> ~/.bashrc

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
	cd $(REPO_DIR)
	git init
	git remote add origin $(REPO_URL)

.PHONY: setup-bin
setup-bin:
	mkdir -p $(REPO_DIR)/bin
	cp ./bin/* $(REPO_DIR)/bin
	sudo chmod +x $(REPO_DIR)/bin/*
	echo 'export PATH=$$PATH:$(REPO_DIR)/bin' >> ~/.bashrc
