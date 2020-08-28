# Maintainers' notes

This file is meant to outline the structure of this repo, and to host some information useful prior to rework of this learning series.

# Standard template for lessons

For coding standards see any of the early chapters. Keep it clean and tidy, and look at already written chapters to deduce structure as well as to see how chapters are stylicized, and how different elements (e.g. `> Some text.`) have been used previously.

Each lesson should start with a "Return to ToC", then an overview, and should end with a horizontal rule (`---`) and then a link to the next chapter as well as a "Return to ToC". Each chapter should preferably also contain some assignments.

For commands, the prompt (PS1) should be `[iocuser@host:pwd]`.

Open code blocks should have language definitions for highlighting to whatever degree possible; when the language isn't available (GitHub markdown is quite limited), use whatever works the best (see existing chapters for guidance).

## Loose notes

- Add info about where repos get cloned by default, suggest how to better organise them
- Chapter on Best Practises
- There should probably be a contact listed for questions
- Link to more external things; autosave, css phoebus, git submodules, etc.
- Possibly create separate mini-lessons for e3 users (non-devs)
- Add glossary page (appendixD?)
- Rename/reorganize supplementary dirs
- Complementary material should be cleaned up (and possibly removed)
- Chapters need to be better balanced

## Other subjects/content to add
* Multiple e3s in a host
* Hidden makefile rules (db, hdrs, vlibs, epics, and so on)
* siteLibs, handling vendor libraries
* compiling a module
* setE3env.bash
* e3.bash
* supplement tools (epics_NIOCs, pkg_automation, pciids, etherlabmaster, etc)
* sequencer
* db, template, subst files (msi and inflation)
* e3 configuration variables
* e3 building system
* require 
