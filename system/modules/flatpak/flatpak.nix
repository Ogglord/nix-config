{ lib, ... }: {

  services.flatpak.enable = true;

  services.flatpak.remotes = lib.mkOptionDefault [{
    name = "flathub-beta";
    location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
  }];

  services.flatpak.packages = [
    {
      appId = "com.google.Chrome";
      # origin = "flathub-beta";
    }
    "com.spotify.Client"
  ];

  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };

}
