'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"manifest.json": "bd35ac33d702a77257ffed398c169385",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"index.html": "0a4af3a6d64dba11c3f40bf741f40392",
"/": "0a4af3a6d64dba11c3f40bf741f40392",
"flutter_bootstrap.js": "2a93cec0ac9d16137554353b6ce7dc68",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin": "22cfee9c8c8084332276c03ac2d7d2e0",
"assets/assets/audio/Go!.wav": "bb9b1ef27fa4034220401999617e2f21",
"assets/assets/audio/Shield.wav": "80c0f838dd0cef59607cfdb38f2ea28b",
"assets/assets/audio/Speed.wav": "8a0d83abb81fa30c13946be8bf499620",
"assets/assets/audio/Death.wav": "e07578f9290430e5bb4b5dc35189c1bc",
"assets/assets/audio/Jump.wav": "443de380c0a539b8a65ca4d84c343bd7",
"assets/assets/audio/Hurt.wav": "0ca0b767f6b0ec2bb26dc57ab18ce17c",
"assets/assets/audio/Snowman.wav": "53e5add0f88a03f6f1382fb2b2c12c9c",
"assets/assets/audio/itemBox.wav": "93ef72be198d53bdfa50465c9331a171",
"assets/assets/audio/Bullet.wav": "89612ecf57c225a448d76f264c71e7bf",
"assets/assets/audio/Collect.wav": "bd75de8298996cfe5aac89ef858d6eff",
"assets/assets/audio/boost.wav": "7932be68ad30dd09606d94c6da3b6c47",
"assets/assets/audio/321.wav": "90ab570092e7b188e48709436d302245",
"assets/assets/audio/8BitDNALoop.wav": "9bbdbf5d12ef61039347b75c41a386c7",
"assets/assets/tiles/avalanche.tsx": "796bddec3f0f68e6510d462821b85a87",
"assets/assets/tiles/Level3.tmx": "4e6d2c62e1b81c281ec53f0ffd259171",
"assets/assets/tiles/Gift.tsx": "d9788d688d2e704563935776cce894c0",
"assets/assets/tiles/boost_ramp.tsx": "a789a7a5a5f4d94ff7be456e8c489373",
"assets/assets/tiles/Level2.tmx": "d8bc16efe02d56a72db0fcfbbc07eb19",
"assets/assets/tiles/Level4.tmx": "4757a707793a61cae7f05b80d6a35d5c",
"assets/assets/tiles/Level1.tmx": "6a11a6b8189db5d1374923c23acad928",
"assets/assets/images/Shield.png": "4e3b32df95d0a184b6cb6a0335d35d66",
"assets/assets/images/ExplosionAnim.png": "81a3691935a18a30572870b759ad1683",
"assets/assets/images/tilemap_packed.png": "db783149e54e9ee8912a22887ae19e0e",
"assets/assets/images/Avalanche1.png": "5d3e3847aa057a1e7497367e72875f38",
"assets/assets/images/Gift.png": "ab9ef4d3e1c437abeb62a0640e6d79c5",
"assets/assets/images/ramp.png": "b63188bb844a00ff26a0ec53c2c29b15",
"assets/assets/images/Bullet.png": "05e54c78ea87060dc55678bf8a6796c8",
"assets/assets/images/GiftAnim.png": "3f17d7cca17ab44b293550f1b457bfdc",
"assets/assets/images/avalanche.png": "f06f2fd1b6583d9f214b9772a87909ad",
"assets/assets/images/BigAvalanch.png": "0724cc5e207e3db87f75feef66ccca3e",
"assets/assets/images/pause.png": "508b94119b3b2d564d9463cc012aa478",
"assets/assets/images/BulletAnim.png": "7c28576fa0a5aee141811cf379575ce6",
"assets/assets/images/Can.png": "3197c79f887b8c840922a2e1dc3bda47",
"assets/AssetManifest.bin.json": "dcb63772aceb723b31a48aa55cc8db52",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "d166d1774723f9f556ec610ba34a85c6",
"assets/fonts/MaterialIcons-Regular.otf": "5133dc5a466d6b2fb05694ed75ce3132",
"assets/AssetManifest.json": "96a3a61764a1e6307192ae6240c37c51",
"main.dart.js": "f9eb3caf1db671280cb0db4f7dfa8e9d",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "08c1c8d45ee6996d3920a98b505d4193",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
