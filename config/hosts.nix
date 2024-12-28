let
  users = import ./users.nix;
in
{
  work = {
    hostname = "ceris";
    dir = "default";
    arch = "x86_64-linux";
    user = users.work;
  };
}
