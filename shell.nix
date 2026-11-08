# You should ensure that `noto-fonts-cjk-sans-static` and `noto-fonts-cjk-serif-static`
# are installed system-wide.

{ pkgs ? import <nixpkgs> {} }:

let
  # xdvipdfmx does not work well with variant fonts, but NixOS still provides
  # variable version alongside with static fonts. So the former ones should be
  # excluded.
  texFontConfig = pkgs.writeText "tex-fontconfig.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <!-- Load the existing NixOS configuration first -->
      <include>/etc/fonts/fonts.conf</include>

      <!-- Disable only problematic Noto CJK variable fonts -->
      <selectfont>
        <rejectfont>
          <glob>*/NotoSansCJK-VF.otf.ttc</glob>
          <glob>*/NotoSerifCJK-VF.otf.ttc</glob>
        </rejectfont>
      </selectfont>
    </fontconfig>
  '';
in
pkgs.mkShell {
  packages = with pkgs; [
    fontconfig
    texliveFull
    zathura
  ];
  shellHook = ''
    export FONTCONFIG_FILE="${texFontConfig}"
  '';
}
