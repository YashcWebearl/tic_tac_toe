'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"assets/fonts/MaterialIcons-Regular.otf": "90be160a24aead390ec63d474286cc14",
"assets/AssetManifest.bin.json": "84d670f6f847d2e5339b95410fe495b5",
"assets/AssetManifest.bin": "44bac0c411536b985e17e8fd7bf98489",
"assets/AssetManifest.json": "afb94d1d5a35402cdb8255c9ec15d3fa",
"assets/assets/undo.png": "c0cc6905e13125731dea26b7444046bd",
"assets/assets/XOXO.png": "7fb5b2dd6d50f7883d414cdd250e81be",
"assets/assets/music/Win.mp3": "295af05bdbfa021de045bbf0c53c8dc4",
"assets/assets/music/button_click.mp3": "df4bf6204480b51482f09c991cd1157e",
"assets/assets/music/Lose.mp3": "d06f2be044e67d98ab155cb0a6e481d4",
"assets/assets/music/Xplace2.mp3": "9fb027e33592a88556c4e192e309c69f",
"assets/assets/music/Xplace.mp3": "b62f8ba00ecf20c65385a721b8a4ef5a",
"assets/assets/music/Money.mp3": "bc5c750f833f855961dda16cf4e63bb5",
"assets/assets/tic.png": "37c5321ba2368ac8379b85ee02faa181",
"assets/assets/fireworks.png": "f9020eaa6f4075f158975ca6e2b6eae9",
"assets/assets/20.png": "3dfc5e7a61d56f39fb93ca9daa914fda",
"assets/assets/Box.png": "57628f1624c0e2699b0ae779f1888dcd",
"assets/assets/free.png": "5c25f38c6ef49a22f3016776ea610d56",
"assets/assets/icon/icon.png": "7fb5b2dd6d50f7883d414cdd250e81be",
"assets/assets/XverseO.png": "6d57795b09c13e8f7c23180a19a3643b",
"assets/assets/SkipAd.png": "2df90ce245ea50451732dea11edc67da",
"assets/assets/coin.png": "2928d4b4c1023e2627b010874d2970b1",
"assets/assets/bot.png": "ece6f00f5f53bdafeb0417a64a861077",
"assets/assets/Ad.png": "9ebb9533d58cc8ba6072c4c38931d817",
"assets/assets/fireworksYellow.png": "938e309f8bf5fb57225ac127014bf8e0",
"assets/assets/logo.jpg": "a6b9a670ff335f007bbf17e62751b81e",
"assets/assets/logo.png": "6b5698b1ce199c15785a15f57d9ae6c1",
"assets/assets/google_logo.png": "f5a0de50d81d983c2dd5375e22a2c4ea",
"assets/assets/preimium.png": "a5cd7e262ce9d405534028d917e684e2",
"assets/assets/bg.png": "006ae11e5b1334825b194d3aba3fc85b",
"assets/assets/fireworksRed.png": "8c8a7d2a9920438124b604f06cc5af24",
"assets/assets/tic_tac_toe.png": "f65cbfbc250c54cbcbceb012133db2c4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "825e75415ebd366b740bb49659d7a5c6",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/flutter_soloud/web/libflutter_soloud_plugin.wasm": "1b4b250f7af5205c361574dbe06d4771",
"assets/packages/flutter_soloud/web/libflutter_soloud_plugin.js": "4a75ad67ab9c05facbad1d2e80b7692a",
"assets/packages/flutter_soloud/web/init_module.dart.js": "ea0b343660fd4dace81cfdc2910d14e6",
"assets/packages/flutter_soloud/web/worker.dart.js": "2fddc14058b5cc9ad8ba3a15749f9aef",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "f73d9d46916ee566afe7eebf28813fc5",
"main.dart.js": "25ef00d4e7543907390ccabf1d6c8e6e",
"manifest.json": "70fcb9ee21ebe2843591f331adf7fcf6",
"version.json": "a9545f40dfa73ffcdff9b15f37549e78",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"flutter_bootstrap.js": "d4370df0b905184eeaec3556ef3a19ea",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "8aea7b6c56581538dd52ab1222de3117",
"/": "8aea7b6c56581538dd52ab1222de3117",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c"};
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
