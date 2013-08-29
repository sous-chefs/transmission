transmission Cookbook CHANGELOG
===============================
This file is used to list changes made in each version of the transmission cookbook.


v2.0.0
------
**Requires Ruby 1.9 or higher!**

### Bug
- **[COOK-3451](https://tickets.opscode.com/browse/COOK-3451)** - Use Hash#key to silence Hash#index deprecation warnings
- **[COOK-3450](https://tickets.opscode.com/browse/COOK-3450)** - Delete torrent local data when not seeding
- **[COOK-3449](https://tickets.opscode.com/browse/COOK-3449)** - Prevent torrent status of checking from prematurely ending blocking downloads
- **[COOK-3324](https://tickets.opscode.com/browse/COOK-3324)** - Use `BEncode.load_file` to load torrent file when hashing to avoid UTF-8 encoding issues

### Improvement
- **[COOK-2227](https://tickets.opscode.com/browse/COOK-2227)** - Add watch dir options

v1.0.4
------
### Bug
- [COOK-2981]: transmission cookbook has foodcritic errors

v1.0.2
------
- [COOK-729]: `transmission_torrent_file` doesn't work for more than a single torrent
- [COOK-732]: link to file in swarm not created if torrent already completely downloaded
