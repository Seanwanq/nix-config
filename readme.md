`sudo nixos-rebuild switch --flake .#nixos-vm`

## 1Password SSH agent notes

If `ssh -T git@github.com` prints `sign_and_send_pubkey: signing failed ... agent refused operation`, 1Password is waiting for you to authorize the request. Unlock 1Password, open the **GitHub 2025** SSH key item, and under **Applications & Hosts** (Advanced) add:

1. Applications: `/run/current-system/sw/bin/ssh` and `/run/current-system/sw/bin/git`.
2. Hosts: `github.com` (and `ssh.github.com` if you use that port).
3. Click **Always allow** so future Git connections succeed without a prompt.

Retry `ssh -T git@github.com`. You should see GitHub's greeting once the key is allowed. The same settings let commit signing with `op-ssh-sign` work reliably on NixOS.