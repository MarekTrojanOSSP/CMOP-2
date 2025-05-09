-- Adminer 4.8.1 MySQL 8.4.0 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `category` (`id`, `name`, `description`) VALUES
(1,	'Animal',	'Animal description'),
(2,	'neco',	'neoc');

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `content` text NOT NULL,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`),
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `comment` (`id`, `post_id`, `name`, `email`, `content`, `user_id`, `created_at`) VALUES
(1,	1,	'Fabia',	'cojsem@gmail.com',	' k',	NULL,	'2024-09-25 10:16:10'),
(2,	6,	'Fabia',	'cojsem@gmail.com',	'vvvvvvvvv',	NULL,	'2024-10-09 09:43:30'),
(3,	7,	'oh',	'oh@gmail.com',	'ohohohohohohohohoh',	NULL,	'2024-10-16 10:14:59'),
(4,	7,	'oh',	'oh@gmail.com',	'kkkkkkk',	NULL,	'2024-10-16 10:58:51'),
(5,	7,	'Fabia',	'cojsem@gmail.com',	'llll',	NULL,	'2024-10-23 09:54:13'),
(7,	11,	'Fabia',	'cowhat@gmail.com',	'ddddd',	NULL,	'2024-11-06 10:15:22'),
(15,	14,	'Mario',	'cowhat@gmail.com',	'cccc',	NULL,	'2025-03-26 11:04:34');

DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `view` int NOT NULL,
  `status` enum('OPEN','ARCHIVED','CLOSED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'OPEN',
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `post_ibfk_4` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `post_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `post` (`id`, `category_id`, `title`, `content`, `image`, `view`, `status`, `user_id`, `created_at`) VALUES
(1,	1,	'Article One',	'Lorem ipusm dolor one',	'',	0,	'OPEN',	NULL,	'2024-09-11 10:00:06'),
(2,	1,	'Article Two',	'Lorem ipsum dolor two',	'',	0,	'OPEN',	NULL,	'2024-09-11 10:00:06'),
(3,	1,	'Article Three',	'Lorem ipsum dolor three',	'',	1,	'OPEN',	NULL,	'2024-09-11 10:00:06'),
(4,	1,	'nový',	'voz',	'',	0,	'OPEN',	NULL,	'2024-10-09 09:33:03'),
(5,	1,	'nový',	'veveveveveveveve',	'',	0,	'OPEN',	NULL,	'2024-10-09 09:33:49'),
(6,	1,	'jeb',	'jebejbejebjebjbejbjbejbej',	'',	0,	'OPEN',	NULL,	'2024-10-09 09:43:22'),
(7,	1,	'oh no oh',	'ohohohohohohoh',	'',	6,	'OPEN',	NULL,	'2024-10-16 10:11:44'),
(10,	1,	'hgjhgjnvkbvhrbewvmsb hebe bejhbchk',	'mkhlffff',	'',	8,	'OPEN',	NULL,	'2024-10-23 10:20:38'),
(11,	1,	'gzgz',	'jzzufhvjuuuu',	'',	2,	'OPEN',	NULL,	'2024-10-23 11:19:18'),
(13,	1,	'Pes',	'Pes',	'',	22,	'OPEN',	NULL,	'2024-11-13 12:22:31'),
(14,	1,	'Oprava',	'oprava',	'',	106,	'ARCHIVED',	NULL,	'2024-11-13 12:23:01'),
(15,	2,	'Test',	'Hello world',	NULL,	87,	'CLOSED',	1,	'2024-11-27 11:28:39');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `firstname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `lastname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('admin','uzivatel') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'uzivatel',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `users` (`id`, `username`, `firstname`, `lastname`, `password`, `email`, `role`, `created_at`) VALUES
(1,	'marek.trojan',	'Marek',	'Trojan',	'$2y$10$RaKXLbRhEkWKGwIXEUpecOBntUyLPues8v8YQ1ejDpnEQ6CnuzNi2',	'marek.trojan@student.ossp.cz',	'admin',	'2025-05-08 17:45:07'),
(2,	'Oh',	'test',	'test',	'9dd8e985-2c35-11f0-8d48-0242ac110002',	'marek.trojan@student.ossp.cz',	'uzivatel',	'2025-05-08 17:56:23'),
(3,	'admin',	'test',	'test',	'$2y$10$tcAWja019pxyy399r1O7De03NqYq6IhkslhtHBPwRnfqFaNZxX.vy',	'marek.trojan@student.ossp.cz',	'uzivatel',	'2025-04-29 21:37:31'),
(6,	'test',	'test',	'test',	'$2y$10$2yJ3VNPUvMfrJCsPTaKDWetUbYLzCf.KgSrgxS1iciHfb32op4ckm',	'oh@gmail.com',	'uzivatel',	'2025-05-08 17:58:39'),
(7,	'my',	'my',	'my',	'$2y$10$lFFtNG57P08qTjxJBJkqe.RnYibE5p2Geb2ZSzJ3ygeIfWttkllta',	'cojsem@gmail.com',	'uzivatel',	'2025-05-08 17:59:55');

-- 2025-05-09 02:05:49