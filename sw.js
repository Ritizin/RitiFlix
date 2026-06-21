// RitiFlix Service Worker - PWA Offline Support
const CACHE_NAME = 'ritiflix-v1';
const STATIC_CACHE = 'ritiflix-static-v1';
const DYNAMIC_CACHE = 'ritiflix-dynamic-v1';

// Arquivos essenciais para cache estático (shell do app)
const STATIC_ASSETS = [
  '/',
  '/index.html',
  '/manifest.json',
  'https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:wght@600;700&display=swap'
];

// ============================================================
// INSTALL — faz cache dos assets estáticos
// ============================================================
self.addEventListener('install', event => {
  console.log('[SW] Instalando RitiFlix Service Worker...');
  event.waitUntil(
    caches.open(STATIC_CACHE).then(cache => {
      console.log('[SW] Cacheando assets estáticos...');
      return cache.addAll(STATIC_ASSETS);
    }).then(() => self.skipWaiting())
  );
});

// ============================================================
// ACTIVATE — limpa caches antigos
// ============================================================
self.addEventListener('activate', event => {
  console.log('[SW] Ativando RitiFlix Service Worker...');
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys
          .filter(key => key !== STATIC_CACHE && key !== DYNAMIC_CACHE)
          .map(key => {
            console.log('[SW] Removendo cache antigo:', key);
            return caches.delete(key);
          })
      );
    }).then(() => self.clients.claim())
  );
});

// ============================================================
// FETCH — estratégia de cache
// ============================================================
self.addEventListener('fetch', event => {
  const { request } = event;
  const url = new URL(request.url);

  // Ignora requisições não-GET
  if (request.method !== 'GET') return;

  // Ignora requisições para APIs externas (Supabase, TMDB) — sempre online
  if (
    url.hostname.includes('supabase.co') ||
    url.hostname.includes('themoviedb.org') ||
    url.hostname.includes('image.tmdb.org')
  ) {
    event.respondWith(
      fetch(request).catch(() => new Response(JSON.stringify({ error: 'Offline' }), {
        headers: { 'Content-Type': 'application/json' }
      }))
    );
    return;
  }

  // Para imagens externas (posters, thumbs) — cache dinâmico
  if (request.destination === 'image' && !url.hostname.includes(self.location.hostname)) {
    event.respondWith(networkFallingBackToCache(request));
    return;
  }

  // Para assets do app — Cache First
  if (
    url.hostname === self.location.hostname ||
    url.hostname.includes('fonts.googleapis.com') ||
    url.hostname.includes('fonts.gstatic.com') ||
    url.hostname.includes('cdn.jsdelivr.net')
  ) {
    event.respondWith(cacheFirstStrategy(request));
    return;
  }

  // Fallback padrão — Network First
  event.respondWith(networkFirstStrategy(request));
});

// ============================================================
// ESTRATÉGIAS DE CACHE
// ============================================================

// Cache First: usa cache se disponível, senão busca na rede
async function cacheFirstStrategy(request) {
  const cached = await caches.match(request);
  if (cached) return cached;
  try {
    const response = await fetch(request);
    if (response.ok) {
      const cache = await caches.open(STATIC_CACHE);
      cache.put(request, response.clone());
    }
    return response;
  } catch (err) {
    return new Response('<h1>Sem conexão</h1><p>Verifique sua internet.</p>', {
      headers: { 'Content-Type': 'text/html' }
    });
  }
}

// Network First: tenta a rede, cai para cache se offline
async function networkFirstStrategy(request) {
  try {
    const response = await fetch(request);
    if (response.ok) {
      const cache = await caches.open(DYNAMIC_CACHE);
      cache.put(request, response.clone());
    }
    return response;
  } catch (err) {
    const cached = await caches.match(request);
    return cached || new Response('<h1>Offline</h1>', {
      headers: { 'Content-Type': 'text/html' }
    });
  }
}

// Network falling back to cache (para imagens)
async function networkFallingBackToCache(request) {
  try {
    const response = await fetch(request);
    if (response.ok) {
      const cache = await caches.open(DYNAMIC_CACHE);
      // Limita cache dinâmico a 60 imagens
      await trimCache(DYNAMIC_CACHE, 60);
      cache.put(request, response.clone());
    }
    return response;
  } catch (err) {
    const cached = await caches.match(request);
    if (cached) return cached;
    // Retorna placeholder SVG para imagens não disponíveis
    return new Response(
      `<svg xmlns="http://www.w3.org/2000/svg" width="300" height="450" viewBox="0 0 300 450">
        <rect width="300" height="450" fill="#0d1117"/>
        <text x="150" y="225" fill="#445577" text-anchor="middle" font-family="sans-serif" font-size="14">Imagem indisponível</text>
      </svg>`,
      { headers: { 'Content-Type': 'image/svg+xml' } }
    );
  }
}

// Limita o tamanho do cache dinâmico
async function trimCache(cacheName, maxItems) {
  const cache = await caches.open(cacheName);
  const keys = await cache.keys();
  if (keys.length > maxItems) {
    await cache.delete(keys[0]);
  }
}

// ============================================================
// PUSH NOTIFICATIONS (estrutura base)
// ============================================================
self.addEventListener('push', event => {
  if (!event.data) return;
  const data = event.data.json();
  self.registration.showNotification(data.title || 'RitiFlix', {
    body: data.body || 'Novo conteúdo disponível!',
    icon: '/icons/icon-192x192.png',
    badge: '/icons/icon-72x72.png',
    tag: 'ritiflix-notif',
    renotify: true
  });
});

self.addEventListener('notificationclick', event => {
  event.notification.close();
  event.waitUntil(
    clients.openWindow('/')
  );
});
