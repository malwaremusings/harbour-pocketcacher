FEATURE REQUEST
===============

* ProgressBar for loading pocket query

* Sort cache list by distance

* Filter cache list / caches on map
	- by type
	- by owner
	- by favourite points
	- by if trackables present

* Colour caches by type? May go against Sailfish design principes
	- use different icons instead

* Ability to link photos to caches and/or trackables

* Settings page
	- Editable XML namespaces (GroundSpeak changed their's from /1/0 to /1/0/1 for instance)
	- Option to limit pocket query load to x number of caches
	- Option to change the units (m / ft)

* Ability to load more than one pocket query at a time?

* Remember which pocket query/queries were loaded, and reload them on startup

* Ability to store info/clues for multicaches

* Heat maps of caches / area

* Map of trackables
	- give distance to (from cache)

* Heat map of trackables / area

* Alert if you come within x metres of a cache


ISSUES
======

* Pound Puppy Princess cache (GC44RNR) causes "cannot open: file:///images/icons/signal_smile.gif" suggesting that something in the cache long_description field is causing a file to be read!!
  Similarly with short_description
  It is parsing <img src="..."> tag from description VBT!

* Cache description page is not scrollable
  Suspect that this is because the components are filling the parent, so the size of the last component will only take it down to the bottom of the screen, rather than as tall as it needs to be to display the text.
