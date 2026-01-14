-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versi server:                 8.0.30 - MySQL Community Server - GPL
-- OS Server:                    Win64
-- HeidiSQL Versi:               12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Membuang struktur basisdata untuk migration
CREATE DATABASE IF NOT EXISTS `migration` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `migration`;

-- membuang struktur untuk table migration.ai_entries
CREATE TABLE IF NOT EXISTS `ai_entries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `category_id` int DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `icon_url` varchar(500) DEFAULT NULL,
  `tags` text,
  `is_public` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `full_description` text,
  `pros` text,
  `cons` text,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `ai_entries_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Membuang data untuk tabel migration.ai_entries: ~30 rows (lebih kurang)
INSERT INTO `ai_entries` (`id`, `title`, `description`, `category_id`, `url`, `icon_url`, `tags`, `is_public`, `created_at`, `full_description`, `pros`, `cons`) VALUES
	(1, 'ChatGPT', 'General AI assistant', 1, 'https://chat.openai.com/', '/assets/chatgpt.png', 'chat,learning,assistant', 1, '2025-12-15 05:39:49', 'ChatGPT adalah AI untuk percakapan dan coding', 'Cepat, fleksibel, banyak fitur', 'Kadang jawaban kurang akurat'),
	(2, 'Perplexity AI', 'AI search engine cerdas', 1, 'https://www.perplexity.ai/', '/assets/perplexity.png', 'search,learning', 1, '2025-12-15 05:39:49', 'Perplexity AI adalah mesin pencari berbasis AI dengan sumber referensi', 'Jawaban cepat, ada referensi', 'Fitur lanjutan berbayar'),
	(3, 'Google Gemini', 'AI multimodal untuk tugas general', 1, 'https://gemini.google.com/', '/assets/gemini.png', 'learning,multimodal', 1, '2025-12-15 05:39:49', 'Google Gemini adalah AI multimodal untuk teks, gambar, dan kode', 'Multimodal, integrasi Google', 'Belum stabil di semua fitur'),
	(4, 'Claude AI', 'AI conversation dari Anthropic', 1, 'https://claude.ai/', '/assets/claude.png', 'assistant,learning', 1, '2025-12-15 05:39:49', 'Claude AI adalah asisten AI dari Anthropic yang fokus pada percakapan aman', 'Natural, aman', 'Akses terbatas'),
	(5, 'Meta LLaMA', 'Open-source large language model', 1, 'https://llama.meta.com/', '/assets/llama.png', 'open-source,chat', 1, '2025-12-15 05:39:49', 'Meta LLaMA adalah model bahasa open-source dari Meta', 'Open-source, fleksibel', 'Perlu resource besar'),
	(6, 'Runway ML', 'AI video editor & generator', 2, 'https://runwayml.com/', '/assets/runway.png', 'video,edit', 1, '2025-12-15 05:40:06', 'Runway ML adalah AI untuk editing dan pembuatan video berbasis generatif', 'Powerful, hasil video realistis', 'Berbayar dan cukup berat'),
	(7, 'Pika Labs', 'Generate video dari prompt', 2, 'https://pika.art/', '/assets/pika.png', 'video,generator', 1, '2025-12-15 05:40:06', 'Pika Labs adalah AI untuk membuat video dari prompt teks', 'Mudah digunakan, cepat', 'Kontrol detail masih terbatas'),
	(8, 'Synthesia', 'AI avatar dan video presentasi', 2, 'https://www.synthesia.io/', '/assets/synthesia.png', 'video,avatar', 1, '2025-12-15 05:40:06', 'Synthesia adalah AI untuk membuat video presentasi dengan avatar', 'Avatar profesional, cocok untuk presentasi', 'Berbayar'),
	(9, 'HeyGen', 'AI avatar & dubbing', 2, 'https://www.heygen.com/', '/assets/heygen.png', 'video,dubbing', 1, '2025-12-15 05:40:06', 'HeyGen adalah AI avatar dan dubbing video otomatis', 'Banyak avatar, voice natural', 'Versi gratis terbatas'),
	(10, 'Veed.io', 'AI editing video otomatis', 2, 'https://www.veed.io/', '/assets/veed.png', 'video,editing', 1, '2025-12-15 05:40:06', 'Veed.io adalah AI editing video online yang otomatis', 'Mudah dipakai, berbasis web', 'Fitur lanjutan berbayar'),
	(11, 'Stable Diffusion', 'Generate gambar dari prompt', 3, 'https://stability.ai/', '/assets/sd.png', 'image,generation', 1, '2025-12-15 05:40:25', 'Stable Diffusion adalah AI open-source untuk generate gambar dari teks', 'Gratis, open-source, fleksibel', 'Perlu setup teknis'),
	(12, 'Midjourney', 'Realistic AI art generator', 3, 'https://www.midjourney.com/', '/assets/midjourney.png', 'image,art', 1, '2025-12-15 05:40:25', 'Midjourney adalah AI untuk membuat gambar artistik berkualitas tinggi', 'Hasil sangat detail dan artistik', 'Berbayar dan lewat Discord'),
	(13, 'DALL·E 3', 'Generate gambar high detail', 3, 'https://openai.com/dall-e-3/', '/assets/dalle.png', 'image,art,generator', 1, '2025-12-15 05:40:25', 'DALL·E 3 adalah AI OpenAI untuk menghasilkan gambar dari prompt teks', 'Akurat dengan prompt, mudah digunakan', 'Akses terbatas dan berbayar'),
	(14, 'Leonardo AI', 'Image editing & generation', 3, 'https://leonardo.ai/', '/assets/leonardo.png', 'image,edit', 1, '2025-12-15 05:40:25', 'Leonardo AI adalah AI untuk editing dan generasi gambar profesional', 'Cocok untuk desain dan game asset', 'Fitur lengkap berbayar'),
	(15, 'Canva AI', 'Editing gambar praktis', 3, 'https://www.canva.com/ai/', '/assets/canva.png', 'design,image,edit', 1, '2025-12-15 05:40:25', 'Canva AI membantu desain visual dan edit gambar secara praktis', 'Mudah digunakan, cocok pemula', 'Fitur AI lanjutan berbayar'),
	(16, 'WriteSonic', 'AI writing assistant', 4, 'https://writesonic.com/', '/assets/writesonic.png', 'writing,copy', 1, '2025-12-15 05:40:45', 'WriteSonic adalah AI untuk membantu penulisan konten dan copywriting', 'Cepat, banyak template', 'Versi gratis terbatas'),
	(17, 'Jasper AI', 'AI copywriting premium', 4, 'https://www.jasper.ai/', '/assets/jasper.png', 'writing,marketing', 1, '2025-12-15 05:40:45', 'Jasper AI adalah AI copywriting premium untuk marketing dan bisnis', 'Hasil profesional, cocok marketing', 'Berbayar cukup mahal'),
	(18, 'Grammarly AI', 'AI grammar & rewriting', 4, 'https://grammarly.com/', '/assets/grammarly.png', 'writing,grammar', 1, '2025-12-15 05:40:45', 'Grammarly AI membantu memperbaiki tata bahasa dan gaya penulisan', 'Akurat, mudah digunakan', 'Fitur lengkap berbayar'),
	(19, 'Copy.ai', 'AI marketing content', 4, 'https://copy.ai/', '/assets/copyai.png', 'writing,copy', 1, '2025-12-15 05:40:45', 'Copy.ai adalah AI untuk membuat konten marketing dan copy iklan', 'Cocok untuk marketing', 'Kontrol bahasa terbatas'),
	(20, 'Rytr', 'Writing assistant murah', 4, 'https://rytr.me/', '/assets/rytr.png', 'writing', 1, '2025-12-15 05:40:45', 'Rytr adalah AI writing assistant ringan dan terjangkau', 'Murah, cepat digunakan', 'Hasil kurang kompleks'),
	(21, 'GitHub Copilot', 'Kode assistant', 5, 'https://github.com/features/copilot', '/assets/copilot.png', 'code,assistant', 1, '2025-12-15 05:40:58', 'Devin AI adalah AI software engineer yang dapat menulis, menjalankan, dan memperbaiki kode secara otomatis', 'Otomatisasi tinggi, bisa end-to-end', 'Masih terbatas akses dan mahal'),
	(22, 'Codeium', 'AI coding gratis', 5, 'https://codeium.com/', '/assets/codeium.png', 'code', 1, '2025-12-15 05:40:58', 'Replit Ghostwriter adalah AI coding assistant terintegrasi langsung di Replit IDE', 'Langsung di IDE, mudah digunakan', 'Fitur lanjutan berbayar'),
	(23, 'Tabnine', 'AI autocomplete coding', 5, 'https://www.tabnine.com/', '/assets/tabnine.png', 'code,autocomplete', 1, '2025-12-15 05:40:58', 'Tabnine adalah AI code completion yang mendukung banyak bahasa pemrograman', 'Cepat, privasi terjaga', 'Kurang konteks kompleks'),
	(24, 'Replit Ghostwriter', 'AI coding di Replit', 5, 'https://replit.com/', '/assets/replit.png', 'code,learning', 1, '2025-12-15 05:40:58', 'Codeium adalah AI coding assistant gratis untuk auto-complete dan chat kode', 'Gratis, mendukung banyak IDE', 'Kadang saran kurang akurat'),
	(25, 'Devin AI', 'AI autonomous coding', 5, 'https://www.devin.ai/', '/assets/devin.png', 'code,automation', 1, '2025-12-15 05:40:58', 'GitHub Copilot adalah AI pair programmer dari GitHub dan OpenAI', 'Sangat pintar, produktivitas tinggi', 'Berbayar dan butuh internet'),
	(26, 'Suno AI', 'AI generator musik', 6, 'https://suno.ai/', '/assets/suno.png', 'music,generator', 1, '2025-12-15 05:41:14', 'AIVA adalah AI untuk membuat musik orkestra dan cinematic secara otomatis', 'Cocok untuk film dan game, kualitas tinggi', 'Kurang fleksibel untuk genre modern'),
	(27, 'Udio AI', 'Bikin lagu dengan prompt', 6, 'https://www.udio.com/', '/assets/udio.png', 'music', 1, '2025-12-15 05:41:14', 'Mubert adalah AI yang menghasilkan musik bebas royalti secara real-time', 'Royalty-free, cocok untuk konten', 'Musik terasa repetitif'),
	(28, 'Stable Audio', 'Generate audio', 6, 'https://stableaudio.com/', '/assets/stableaudio.png', 'music,audio', 1, '2025-12-15 05:41:14', 'Stable Audio adalah AI dari Stability AI untuk membuat musik dan sound effect', 'Kualitas profesional, kontrol detail', 'Butuh prompt yang jelas'),
	(29, 'Mubert', 'AI background music', 6, 'https://mubert.com/', '/assets/mubert.png', 'music', 1, '2025-12-15 05:41:14', 'Udio AI adalah AI untuk membuat lagu lengkap dengan vokal dan lirik', 'Hasil lagu realistis', 'Masih terbatas genre'),
	(30, 'AIVA', 'AI composer musik', 6, 'https://aiva.ai/', '/assets/aiva.png', 'music,composer', 1, '2025-12-15 05:41:14', 'Suno AI adalah AI pembuat lagu otomatis dari teks', 'Mudah digunakan, cepat', 'Kontrol musik terbatas');

