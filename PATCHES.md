# Changes from upstream

This is the Asciiverse packaging of [glulxe](https://github.com/erkyrath/glulxe),
Andrew Plotkin's Glulx interpreter, built against his
[GlkTerm](https://github.com/erkyrath/glkterm) in its wide-character
edition, so Unicode text, status lines and other Glk windows work in the
terminal. Both are MIT-licensed (`LICENSE`, `glkterm/LICENSE`).

- glulxe: upstream's `glulxe-0.6.1` tag (October 2023),
  5c4644f4463acc5e63cf4ef778f774c2f72d900d. Upstream is the `upstream`
  remote; the `asciiverse` branch starts there.
- GlkTerm: branch `widechar` at 32fefd01fb759cd538a91d14c7f9320c1b476669
  (January 2020: GlkTerm 1.0.4 with the switch to the MIT license), merged
  with its history under `glkterm/` (`git subtree`, remote `glkterm`).

Why 0.6.1 and not upstream's newer `master`: since June 2025 `master` sets
the Glk working directory to the story file's folder, so saves, transcripts
and data files land next to the story instead of in the current directory.
0.6.1 keeps them in the current directory.

## Code (GlkTerm only; glulxe is unchanged)

- `glkterm: include <curses.h> for the wide-character functions`:
  `gtncursesw.c` asked for `<ncursesw/ncurses.h>`, which Alpine and macOS
  do not have; their single `<curses.h>` is the wide-character one.
- `glkterm: look for the file name's dot suffix in the right buffer`: when
  deciding whether a typed save or transcript name needs `.glksave` or
  `.txt` added, GlkTerm walked the typed name using the length of the full
  path, starting past the end of the name in stale bytes. Found reading
  the code; not seen to go wrong in testing. CheapGlk has the same lines.
- `glkterm: never page a text buffer window to line -1`: with nothing yet
  marked as read, paging scrolled to line -1 and read `lines[-1]` (a heap
  overflow). Making the terminal narrower while Counterfeit Monkey waited
  for a command crashed glulxe this way.
- `glkterm: keep text marked as read when the window is re-wrapped`: after
  a width change all text counted as unread, so the window went into
  "hit any key to page" mode and the first key of the next command was
  lost ("look" arrived as "ook"). The window now remembers how far the
  player had read.

## Build options (asciiverse/build.sh)

- `-O2 -fno-strict-aliasing`: glulxe's `float.c` type-puns floats through
  pointers, which GCC warns may break with strict aliasing at -O2
  (upstream's Makefile does not optimise at all).
- Linux: `-DOS_UNIX -DUNIX_RAND_GETRANDOM`, as upstream's Makefile
  recommends for Linux. macOS: `-DOS_MAC` (arc4random).
- Compiled with the default C dialect rather than GlkTerm Makefile's
  `gcc -ansi`, under which `cgdate.c` used `timegm`, `gmtime_r` and
  `localtime_r` without declarations.

## Packaging (new files)

- `asciiverse/build.sh`: a fully static Linux build in Alpine, and macOS
  builds that link only the system's ncurses (the script fails otherwise).
- `asciiverse/build-glulxe.sh`: the same build from upstream's pinned
  commits plus the four GlkTerm fixes above, self-contained, for story
  repositories that bundle glulxe with their story. It gives a binary
  identical to `asciiverse/build.sh`.
- `asciiverse/nfpm.yaml`: .deb, .rpm, .apk and Arch packages named
  `glulxe-asciiverse` (they conflict with a distribution's own glulxe).
- `.github/workflows/release.yml`: builds all of it on a tag.

## Not built

- Windows: GlkTerm is a curses library for Unix terminals.
- glulxdump, the profiler and the debugger (`VM_DEBUGGER`, needs libxml2).

## Ours

- **How to play it, at the top of README.md.** A short note on installing and
  starting it with av, or from a release archive; the original text follows
  unchanged.
