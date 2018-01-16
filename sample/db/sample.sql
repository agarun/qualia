CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username VARCHAR(255) NOT NULL
);

INSERT INTO
  users (id, username)
VALUES
  (1, "new_guy"),
  (2, "another_guy");

CREATE TABLE albums (
  id INTEGER PRIMARY KEY,
  album_title VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

INSERT INTO
  albums (id, album_title, user_id)
VALUES
  (1, "New Album", 2);

CREATE TABLE photos (
  id INTEGER PRIMARY KEY,
  photo_title VARCHAR(255) NOT NULL,
  photo_url VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,
  album_id INTEGER,
  FOREIGN KEY(user_id) REFERENCES users(id)
  FOREIGN KEY(album_id) REFERENCES albums(id)
);

INSERT INTO
  photos (id, photo_title, photo_url, user_id)
VALUES
  (1, "orange", "https://paradisenursery.com/wp-content/uploads/2014/04/Orange-Fruit-Pieces.jpg", 2),
  (2, "tomato", "https://cdn.shopify.com/s/files/1/1380/2059/products/Cherry-Tomato.jpg?v=1480318422", 1);
