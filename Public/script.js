// public/script.js
const apiBase = '';

/* ---------- Utils ---------- */
async function api(path, opts = {}) {
  opts.headers = opts.headers || {};
  opts.credentials = 'include';
  if (opts.body && typeof opts.body === 'object' && !(opts.body instanceof FormData)) {
    opts.headers['Content-Type'] = 'application/json';
    opts.body = JSON.stringify(opts.body);
  }
  const res = await fetch(apiBase + path, opts);
  return res.json().catch(() => ({}));
}

/* ---------- UI init ---------- */
document.addEventListener('DOMContentLoaded', () => {
  const btnLogin = document.getElementById('btnLogin');
  const authModal = document.getElementById('authModal');
  const closeAuth = document.getElementById('closeAuth');
  const btnDashboard = document.getElementById('btnDashboard');
  const btnLogout = document.getElementById('btnLogout');
  const darkToggle = document.getElementById('darkToggle');

  btnLogin.addEventListener('click', () => openAuth('login'));
  closeAuth.addEventListener('click', () => authModal.style.display = 'none');

  btnDashboard.addEventListener('click', showDashboard);
  btnLogout.addEventListener('click', async () => {
    await api('/api/logout', { method: 'POST' });
    window.location.reload();
  });

  darkToggle.addEventListener('click', () => {
    const cur = document.documentElement.getAttribute('data-theme');
    document.documentElement.setAttribute('data-theme', cur === 'dark' ? '' : 'dark');
  });

  // search
  document.getElementById('searchBtn').addEventListener('click', async (e) => {
  e.preventDefault(); // 🔥 PENTING
  
  const q = document.getElementById('searchInput').value.trim();
  if (!q) {
    loadAI(); // tampilkan semua AI kalau kosong
    return;
  }

  const data = await api('/api/ai/search?q=' + encodeURIComponent(q));
  renderAI(data.ais || []);
});
 document.getElementById('searchInput').addEventListener('keydown', e => {
  if (e.key === 'Enter') {
    e.preventDefault();
    document.getElementById('searchBtn').click();
  }
});


  // load categories & ais & user state
  loadCategories();
  loadAI();
  loadMe();
});

/* ---------- Auth modal actions ---------- */
let authMode = 'login'; // or register
function openAuth(mode='login') {
  authMode = mode;
  document.getElementById('authTitle').innerText = mode === 'login' ? 'Login' : 'Register';
  document.getElementById('nameField').style.display = mode === 'register' ? 'block' : 'none';
  document.getElementById('authSubmit').innerText = mode === 'login' ? 'Login' : 'Register';
  document.getElementById('authModal').style.display = 'flex';
}
document.getElementById('switchToRegister').addEventListener('click', () => {
  openAuth(authMode === 'login' ? 'register' : 'login');
});
document.getElementById('authForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const name = document.getElementById('nameField').value;
  const email = document.getElementById('emailField').value;
  const password = document.getElementById('passField').value;
  if (authMode === 'register') {
    const res = await api('/api/register', { method: 'POST', body: { name, email, password }});
    if (res.ok) { location.reload(); } else { alert(res.error || 'Register failed'); }
  } else {
    const res = await api('/api/login', { method: 'POST', body: { email, password }});
    if (res.ok) { location.reload(); } else { alert(res.error || 'Login failed'); }
  }
});

/* ---------- Google Sign-In callback (global) ---------- */
async function handleGoogleCredentialResponse(response) {
  if (!response || !response.credential) return alert('Google sign-in failed');
  // send id_token to backend
  const res = await api('/api/google-login', { method: 'POST', body: { id_token: response.credential }});
  if (res.ok) location.reload();
  else alert(res.error || 'Google login failed');
}
window.handleGoogleCredentialResponse = handleGoogleCredentialResponse;

