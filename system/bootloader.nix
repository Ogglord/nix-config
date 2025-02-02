{ ... }: {
  hardware.enableRedistributableFirmware = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    edk2-uefi-shell.enable = true;
    configurationLimit = 5; # Optional: limits number of configurations to keep
    extraEntries = {
      "bazzite_cl.conf" = ''
        title Bazzite Chainload
        efi /efi/edk2-uefi-shell/shell.efi
        options -nointerrupt -nomap -noversion HD1b:\EFI\fedora\shimx64.efi
      '';
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

}
