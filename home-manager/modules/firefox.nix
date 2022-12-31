{ lib, pkgs, ... }:
{
  programs.firefox =
    let
      checker-plus-for-calendar = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon {
        pname = "wtf";
        version = "29.0.1";
        addonId = "checkerplusforgooglecalendar@jasonsavard.com";
        url = "https://addons.mozilla.org/firefox/downloads/file/3906906/checker_plus_for_google_calendartm-29.0.2-fx.xpi";
        sha256 = "b7988d0c0ea5177ec3235e2eaa72d0081a4975c5a7dc12c99f2c3ef377a21efd";
        meta = with lib;
        {
          homepage = "//jasonsavard.com?ref=homepage_url&ext=calendar";
          description = "Calendar checker";
          license = licenses.mit;
          platforms = platforms.all;
        };
      };
    in {
      enable = true;
      profiles = {
        default = {
          id = 0;
          settings = {
            # beacons allow sites to do requests when the tab is closed
            "beacon.enabled" = false;
            # don't hide tabs while fullscreen
            "browser.fullscreen.autohide" = false;
            # disable <a> ping feature
            "browser.send_pings" = false;
            # disable geolocation
            "geo.enabled" = false;
            # who thought this is a good idea
            "dom.serviceWorkers.enabled" = false;
            # no, I don't want your notifications
            "dom.push.enabled" = false;
            # don't want no http
            "dom.security.https_only_mode" = true;
            # show the real compact mode
            "browser.compactmode.show" = true;
            # don't need fancy fonts
            "gfx.downloadable_fonts.enabled" = false;
          };
          # my nixos is not yet ready for this
          # search = {
          #   default = "DuckDuckGo";
          # };
        };
      };
      extensions =
        with pkgs.nur.repos.rycee.firefox-addons; [
          # vim-like bindings for firefox
          vimium
          # autoredirect to https
          https-everywhere
          # block unnecessary web content
          ublock-origin
          # block tracking content (and save bandwidth)
          localcdn
          # calendar checker plus
          checker-plus-for-calendar
          # magic internet money
          metamask
        ];
      };
}