/* ---------- Load & render categories ---------- */
async function loadCategories() {
  const data = await api('/api/categories');
  const el = document.getElementById('categories');
  el.innerHTML = (data.categories || []).map(c => `<button class="cat-btn" data-id="${c.id}">${c.name}</button>`).join(' ');
  el.querySelectorAll('.cat-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const id = btn.getAttribute('data-id');
      loadAI(id);
    });
  });
}

/* ---------- Load & render AI ---------- */
async function loadAI(categoryId) {
  const q = categoryId ? `/api/ai?category=${categoryId}` : '/api/ai';
  const data = await api(q);
  renderAI(data.ais || []);
}

function renderAI(ais) {
  const el = document.getElementById('aiList');
  if (!ais.length) {
    el.innerHTML = '<p>Tidak ada AI ditemukan.</p>';
    return;
  }

  el.innerHTML = ais.map(a => `
    <div class="ai-card" onclick="location.href='/detail.html?id=${a.id}'">
      <img src="${a.icon_url || 'https://via.placeholder.com/64'}" />
      <div style="flex:1">
        <h3>${escapeHtml(a.title)}</h3>
        <p>${escapeHtml((a.description || '').slice(0, 150))}</p>
      </div>
      <div class="ai-actions">
        <button class="small favBtn" data-id="${a.id}">
          ${a.favorited ? 'Unfav' : 'Fav'}
        </button>
      </div>
    </div>
  `).join('');

  document.querySelectorAll('.favBtn')
    .forEach(b => b.addEventListener('click', e => {
      e.stopPropagation(); // 🔥 penting biar gak ikut redirect
      toggleFav(e);
    }));
}


/* ---------- Favorite toggle ---------- */
/* ---------- Favorite toggle (FIXED) ---------- */
async function toggleFav(e) {
  const btn = e.target;
  const id = btn.getAttribute('data-id');

  // optimis UI (langsung berubah)
  const isFav = btn.innerText === 'Unfav';
  btn.innerText = isFav ? 'Fav' : 'Unfav';

  const res = await api(`/api/ai/${id}/favorite`, { method: 'POST' });

  if (res.error === 'Unauthorized') {
    alert('Silakan login terlebih dahulu');
    btn.innerText = isFav ? 'Unfav' : 'Fav'; // rollback
    return;
  }

  if (!res.ok) {
    alert(res.error || 'Gagal');
    btn.innerText = isFav ? 'Unfav' : 'Fav'; // rollback
  }
}


/* ---------- Dashboard / favorites ---------- */
async function showDashboard() {
  const me = await api('/api/me');
  if (!me.user) { openAuth('login'); return; }
  document.getElementById('favoritesSection').style.display = 'block';
  const fav = await api('/api/user/favorites');
  const el = document.getElementById('favList');
  if (!fav.favorites || !fav.favorites.length) el.innerHTML = '<p>Belum ada favorit</p>';
  else el.innerHTML = fav.favorites.map(a => `
    <div class="ai-card">
      <img src="${a.icon_url || 'https://via.placeholder.com/64'}" />
      <div style="flex:1">
        <h3>${escapeHtml(a.title)}</h3>
        <p>${escapeHtml((a.description||'').slice(0,150))}</p>
      </div>
      <div class="ai-actions">
        <a class="small" href="${a.url}" target="_blank">Buka</a>
      </div>
    </div>
  `).join('');
}

/* ---------- Load current user ---------- */
async function loadMe() {
  const res = await api('/api/me');
  const u = res.user;
  const btnLogout = document.getElementById('btnLogout');
  const btnLogin = document.getElementById('btnLogin');
  if (u) {
    btnLogin.style.display = 'none';
    btnLogout.style.display = 'inline-block';
  } else {
    btnLogin.style.display = 'inline-block';
    btnLogout.style.display = 'none';
  }
}

/* ---------- small helpers ---------- */
function escapeHtml(s) {
  if (!s) return '';
  return s.replace(/[&<>"'`]/g, function(m) { return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;', '`':'&#96;'})[m]; });
}
