self: super:
{
  tor-browser-bundle-bin = super.tor-browser-bundle-bin.overrideAttrs (old: {
    src = super.fetchurl {
        urls = [
            "https://dist.torproject.org/torbrowser/11.0.4/tor-browser-linux64-11.0.4_en-US.tar.xz"
            "https://tor.eff.org/dist/torbrowser/11.0.4/tor-browser-linux64-11.0.4_en-US.tar.xz"
        ];
        sha256 = "0pz1v5ig031wgnq3191ja08a4brdrbzziqnkpcrlra1wcdnzv985";
    };
  });
}