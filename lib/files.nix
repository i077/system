# lib/modules.nix -- Helper functions regarding config modules.

lib:

let
  inherit (builtins) pathExists readDir;
  inherit (lib) filterAttrs hasSuffix mapAttrs' nameValuePair removeSuffix;

  inherit (import ./attrsets.nix lib) attrValuesRec;

  # Helper functions to check if a file/type pair (produced by readDir) is either...
  # ...a .nix file, or
  isNixFile = file: type: type == "regular" && hasSuffix ".nix" file;
  # ...a directory with a default.nix file inside
  isNixDir = file: type: type == "directory" && pathExists "${file}/default.nix";
in rec {

  # Get the contents of a directory, filtering only for .nix files and directories with default.nix.
  readDirNix = dir:
    filterAttrs (file: type: isNixFile file type || isNixDir "${toString dir}/${file}" type)
    (readDir dir);

  # Apply a function onto every .nix file and directory with default.nix (non-recursive) in a path.
  #
  # Example: Given a directory dir/ with the following files:
  #   dir/one.nix dir/two.nix dir/three.nix dir/four/default.nix dir/four/foo.nix
  # and some function fn :: path -> any,
  #   mapFiles ./dir fn ==> {
  #     one = fn dir/one.nix;
  #     two = fn dir/two.nix;
  #     three = fn dir/three.nix;
  #     four = fn dir/four/default.nix
  #   }
  mapFiles = fn: dir:
    let
    in mapAttrs' (file: type:
      let
        path = "${toString dir}/${file}";
        value = fn path;
      in if isNixFile file type then
      # If it's a .nix file, add its value
        nameValuePair (removeSuffix ".nix" file) value
      else
      # If it's a directory with a default.nix, add ${path}/default.nix as its value
        nameValuePair file value)
    # Apply this map to a call to readDir, filtering only for .nix files and directories
    (readDirNix dir);

  # Same as mapFiles, but apply recursively onto each directory
  # 
  # Example: Given a directory dir/ with the following files:
  #   dir/one.nix dir/two.nix dir/three.nix dir/four/default.nix dir/four/foo.nix
  # and some function fn :: path -> any,
  #   mapFiles ./dir fn ==> {
  #     one = fn dir/one.nix;
  #     two = fn dir/two.nix;
  #     three = fn dir/three.nix;
  #     four = {
  #       default = fn dir/four/default.nix;
  #       foo = fn dir/four/foo.nix;
  #     };
  #   }
  mapFilesRec = fn: dir:
    # Pass the mapping to removeAttrs since there might be a null pair added in
    removeAttrs (mapAttrs' (file: type:
      let
        path = "${toString dir}/${file}";
        value = fn path;
      in if isNixFile file type then
      # If it's a .nix file that's not default.nix, add its value
        nameValuePair (removeSuffix ".nix" file) value
      else if type == "directory" then
      # If it's a directory, add its value recursively
        nameValuePair file (mapFilesRec fn path)
      else
      # Otherwise, add nothing
        nameValuePair "" null) (readDir dir)) [ "" ];

  # Extract a list of all attribute set values (recursively) from mapFilesRec.
  mapFilesRecToList = fn: dir: attrValuesRec (mapFilesRec fn dir);
}
