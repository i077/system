{ config, lib, pkgs, ... }:

{
  options.defaultApplications = lib.mkOption {
    type = lib.types.attrs;
    description = "Default applications";
  };
  config = {
    defaultApplications = rec {
      terminal = {
        cmd = "${pkgs.alacritty}/bin/alacritty";
        desktop = "Alacritty";
      };
      editor = {
        cmd = "nvim";
        desktop = "nvim";
      };
      browser = {
        cmd = "${pkgs.firefox}/bin/firefox";
        desktop = "firefox";
      };
      pdf = {
        cmd = "${pkgs.zathura}/bin/zathura";
        desktop = "org.pwmt.zathura";
      };
      image = {
        cmd = "${pkgs.gnome3.eog}/bin/eog";
        desktop = "org.gnome.eog";
      };
      archive = {
        cmd = "${pkgs.gnome3.file-roller}/bin/file-roller";
        desktop = "org.gnome.file-roller";
      };

      # Office suite
      docs = {
        cmd = "${pkgs.libreoffice}/bin/swriter";
        desktop = "writer";
      };
      sheets = {
        cmd = "${pkgs.libreoffice}/bin/scalc";
        desktop = "calc";
      };
      slides = {
        cmd = "${pkgs.libreoffice}/bin/simpress";
        desktop = "impress";
      };

      zoom = {
        cmd = "${pkgs.zoom-us}/bin/zoom-us";
        desktop = "Zoom";
      };

      gsconnect = {
        desktop = "org.gnome.Shell.Extensions.GSConnect";
      };
    };

    home-manager.users.imran.xdg.mimeApps.enable = true;
    home-manager.users.imran.xdg.mimeApps.defaultApplications =
      with config.defaultApplications;
      builtins.mapAttrs (n: v: "${v.desktop}.desktop") {
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/chrome" = browser;
        "x-scheme-handler/unknown" = browser;
        "x-scheme-handler/sms" = gsconnect;
        "x-scheme-handler/tel" = gsconnect;

        "x-scheme-handler/zoommtg" = zoom;

        "application/zip" = archive;
        "application/rar" = archive;
        "application/7z" = archive;
        "application/*tar" = archive;

        "image/*" = image;

        "application/pdf" = pdf;
        "application/postscript" = pdf;

        "application/vnd.oasis.opendocument.text" = docs;
        "application/msword" = docs;
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = docs;

        "text/csv" = sheets;

        "application/vnd.oasis.opendocument.presentation" = slides;
        "application/vnd.ms-powerpoint" = slides;
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = slides;

        "text/plain" = editor;
      };
  };
}
