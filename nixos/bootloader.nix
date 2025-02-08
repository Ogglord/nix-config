{pkgs, ...}: {
  hardware.enableRedistributableFirmware = true;
  # Use the systemd-boot EFI boot loader.
  boot = {
    plymouth = {
      enable = true;
      theme = "alienware";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = ["rings" "alienware" "loader"];
        })
      ];
    };
    loader = {
      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        edk2-uefi-shell.enable = true;
        configurationLimit =
          5; # Optional: limits number of configurations to keep
        extraEntries = {
          "bazzite_cl.conf" = ''
            title Bazzite Chainload
            efi /efi/edk2-uefi-shell/shell.efi
            options -nointerrupt -nomap -noversion HD1b:\EFI\fedora\shimx64.efi
          '';
        };
      };
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
