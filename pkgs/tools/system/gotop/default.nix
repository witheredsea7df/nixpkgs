{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, IOKit
}:

buildGoModule rec {
  pname = "gotop";
  version = "4.2.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W7a3QnSIR95N88RqU2sr6oEDSqOXVfAwacPvS219+1Y=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-gpgduZbFCMMg/mXefhwMHvs4omml3RZ0h5XexO5vslM=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    $out/bin/gotop --create-manpage > gotop.1
    installManPage gotop.1
  '';

  meta = with lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    changelog = "https://github.com/xxxserxxx/gotop/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
  };
}
