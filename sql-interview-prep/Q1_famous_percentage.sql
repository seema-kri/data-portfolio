

-- Q1: Famous Percentage of Users
-- Problem:
-- Find the famous percentage of each user.
-- Famous Percentage = (number of followers / total users) * 100
-- Table: famous(user_id, follower_id)


CREATE TABLE famous (
    user_id INT,
    follower_id INT
);

INSERT INTO famous VALUES
(1, 2), (1, 3), (2, 4), (5, 1), (5, 3),
(11, 7), (12, 8), (13, 5), (13, 10),
(14, 12), (14, 3), (15, 14), (15, 13);

-- Step 1: Get all unique users
WITH all_users AS (
    SELECT user_id FROM famous
    UNION
    SELECT follower_id FROM famous
),

-- Step 2: Count followers for each user
followers AS (
    SELECT user_id, COUNT(follower_id) AS follower_count
    FROM famous
    GROUP BY user_id
)

-- Step 3: Calculate famous percentage
SELECT 
    f.user_id,
    f.follower_count * 100.0 / (SELECT COUNT(*) FROM all_users) AS famous_percentage
FROM followers f
ORDER BY f.user_id ASC;
