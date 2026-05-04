SHELL := /bin/bash
.SHELLFLAGS := -euxo pipefail -c

USER      := $(or $(SUDO_USER),$(shell id -un))
# getent is Linux-only; eval echo ~user works on both Linux and macOS
USER_HOME := $(shell eval echo ~$(USER))
# id -g works on both Linux and macOS (getent group is Linux-only)
USER_GRP  := $(shell id -g $(USER))

export USER USER_HOME USER_GRP

.PHONY: install-%

# ============================================================
# Entry point
# ============================================================

# TODO dmg: awscliV2, Docker, gcloud
install-mac: \
	install-sub-brew \
	install-sub-tmux-plugin \
	install-sub-claude-code \
	install-sub-mac-settings

install-ubuntu: \
	install-sub-apt \
	install-sub-awscli \
	install-sub-bat \
	install-sub-docker \
	install-sub-gcloud \
	install-sub-gh \
	install-sub-golang \
	install-sub-ripgrep \
	install-sub-sops \
	install-sub-starship \
	install-sub-tfenv \
	install-sub-age \
	install-sub-ghq \
	install-sub-claude-code

# ============================================================
# Sub targets (called individually or via install-ubuntu)
# ============================================================

install-sub-apt:
	sudo apt update
	sudo apt install -y --no-install-recommends \
		bat \
		build-essential \
		git \
		jq \
		keychain \
		make \
		peco \
		postgresql-client \
		ripgrep \
		shellcheck \
		tmux \
		tree \
		unzip \
		vim \
		watch \
		zip \
		zplug \
		zsh

install-sub-age: install-sub-golang
	go install filippo.io/age/cmd/...@latest

install-sub-awscli:
	sudo rm -rf /usr/local/aws-cli /usr/local/bin/aws /usr/local/bin/aws_completer
	curl -fLsS -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
	unzip awscliv2.zip
	sudo ./aws/install
	rm -rf awscliv2.zip aws

install-sub-bat:
	$(eval BAT_VERSION := 0.20.0)
	curl -fLsS -o bat_amd64.deb \
		"https://github.com/sharkdp/bat/releases/download/v$(BAT_VERSION)/bat_$(BAT_VERSION)_amd64.deb"
	sudo dpkg -i bat_amd64.deb
	rm bat_amd64.deb

install-sub-docker:
	[ -e /usr/share/keyrings/docker-archive-keyring.gpg ] || \
		curl -fLsS https://download.docker.com/linux/ubuntu/gpg | \
		sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
		https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update && sudo apt install -y --no-install-recommends \
		docker-ce docker-ce-cli containerd.io
	set +e; sudo service docker start; set -e
	$(eval DOCKER_COMPOSE_VERSION := v2.20.3)
	sudo curl -fLsS -o /usr/local/bin/docker-compose \
		"https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-$$(uname -s | tr '[:upper:]' '[:lower:]')-$$(uname -m)"
	sudo chmod +x /usr/local/bin/docker-compose
	$(eval KUBECTL_VERSION := v1.24.0)
	sudo curl -fLsS -o /usr/local/bin/kubectl \
		"https://storage.googleapis.com/kubernetes-release/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl"
	sudo chmod +x /usr/local/bin/kubectl
	$(eval HELM_VERSION := v3.9.0)
	mkdir helm && curl -fLsS \
		"https://get.helm.sh/helm-$(HELM_VERSION)-linux-amd64.tar.gz" \
		| tar -C helm -xz --strip-components 1
	sudo mv helm/helm /usr/local/bin/
	rm -rf helm
	sudo curl -fLsS -o /usr/local/bin/minikube \
		"https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
	sudo chmod +x /usr/local/bin/minikube
	$(eval HADOLINT_VERSION := v2.9.3)
	sudo curl -fLsS -o /usr/local/bin/hadolint \
		"https://github.com/hadolint/hadolint/releases/download/$(HADOLINT_VERSION)/hadolint-Linux-x86_64"
	sudo chmod +x /usr/local/bin/hadolint

