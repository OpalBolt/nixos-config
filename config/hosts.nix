let
  users = import ./users.nix;
in
{
  work = {
    hostname = "ceris";
    dir = "laptop-nixos-work";
    arch = "x86_64-linux";
    user = users.work;
  };
}
