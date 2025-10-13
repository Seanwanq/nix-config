{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  users.users.ryan = {
    # Sean's authorizedKeys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN8ur45YJC74iBp83upb4HuoFDfGXzgP88uF9LXmtHTB"
    ];
  };
}