-- membuang struktur untuk table migration.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Membuang data untuk tabel migration.categories: ~6 rows (lebih kurang)
INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `created_at`) VALUES
	(1, 'Belajar', 'belajar', 'AI untuk belajar dan pendidikan', '2025-12-15 05:39:30'),
	(2, 'Edit Video', 'edit-video', 'AI untuk mengedit video', '2025-12-15 05:39:30'),
	(3, 'Generate Gambar', 'generate-gambar', 'AI untuk generative art & image', '2025-12-15 05:39:30'),
	(4, 'Writing', 'writing', 'AI untuk menulis, copy, dan summary', '2025-12-15 05:39:30'),
	(5, 'Coding', 'coding', 'AI assistant untuk coding & dev', '2025-12-15 05:39:30'),
	(6, 'Music AI', 'music-ai', 'AI untuk membuat musik, audio, dan komposisi', '2025-12-15 05:39:30');

-- membuang struktur untuk table migration.favorites
CREATE TABLE IF NOT EXISTS `favorites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `ai_entry_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_user_ai` (`user_id`,`ai_entry_id`),
  KEY `ai_entry_id` (`ai_entry_id`),
  CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`ai_entry_id`) REFERENCES `ai_entries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Membuang data untuk tabel migration.favorites: ~0 rows (lebih kurang)

-- membuang struktur untuk table migration.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Membuang data untuk tabel migration.users: ~0 rows (lebih kurang)
INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `google_id`, `created_at`) VALUES
	(5, 'konek', 'hahahh@gmail.com', '$2b$10$RNQaJthK8FO8NtmLLwsCuuOfLqzU0RRi4fODzTQSUKhoB8.Nct6oW', NULL, '2026-01-14 13:06:06');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
