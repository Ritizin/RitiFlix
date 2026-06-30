const CACHE_NAME = 'ritiflix-cache-v1';
const ASSETS_TO_CACHE = [
  './',
  './index.html',
  './site.webmanifest',
  'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.49.1/dist/umd/supabase.min.js',
  'https://cdn.jsdelivr.net/npm/hls.js@1.5.15/dist/hls.min.js',
  'https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:wght@600;700&display=swap',
  'https://fonts.gstatic.com/s/outfit/v11/F3uwYwQ20dJ529OWyT-5s0tD.woff2',
  'https://fonts.gstatic.com/s/playfairdisplay/v37/nuFvD7Kzo1gY8F6KgNtF6VjBVFKeODvXX1Y3agbC.woff2'
];

// Install Event
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('[Service Worker] Caching app shell and CDNs');
        return cache.addAll(ASSETS_TO_CACHE);
      })
      .then(() => self.skipWaiting())
  );
});

// Activate Event
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheKeys => {
      return Promise.all(
        cacheKeys.map(key => {
          if (key !== CACHE_NAME) {
            console.log('[Service Worker] Removing old cache:', key);
            return caches.delete(key);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch Event
self.addEventListener('fetch', event => {
  // Only handle GET requests and local/CDN resources (exclude API calls to Supabase, TMDB, dood, superflix, etc.)
  if (event.request.method !== 'GET') return;

  const url = new URL(event.request.url);

  // Exclude Supabase database/auth requests and external movie APIs
  if (
    url.hostname.includes('supabase.co') && !url.pathname.endsWith('.js') ||
    url.hostname.includes('api.themoviedb.org') ||
    url.hostname.includes('superflixapi') ||
    url.hostname.includes('dood') ||
    url.hostname.includes('playmogo')
  ) {
    return;
  }

  event.respondWith(
    caches.match(event.request)
      .then(cachedResponse => {
        if (cachedResponse) {
          // Serve from cache and update in background if it's our index.html or local asset (stale-while-revalidate)
          if (url.origin === self.location.origin) {
            fetch(event.request)
              .then(networkResponse => {
                if (networkResponse.status === 200) {
                  caches.open(CACHE_NAME).then(cache => cache.put(event.request, networkResponse));
                }
              })
              .catch(() => {/* Ignore network errors when offline */});
          }
          return cachedResponse;
        }

        // Network fallback
        return fetch(event.request).then(networkResponse => {
          // Cache successful requests for fonts or third-party static CDNs
          if (
            networkResponse.status === 200 &&
            (url.hostname.includes('fonts.gstatic.com') || url.hostname.includes('fonts.googleapis.com') || url.pathname.endsWith('.woff2') || url.pathname.endsWith('.woff'))
          ) {
            const responseCopy = networkResponse.clone();
            caches.open(CACHE_NAME).then(cache => cache.put(event.request, responseCopy));
          }
          return networkResponse;
        }).catch(err => {
          // If offline and requesting document, return cached index.html
          if (event.request.mode === 'navigate') {
            return caches.match('./index.html') || caches.match('./');
          }
          throw err;
        });
      })
  );
});

// Message listener to trigger active updating
self.addEventListener('message', event => {
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
  }
});
