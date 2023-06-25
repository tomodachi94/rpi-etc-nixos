{ lib, ... }: {
  # Copy the file to ./networks.nix, then setup your networks here.
  # Warning: ./networks.nix is in .gitignore to prevent leaking secrets.
  # See 'networking.wireless.networks' documentation for more information.
  networking.wireless.networks = {
    YourNetworkSSID = {
      pskRaw = ""; # Output of the 'psk' field from running `wpa_passphrase YourNetworkSSID` and then typing the passphrase into stdin
    };
    "Some Network SSID With Spaces and Speci@l: Charact3rs" = {
      pskRaw = ""; # See above
    };
  };
}
