{ config, ... }:
{

  # Set a temp password for use by minimal builds like installer and iso
  users.users.${config.hostSpec.username} = {
    isNormalUser = true;
    hashedPassword = "$6$rounds=656000$4k25SsBFKB0NypMa$07O2w7qXBjVqXSuIGKmlvAjD1Z5L1Qo6UYU7O0pHCq2PsTAzmVRHoTqddQkVf4GbpPYk6z5iz9I1Fxo/aQYxY0";
    extraGroups = [ "wheel" ];
  };
}