install-sub-gcloud:
	sudo rm -rf /usr/local/gcloud
	curl -fLsS -o gcloud.tar.gz \
		https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-370.0.0-linux-x86_64.tar.gz
	sudo mkdir -p /usr/local/gcloud
	sudo tar -C /usr/local/gcloud -xvf gcloud.tar.gz
	sudo /usr/local/gcloud/google-cloud-sdk/install.sh -q
	rm gcloud.tar.gz

install-sub-gh:
	$(eval GH_VERSION := 2.12.1)
	mkdir gh
	curl -fLsS \
		"https://github.com/cli/cli/releases/download/v$(GH_VERSION)/gh_$(GH_VERSION)_linux_amd64.tar.gz" \
		| tar -C gh -xz --strip-components 1
	sudo mv gh/bin/gh /usr/local/bin/
	rm -rf gh

install-sub-ghq: install-sub-golang
	go install github.com/x-motemen/ghq@latest

install-sub-golang:
	$(eval GO_VERSION := 1.26.0)
	sudo rm -rf /usr/local/go /usr/local/bin/go /usr/local/bin/gofmt
	curl -fLsS "https://go.dev/dl/go$(GO_VERSION).linux-amd64.tar.gz" \
		| sudo tar -C /usr/local -xz
	sudo ln -sf /usr/local/go/bin/go /usr/local/bin/
	sudo ln -sf /usr/local/go/bin/gofmt /usr/local/bin/

install-sub-ripgrep:
	$(eval RIPGREP_VERSION := 13.0.0)
	curl -fLsS -o ripgrep_amd64.deb \
		"https://github.com/BurntSushi/ripgrep/releases/download/$(RIPGREP_VERSION)/ripgrep_$(RIPGREP_VERSION)_amd64.deb"
	sudo dpkg -i ripgrep_amd64.deb
	rm ripgrep_amd64.deb

install-sub-sops:
	$(eval SOPS_VERSION := v3.7.1)
	curl -fLsS -o sops \
		"https://github.com/mozilla/sops/releases/download/$(SOPS_VERSION)/sops-$(SOPS_VERSION).linux"
	sudo mv sops /usr/local/bin/sops
	sudo chmod +x /usr/local/bin/sops

install-sub-starship:
	# bash -c "$$(curl -fLsS https://starship.rs/install.sh)"

install-sub-tfenv:
	rm -rf $(HOME)/.tfenv
	sudo rm -rf /usr/local/bin/terraform /usr/local/bin/tfenv
	git clone https://github.com/tfutils/tfenv.git $(HOME)/.tfenv
	sudo ln -sf $(HOME)/.tfenv/bin/tfenv /usr/local/bin/
	sudo ln -sf $(HOME)/.tfenv/bin/terraform /usr/local/bin/

install-sub-tmux-plugin:
	rm -rf $(USER_HOME)/.tmux/plugins/tpm
	git clone https://github.com/tmux-plugins/tpm $(USER_HOME)/.tmux/plugins/tpm

install-sub-claude-code:
	curl -fsSL https://claude.ai/install.sh | bash

# ============================================================
# Sub targets (called individually or via install-ubuntu)
# ============================================================

install-sub-brew:
	which brew || /bin/bash -c \
		"$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update
	brew install \
	    age \
	    awk \
	    bat \
	    gh \
	    ghq \
	    git \
	    gnu-sed \
	    jq \
	    peco \
	    ripgrep \
	    shellcheck \
	    sops \
	    starship \
	    tfenv \
	    tmux \
	    tree \
	    vim \
	    watch \
	    zplug \
	    zsh
	brew upgrade

install-sub-mac-settings:
	defaults write com.apple.screencapture location ~/Downloads
	killall SystemUIServer
