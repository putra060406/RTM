require("dotenv").config();
const express = require("express");
const mysql = require("mysql2/promise");
const bodyParser = require("body-parser");
const session = require("express-session");
const bcrypt = require("bcrypt");
const cors = require("cors");
const path = require("path");

const app = express();
const port = process.env.PORT || 3000;

/* ---------------------- MIDDLEWARE ---------------------- */

app.use(cors({
  origin: true,
  credentials: true
}));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(
  session({
    name: "aihub.sid",
    secret: process.env.SESSION_SECRET || "secret_local",
    resave: false,
    saveUninitialized: false,
    cookie: {
      secure: false,
      httpOnly: true,
      sameSite: "lax"
    }
  })
);

app.use("/", express.static(path.join(__dirname, "public")));

/* ---------------------- DATABASE ---------------------- */

const pool = mysql.createPool({
  host: process.env.DB_HOST || "127.0.0.1",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "migration",
  waitForConnections: true,
  connectionLimit: 10,
});

/* ---------------------- AUTH HELPER ---------------------- */

function requireAuth(req, res, next) {
  if (req.session && req.session.user) return next();
  res.status(401).json({ error: "Unauthorized" });
}

/* ====================== AUTH ====================== */

app.post("/api/register", async (req, res) => {
  const { name, email, password } = req.body;
  if (!email || !password) return res.status(400).json({ error: "Invalid data" });

  const [exist] = await pool.query("SELECT id FROM users WHERE email=?", [email]);
  if (exist.length) return res.status(400).json({ error: "Email exists" });

  const hash = await bcrypt.hash(password, 10);
  const [ins] = await pool.query(
    "INSERT INTO users (name,email,password_hash) VALUES (?,?,?)",
    [name || "", email, hash]
  );

  req.session.user = { id: ins.insertId, email, name };
  res.json({ ok: true });
});

app.post("/api/login", async (req, res) => {
  const { email, password } = req.body;

  const [rows] = await pool.query("SELECT * FROM users WHERE email=?", [email]);
  if (!rows.length) return res.status(400).json({ error: "Invalid login" });

  const match = await bcrypt.compare(password, rows[0].password_hash);
  if (!match) return res.status(400).json({ error: "Invalid login" });

  req.session.user = {
    id: rows[0].id,
    email: rows[0].email,
    name: rows[0].name
  };

  res.json({ ok: true });
});

app.post("/api/logout", (req, res) => {
  req.session.destroy(() => res.json({ ok: true }));
});

/* ====================== CATEGORIES ====================== */

app.get("/api/categories", async (req, res) => {
  const [rows] = await pool.query("SELECT * FROM categories ORDER BY id");
  res.json({ categories: rows });
});

/* ====================== AI LIST ====================== */

app.get("/api/ai", async (req, res) => {
  const category = req.query.category;

  let sql = `
    SELECT a.*, c.name AS category_name
    FROM ai_entries a
    LEFT JOIN categories c ON a.category_id = c.id
    WHERE a.is_public = 1
  `;
  const params = [];

  if (category) {
    sql += " AND a.category_id = ?";
    params.push(category);
  }

  sql += " ORDER BY a.id DESC";

  const [rows] = await pool.query(sql, params);

  let favs = [];
  if (req.session.user) {
    const [f] = await pool.query(
      "SELECT ai_entry_id FROM favorites WHERE user_id=?",
      [req.session.user.id]
    );
    favs = f.map(r => r.ai_entry_id);
  }

  const ais = rows.map(r => ({
    ...r,
    favorited: favs.includes(r.id)
  }));

  res.json({ ais });
});


/* ====================== SEARCH ====================== */
app.get("/api/ai/search", async (req, res) => {
  const q = `%${req.query.q || ""}%`;

  const [rows] = await pool.query(`
    SELECT a.*, c.name AS category_name
    FROM ai_entries a
    LEFT JOIN categories c ON a.category_id = c.id
    WHERE a.is_public = 1 AND (
      a.title LIKE ?
      OR a.description LIKE ?
      OR a.full_description LIKE ?
      OR a.pros LIKE ?
      OR a.cons LIKE ?
    )
    ORDER BY a.id DESC
  `, [q, q, q, q, q]);

  let favs = [];
  if (req.session.user) {
    const [f] = await pool.query(
      "SELECT ai_entry_id FROM favorites WHERE user_id=?",
      [req.session.user.id]
    );
    favs = f.map(r => r.ai_entry_id);
  }

  const ais = rows.map(r => ({
    ...r,
    favorited: favs.includes(r.id)
  }));

  res.json({ ais });
});

/* ====================== DETAIL ====================== */
app.get("/api/ai/:id", async (req, res) => {
  const id = Number(req.params.id);

  // 🚨 VALIDASI WAJIB
  if (isNaN(id)) {
    return res.status(400).json({ error: "Invalid AI ID" });
  }

  const [rows] = await pool.query(
    `SELECT a.*, c.name AS category_name
     FROM ai_entries a
     LEFT JOIN categories c ON a.category_id = c.id
     WHERE a.id=? AND a.is_public=1`,
    [id]
  );

  if (!rows.length) {
    return res.status(404).json({ error: "AI not found" });
  }

  res.json({ ai: rows[0] });
});




/* ====================== FAVORITES (FIXED) ====================== */

app.post("/api/ai/:id/favorite", requireAuth, async (req, res) => {
  const userId = req.session.user.id;
  const aiId = parseInt(req.params.id);

  const [exist] = await pool.query(
    "SELECT id FROM favorites WHERE user_id=? AND ai_entry_id=?",
    [userId, aiId]
  );

  if (exist.length) {
    await pool.query("DELETE FROM favorites WHERE id=?", [exist[0].id]);
    return res.json({ ok: true, favorited: false });
  }

  await pool.query(
    "INSERT INTO favorites (user_id, ai_entry_id) VALUES (?,?)",
    [userId, aiId]
  );

  res.json({ ok: true, favorited: true });
});

app.get("/api/user/favorites", requireAuth, async (req, res) => {
  const [rows] = await pool.query(
    `SELECT a.*
     FROM ai_entries a
     JOIN favorites f ON a.id=f.ai_entry_id
     WHERE f.user_id=?`,
    [req.session.user.id]
  );

  res.json({ favorites: rows });
});

/* ====================== USER ====================== */

app.get("/api/me", (req, res) => {
  res.json({ user: req.session.user || null });
});

/* ====================== SERVER ====================== */

app.listen(port, () => {
  console.log("Server running at http://localhost:" + port);
});
