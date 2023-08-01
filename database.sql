SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS bookartify;

USE bookartify;


DROP TABLE likes_cover;
DROP TABLE likes_art;
DROP TABLE bookmarks_cover;
DROP TABLE bookmarks_art;
DROP TABLE follows_user;
DROP TABLE follows_book;
DROP TABLE covers;
DROP TABLE art;
DROP TABLE users;


CREATE TABLE users (
    id varchar(512) NOT NULL UNIQUE,
    username VARCHAR(255) UNIQUE,
    bio TEXT,
    profile_pic_url VARCHAR(2083),
    goodreads_url VARCHAR(1024),
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* CREATE TABLE books (
    id int(11) NOT NULL UNIQUE,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; */

CREATE TABLE follows_user (
	id int(11) NOT NULL AUTO_INCREMENT,
    user_id varchar(512) NOT NULL,
    following_id varchar(512) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (following_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE follows_book (
	id int(11) NOT NULL AUTO_INCREMENT,
    user_id varchar(512) NOT NULL,
    following_id varchar(512) NOT NULL, -- book id
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE art (
    id int(11) NOT NULL AUTO_INCREMENT,
    title varchar(512) DEFAULT NULL,
    description text DEFAULT NULL,
    book_id varchar(512) DEFAULT NULL, 
    user_id varchar(512) DEFAULT NULL,
    url varchar(2083) NOT NULL, -- image url
    date_upload datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE covers (
    id int(11) NOT NULL AUTO_INCREMENT,
    title varchar(512) DEFAULT NULL,
    description text DEFAULT NULL,
    book_id varchar(512) DEFAULT NULL, 
    user_id varchar(512) DEFAULT NULL,
    url varchar(2083) NOT NULL, -- image url
    date_upload datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE likes_art (
    id int(11) NOT NULL AUTO_INCREMENT,
    user_id varchar(512) NOT NULL,
    art_id int(11) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (art_id) REFERENCES art(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE likes_cover (
    id int(11) NOT NULL AUTO_INCREMENT,
    user_id varchar(512) NOT NULL,
    cover_id int(11) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (cover_id) REFERENCES covers(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE bookmarks_art (
    id int(11) NOT NULL AUTO_INCREMENT,
    user_id varchar(512) NOT NULL,
    art_id int(11) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (art_id) REFERENCES art(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE bookmarks_cover (
    id int(11) NOT NULL AUTO_INCREMENT,
    user_id varchar(512) NOT NULL,
    cover_id int(11) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (cover_id) REFERENCES covers(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO users (id) VALUES ("S5zT8izdcGWIena7LDy4gvGD3xj1");
INSERT INTO users (id) VALUES ("gqcMY55VHkfBbe2SjQK32V3fzlX2");
INSERT INTO users (id) VALUES ("O3aqrodddERdFxpBAxkIWhzfcvZ2");
INSERT INTO users (id) VALUES ("XnPYzAx8vKhUoorhfx6r7CfySrT2");
INSERT INTO users (id) VALUES ("0RQtZ8A8PZMEWgLtblFcgdYVL202");
INSERT INTO users (id) VALUES ("XZWD1HQnosgly5mh3sR4At9EluF3");
INSERT INTO users (id) VALUES ("2K4JvAwXAXfaA1KWs8eP10XLT9g2");

INSERT INTO follows_user (user_id, following_id) VALUES ("gqcMY55VHkfBbe2SjQK32V3fzlX2", "S5zT8izdcGWIena7LDy4gvGD3xj1");
INSERT INTO follows_user (user_id, following_id) VALUES	("S5zT8izdcGWIena7LDy4gvGD3xj1", "0RQtZ8A8PZMEWgLtblFcgdYVL202");

INSERT INTO covers (title, book_id, user_id, url) VALUES ("Dune", "q_5WzQEACAAJ", "S5zT8izdcGWIena7LDy4gvGD3xj1", "https://firebasestorage.googleapis.com/v0/b/bookartify-idm.appspot.com/o/S5zT8izdcGWIena7LDy4gvGD3xj1%2Fcover%2Fdune.jpg?alt=media&token=c80c414c-dbdf-4262-ae8b-c35beeda4782");
INSERT INTO art (title, book_id, user_id, url) VALUES ("Evelyn Hugo", "cPlBEAAAQBAJ", "S5zT8izdcGWIena7LDy4gvGD3xj1", "https://firebasestorage.googleapis.com/v0/b/bookartify-idm.appspot.com/o/S5zT8izdcGWIena7LDy4gvGD3xj1%2Fart%2Ffanart.jpg?alt=media&token=84f80be3-3f60-400d-8326-3ac807bd370a");
INSERT INTO art (title, book_id, user_id, url) VALUES ("Harry's friendships", "nYKYzgEACAAJ", "S5zT8izdcGWIena7LDy4gvGD3xj1", "https://firebasestorage.googleapis.com/v0/b/bookartify-idm.appspot.com/o/S5zT8izdcGWIena7LDy4gvGD3xj1%2Fart%2Fharry_potter_2.jpg?alt=media&token=c1c33ee8-5b39-499b-93ed-b23fc7d28c26");
INSERT INTO art (title, book_id, user_id, url) VALUES ("Marianne & Connell", "vrpPEAAAQBAJ", "0RQtZ8A8PZMEWgLtblFcgdYVL202", "https://firebasestorage.googleapis.com/v0/b/bookartify-idm.appspot.com/o/0RQtZ8A8PZMEWgLtblFcgdYVL202%2Fart%2Fnormal_people.jpg?alt=media&token=58946833-1167-4723-a062-c834f1477e0b");

INSERT INTO bookmarks_cover (user_id, cover_id) VALUES ("S5zT8izdcGWIena7LDy4gvGD3xj1", 1);

-- get bookmarks
SELECT 'art' AS type, a.id, a.title, a.description, a.book_id, a.user_id, a.url, a.date_upload
FROM art a
JOIN bookmarks_art ba ON a.id = ba.art_id
WHERE ba.user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"
UNION
SELECT 'cover' AS type, c.id, c.title, c.description, c.book_id, c.user_id, c.url, c.date_upload
FROM covers c
JOIN bookmarks_cover bc ON c.id = bc.cover_id
WHERE bc.user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1";

-- get following
SELECT GROUP_CONCAT(DISTINCT following_id) as following FROM follows_user WHERE user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"; -- list
SELECT COUNT(DISTINCT following_id) as following FROM follows_user WHERE user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"; -- count

-- get followers
SELECT GROUP_CONCAT(DISTINCT user_id) as followers FROM follows_user WHERE following_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"; -- list 
SELECT COUNT(DISTINCT user_id) as followers FROM follows_user WHERE following_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"; -- count

-- get following list for several users
SELECT user_id, GROUP_CONCAT(DISTINCT follower_id SEPARATOR ', ') as following 
FROM follows_user GROUP BY user_id;

-- for you page
SELECT type, id, title, description, book_id, user_id, url, date_upload
FROM (
    SELECT 'art' AS type, a.id, a.title, a.description, a.book_id, a.user_id, a.url, a.date_upload
    FROM art a
    INNER JOIN follows_user ON a.user_id = follows_user.following_id
    WHERE follows_user.user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"
    
    UNION ALL
    
    SELECT 'cover' AS type, c.id, c.title, c.description, c.book_id, c.user_id, c.url, c.date_upload
    FROM covers c
    INNER JOIN follows_user ON c.user_id = follows_user.following_id
    WHERE follows_user.user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"
    
    UNION ALL
    
    SELECT 'art' AS type, a.id, a.title, a.description, a.book_id, a.user_id, a.url, a.date_upload
    FROM art a
    WHERE a.user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"
    
    UNION ALL
    
    SELECT 'cover' AS type, c.id, c.title, c.description, c.book_id, c.user_id, c.url, c.date_upload
    FROM covers c
    WHERE c.user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"
    
    UNION ALL
    
    SELECT 'art' AS type, a.id, a.title, a.description, a.book_id, a.user_id, a.url, a.date_upload
    FROM art a
    INNER JOIN follows_book ON a.book_id = follows_book.following_id
    WHERE follows_book.user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"
    
    UNION ALL
    
    SELECT 'cover' AS type, c.id, c.title, c.description, c.book_id, c.user_id, c.url, c.date_upload
    FROM covers c
    INNER JOIN follows_book ON c.book_id = follows_book.following_id
    WHERE follows_book.user_id = "S5zT8izdcGWIena7LDy4gvGD3xj1"
) AS all_posts
GROUP BY type, id, title, description, book_id, user_id, url, date_upload
ORDER BY date_upload DESC;
