{ makeSetupHook, roc }:

makeSetupHook {
  name = "rocHelperFunctions";
  # TODO: is it bad to do propagatedBuildInputs here
  # or should we add roc explictly to nativeBuildInputs when this hooks is used?
  propagatedBuildInputs = [ roc ];
} ./rocHelperFunctions.sh
