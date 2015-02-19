v2.0.9 (2015-02-18)
-------------------
- reverting OpenSSL module namespace change

v2.0.8 (2015-02-18)
-------------------
- reverting chef_gem compile_time work

v2.0.7 (2015-02-18)
-------------------
- Updating to use the latest openssl

v2.0.6 (2015-02-18)
-------------------
- Fixing chef_gem for Chef below 12.1.0

v2.0.4 (2014-09-18)
-------------------
- [#11] prevent circular symlink for settings.json on Ubuntu 14.04
- Add Berksfile and test-kitchen config

v2.0.2 (2014-03-19)
-------------------
- [COOK-4424] Updates Transmission url in README'


v2.0.0
------
**Requires Ruby 1.9 or higher!**

### Bug
- **[COOK-3451](https://tickets.chef.io/browse/COOK-3451)** - Use Hash#key to silence Hash#index deprecation warnings
- **[COOK-3450](https://tickets.chef.io/browse/COOK-3450)** - Delete torrent local data when not seeding
- **[COOK-3449](https://tickets.chef.io/browse/COOK-3449)** - Prevent torrent status of checking from prematurely ending blocking downloads
- **[COOK-3324](https://tickets.chef.io/browse/COOK-3324)** - Use `BEncode.load_file` to load torrent file when hashing to avoid UTF-8 encoding issues

### Improvement
- **[COOK-2227](https://tickets.chef.io/browse/COOK-2227)** - Add watch dir options

v1.0.4
------
### Bug
- [COOK-2981]: transmission cookbook has foodcritic errors

v1.0.2
------
- [COOK-729]: `transmission_torrent_file` doesn't work for more than a single torrent
- [COOK-732]: link to file in swarm not created if torrent already completely downloaded
