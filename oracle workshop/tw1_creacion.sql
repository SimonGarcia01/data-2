DROP TABLE users CASCADE CONSTRAINTS;
DROP TABLE tweets CASCADE CONSTRAINTS;
DROP TABLE followers CASCADE CONSTRAINTS;
DROP TABLE likes CASCADE CONSTRAINTS;
DROP TABLE comments CASCADE CONSTRAINTS;

COMMIT;

CREATE TABLE users (
  id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  username VARCHAR2(255) UNIQUE NOT NULL,
  email VARCHAR2(255) UNIQUE NOT NULL,
  password VARCHAR2(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tweets (
  id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id NUMBER REFERENCES users(id),
  content VARCHAR2(4000) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE followers (
  follower_id NUMBER REFERENCES users(id),
  following_id NUMBER REFERENCES users(id),
  PRIMARY KEY (follower_id, following_id)
);

CREATE TABLE likes (
  user_id NUMBER REFERENCES users(id),
  tweet_id NUMBER REFERENCES tweets(id),
  PRIMARY KEY (user_id, tweet_id)
);

CREATE TABLE comments (
  id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  tweet_id NUMBER REFERENCES tweets(id),
  user_id NUMBER REFERENCES users(id),
  content VARCHAR2(4000) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMIT;

-- Make a view to see the most commented tweets
CREATE OR REPLACE VIEW most_commented_tweet AS
SELECT t.id, t.content, u.username, u.email, COUNT(c.id) AS comment_count
FROM tweets t
JOIN users u ON t.user_id = u.id
LEFT JOIN comments c ON t.id = c.tweet_id
GROUP BY t.id, t.content, u.username, u.email
ORDER BY comment_count DESC;

--give access to gues_user
GRANT SELECT ON most_commented_tweet TO guest_user;

COMMIT;

-- Consult to get the top user with the most tweets
SELECT u.username, u.email, COUNT(t.id) AS tweet_count
FROM users u
LEFT JOIN tweets t on t.user_id = u.id
GROUP BY u.username, u.email
ORDER BY tweet_count DESC
FETCH FIRST 1 ROWS ONLY;

--Create a view with the top user with the most tweets
CREATE OR REPLACE VIEW top_author_by_tweets AS
SELECT u.username, u.email, COUNT(t.id) AS tweet_count
FROM users u
LEFT JOIN tweets t on t.user_id = u.id
GROUP BY u.username, u.email
ORDER BY tweet_count DESC
FETCH FIRST 1 ROWS ONLY;

-- Grant guest_user access to the view
GRANT SELECT ON top_author_by_tweets TO guest_user;

-- update the email of user pablocastro to pablo@gmail.com
UPDATE users SET email = 'pablo@gmail.com' WHERE username = 'pablocastro';

-- To see before and after the update
SELECT * FROM users WHERE username = 'pablocastro';

-- Trying to update a data point from the view
UPDATE top_author_by_tweets SET email = "juan@change.com" WHERE username = 'juanperez';