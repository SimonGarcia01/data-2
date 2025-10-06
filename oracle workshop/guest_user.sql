-- To check which tables can be seen
SELECT * FROM tw1.users;
SELECT * FROM tw1.comments;

-- check the view most_commented_tweet
SELECT * FROM tw1.most_commented_tweet;

-- Use the view of top authors
SELECT * FROM tw1.TOP_AUTHOR_BY_TWEETS;

-- Check if guest_user cas see tweets
SELECT * FROM tw1.tweets;

-- Check if guest_user can use TOP_USERS synonym
SELECT * FROM TOP_USERS;