lib:

let
  inherit (builtins) filter trace;
  inherit (lib) attrValues flatten isAttrs;
in rec {
  # Recursive version of attrValues, flattened into a single list
  # Example: Given
  #   s = { foo = 1; bar = 2; baz = { a = 3; b = 4; }; }
  #
  #   attrValuesRec s ==> [ 1 2 3 4 ]
  attrValuesRec = set:
    let
      vals = attrValues set;
      # Split the list of values into ones that are sets and ones that aren't
      setVals = filter isAttrs vals;
      nonSetVals = filter (x: !(isAttrs x)) vals;
    in nonSetVals ++ flatten (map attrValuesRec setVals);
}
