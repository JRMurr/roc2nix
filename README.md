# roc2Nix

Very much a work in progress but basic nix building works

to run the example you can run `nix build .#examples-simple --print-build-logs` in the repo root


## How it works

NOTE: goal is to eventually have a code gen step to reduce boiler plate like node2nix but for now its all manaul

- nix is given a list of urls of roc packages with their sha256 hash
- `downloadRocPackage` will call `fetchUrl` on each package and extract the package into a directory
- `mkRocDerivation` will replace all references to the package url with the now local path and build with the provided roc compiler



## TODO
- [ ] TLC around how roc deps are replaced by the nix store paths. Right now its basically a regex is fine for the long urls but for local file paths there is a potential for collisions
- [ ] lang specific builders for platforms/a way to take in a compile platform derivation and merge it with roc platform code
- [ ] actually verify the blake3 checksum. (since we untar roc wont do this for us). Maybe roc could support local tar balls?
- [ ] A code gen tool to get all deps of a roc package for you


## Ideas to explore

- Use the nix c abi to make a "nix platform" for roc. Potential for roc build to build the derivation or at least move more of this logic into roc.
- Expose an api to work with `evalModules` or `flakeParts` to make it easier to compose all the needed builds + have better input validation

Lib setup is heavily inspired by [crane](https://github.com/ipetkov/crane)


## notes

see https://github.com/JRMurr/roc/blob/3d8884a96d44e2101ce8932336b74e2b9416e029/crates/compiler/build/src/link.rs#L437 
for how roc calls out to compile different platforms