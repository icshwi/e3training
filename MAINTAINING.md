# Maintainers' notes

This file is meant to outline the structure of this repo, and to host some information useful prior to rework of this learning series.

# Standard template for lessons

For coding standards see any of the early chapters. Keep it clean and tidy, and see how different elements (e.g. `> Some text.`) have been used previously.

Each lesson should start with a "Return to ToC", then an overview, and should end with a horizontal rule (`---`) and then a link to the next chapter as well as a "Return to ToC".

For commands, the prompt (PS1) should be `[iocuser@host:pwd]`.

Open code blocks should have language definitions for highlighting to whatever degree possible; when the language isn't available (GitHub markdown is quite limited), use whatever works the best.

# To-Do

[x] Clean up all existing chapters
[ ] Do the full tutorial to ensure all steps work
[ ] Clean up all complementary material
[x] Outline what had been thought-up by Han previously for future chapters
[ ] Balance the chapters better
[ ] Add assignments to all chapters
[ ] Think of a logical separation for parts 1 and 2 or remove separation; best option currently seems to be 1) e3 core, 2) e3 advanced and ESS-tools

## Loose notes

- Add info about where repos get cloned by default, suggest how to better organise them
- Chapter on Best Practises
- There should probably be a contact listed for questions
- Link to more external things; autosave, css phoebus, git submodules, etc.
- Possibly create separate mini-lessons for e3 users (non-devs)
- Add glossary page (appendixC?)
- Rename/reorganize supplementary dirs


## Other subjects/content to add
* Multiple e3s in a host
* Hidden makefile rules (db, hdrs, vlibs, epics, and so on)
* setE3env.bash
* e3.bash
* supplement tools (epics_NIOCs, pkg_automation, pciids, etherlabmaster, etc)
* sequencer
* db, template, subst files (msi and inflation)
* e3 configuration variables
* e3 building system
* systemd, procServ, and conserver 
* require 
