{
  lib,
  pkgs
}:

let
  wrapperOptions = {config}: {
    options = {
      basePackage = lib.mkOption {
        type = with lib.types; package;
        description =  ''
          Program to be wrapped.
        '';
        example = lib.literalExpression "pkgs.nix";
      };

      extraPackages = lib.mkOption {
        type = with lib.types; listOf package;
        default = [];
        description = ''
          Extra packages to also wrap.
        '';
        example = lib.literalExpression "[ pkgs.git-extras pkgs.delta ]";

      };
      #environment = {};
      #wrapperFlags = {};
      #postBuild = {};
      #pathAdd = {};

      wrapped = mkOption {
        type = with lib.types; package;
        readOnly = true;
        description = ''
          (Output) Final wrapped package.
        '';
      };
    };

    config = {
      wrapped = pkgs.symlinkJoin {
        paths = [ config.basePackage ] ++ config.extraPackages;
	buildInputs = [ pkgs.makeWrapper ];#Native?
	postBuild = ''
	  for file in "$out"/bin/*; do
	    echo "Wrapping $file"
	    wrapProgram \
	      "$file"
	  done
        '';
      };
    };
  };
in
{
  options = {
    wrappers = mkOption {
      type = with types; attrsOf (submodule wrapperOptions);
      default = {};
      description = ''
        Wrapper configuration. See the suboptions for configuration.
      '';
    };
  };

  config = {
  };
}
