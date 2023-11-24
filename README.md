# roc2Nix

Very much a work in progress but basic nix building works

to run the example you can run `nix build .#examples-simple --print-build-logs` in the repo root


## How it works

NOTE: goal is to eventually have a code gen step to reduce boiler plate like node2nix but for now its all manaul

- nix is given a list of urls of roc packages with their sha256 hash
- `downloadRocPackage` will call `fetchUrl` on each package and extract the package into a directory
- `mkRocDerivation` will replace all references to the package url with the now local path and build with the provided roc compiler



## TODO

- [ ] support bundling instead of just building a binary
- [ ] support specifiying a nix expression as a dep instead of just the url
- [ ] actually verify the blake3 checksum. (since we untar roc wont do this for us). Maybe roc could support local tar balls?
- [ ] allow specifiying a specific file to build + outputed binary name
- [ ] the code gen tool to get all deps of a roc package for you


## Ideas to explore

- Use the nix c abi to make a "nix platform" for roc. Potential for roc build to build the derivation or at least move more of this logic into roc.
- Expose an api to work with `evalModules` or `flakeParts` to make it easier to compose all the needed builds + have better input validation

Lib setup is heavily inspired by [crane](https://github.com/ipetkov/crane)