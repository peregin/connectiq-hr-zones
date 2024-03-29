[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Issues](https://img.shields.io/github/issues/peregin/connectiq-hr-zones.svg)](https://github.com/peregin/connectiq-hr-zones/issues)

Garmin data field with heart rate and zones
===========================================

The data field shows the current and average hear rate as main indicators. 
On the top of the screen it displays a histogram with the time spent in the five heart rate zones.

![edge820](https://raw.github.com/peregin/connectiq-hr-zones/master/doc/edge820.png "edge820")
&nbsp;
![edge520](https://raw.github.com/peregin/connectiq-hr-zones/master/doc/edge520.png "edge850")
&nbsp;
![fr735xt](https://raw.github.com/peregin/connectiq-hr-zones/master/doc/fr735xt.png "fr735xt")
&nbsp;
![gf935](https://raw.github.com/peregin/connectiq-hr-zones/master/doc/gf935.png "fr735xt")
&nbsp;
![explorer2](https://raw.github.com/peregin/connectiq-hr-zones/master/doc/explorer2.png "explorer2")

Build
=====

Package
---
Build package ready to deploy to Garmin App store.
```shell
make package
```

Manual Deployment
---

Copy the prg file over the `/GARMIN/APPS/` folder.