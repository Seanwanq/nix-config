default:
  just --list

update-dependency:
  sudo nix flake update

build:
  sudo nixos-rebuild switch --flake .#nixos-vm

git-status:
  git status

commit:
  git commit

push:
  git push

pull:
  git pull


