# glulxe (Asciiverse packaging)

glulxe, Andrew Plotkin's Glulx interpreter, with his GlkTerm (wide-character
edition) for the terminal, packaged for the Asciiverse catalog (kind
`program`, an interpreter for the Text adventures category) and as system
packages. Inform 7 story titles bundle this build with their story file,
through `asciiverse/build-glulxe.sh`. Not our code: keep changes small,
list every one in PATCHES.md, and mirror code changes into the patch in
`asciiverse/build-glulxe.sh` (both builds must give the same binary).

- Remotes: `upstream` is github.com/erkyrath/glulxe, `glkterm` is
  github.com/erkyrath/glkterm (subtree under `glkterm/`), `origin` is
  github.com/theasciiverse/glulxe.
- Branch `asciiverse` = upstream's `glulxe-0.6.1` tag plus our commits.
- Release: tag `v<upstream version>-av.<n>` and push it.
- Local static build: `docker run --rm -v "$PWD":/src -w /src alpine:3.22
  sh asciiverse/build.sh` leaves `./glulxe`.
- Play: `glulxe <story file>` (.ulx, .gblorb); saves go to the current
  directory.
