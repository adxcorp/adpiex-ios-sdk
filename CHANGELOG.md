
# Change log

### 1.0.6 (2026/08/03)
 - Improved developer log activation and output
 - Fixed an issue where the internal state remained SHOW even after the rewarded/interstitial ad was closed
 - Changed the SID (Slot ID) property of rewarded/interstitial ads to read-only
 - Added TTL-based ad expiration/reuse logic
 - Applied Skip Message to interstitial/rewarded ads
 - Added automatic video cache cleanup when initializing SDK
 - Recently reused cached videos are now deprioritized for deletion (LWU timestamp refresh)

### 1.0.5 (2026/06/29)
 - Allow SSV data to be updated after ad load

### 1.0.4 (2026/06/25)
 - Fixed an issue where log messages with level 800 or below were hidden as Private in the console
 - Added atomic check-and-update logic to prevent race conditions when validating ad request time
 - Removed query string count validation before sending SSV

### 1.0.3 (2026/05/13)
 - Improved video UI
 - Added auto-close for interstitial video ads
 - Added skip support for rewarded video ads

### 1.0.2 (2026/03/16)
 - Improved SDK stability
 
### 1.0.1 (2026/01/21)
 - Add fail-to-show delegate methods for interstitial and rewarded ads 
 
### 1.0.0 (2025/12/12)
 - Migrated Domestic Version to Global Version (AdPie SDK 1.6.14)
