NAME := $(shell hostname | cut -c 6-)
HOSTNAME := i077-$(NAME)
PERIOD := 60
VERB := test

FLAKE_ROOT := $(PREFIX)/etc/nixos

all: check
	sudo nixos-rebuild $(VERB)

switch: check
	sudo nixos-rebuild switch

boot: check
	sudo nixos-rebuild boot

test: check
	sudo nixos-rebuild test

build:
	nixos-rebuild build --flake "$(FLAKE_ROOT)#$(HOSTNAME)"

dry:
	nixos-rebuild dry-build

install: bootstrap build
	sudo nixos-install --root "$(PREFIX)" --system ./result

update: check
	nix flake update --recreate-lock-file --commit-lock-file

upgrade: update switch

clean:
	rm -f result

gc:
	nix-collect-garbage

GC:
	sudo nix-collect-garbage --delete-older-than $(PERIOD)d

bootstrap:
	[ -d $(PREFIX) ] && [ -f $(FLAKE_ROOT)/hosts/$(NAME)/default.nix ]
	nix-shell -p git-crypt gnupg --command "git-crypt unlock"
	nixos-generate-config --show-hardware-config > $(FLAKE_ROOT)/hosts/$(NAME)/hardware-configuration.nix

# Check if tree is pristine (clean + no untracked)
check:
	git ls-files --modified --other --directory --exclude-standard | sed q1 >/dev/null

# Abbreviations
s: switch
b: boot
up: upgrade
ub: update boot
ut: update test

.PHONY: clean bootstrap install check
