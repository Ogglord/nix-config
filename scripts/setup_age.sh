#!/usr/bin/env bash
echo generating age key from ssh key
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
echo exporting public key
#nix-shell -p ssh-to-pgp --run "ssh-to-pgp -i $HOME/.ssh/id_ed2551 -o $USER_$HOSTNAME.asc"
nix-shell -p ssh-to-age --run "ssh-to-age -i ~/.ssh/id_ed25519.pub -o \"${USER}${HOSTNAME}.asc\""
echo done!