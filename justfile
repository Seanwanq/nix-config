default:
  just --list

update-dependency:
  sudo nix flake update

build-vm:
  sudo nixos-rebuild switch --flake .#nixos-vm

build-hv:
  sudo nixos-rebuild switch --flake .#nixos-hv

git-status:
  git status

commit:
  git commit

push:
  git push

pull:
  git pull


