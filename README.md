# react-native-clear-cache

This app is a clone of [react-native-clear-app-cache](https://github.com/midas-gufei/react-native-clear-app-cache/) but transformed to work with RN 0.60+

## Getting started

Add to your package.json:

`"react-native-clear-cache": "sowlutions/react-native-clear-cache"`

### Mostly automatic installation

No need to link as of RN 0.60.

## Usage
```javascript
import ClearCache from 'react-native-clear-cache';

// get the storage usage
ClearCache.getAppCacheSize(data => {
  alert(data) // will show the App's storage usage in the app's cache.
});


// clear the storage
ClearCache.clearAppCache(data => {
  alert(data) // will alert the new size
});
```
