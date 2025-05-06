{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixCats-test.homeModules.default
  ];
}
