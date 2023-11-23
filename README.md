# roc2Nix

Very much a work in progress but basic nix building works

to run the example you can run `nix build .#examples-simple --print-build-logs` in the repo root


## How it works

NOTE: goal is to eventually have a code gen step to reduce boiler plate like node2nix but for now its all manaul

- nix is given a list of urls of roc packages with their sha256 hash
- `downloadRocPackage` will call `fetchUrl` on each package and extract the package into a directory
- `mkRocDerivation` will replace all references to the package url with the now local path and build with the provided roc compiler


Lib setup is heavily inspired by [crane](https://github.com/ipetkov/crane)