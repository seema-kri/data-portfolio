--You are analyzing a social network dataset at Google. 
--Your task is to find mutual friends between two users, Karl and Hans. 
--There is only one user named Karl and one named Hans in the dataset.

--The output should contain 'user_id' and 'user_name' columns.

CREATE TABLE users(user_id INT, user_name varchar(30));
INSERT INTO users VALUES (1, 'Karl'), (2, 'Hans'), (3, 'Emma'), 
(4, 'Emma'), (5, 'Mike'), (6, 'Lucas'), (7, 'Sarah'), (8, 'Lucas'), 
(9, 'Anna'), (10, 'John');
select * from users

CREATE TABLE friends(user_id INT, friend_id INT);
INSERT INTO friends VALUES (1,3),(1,5),(2,3),(2,4),(3,1),
(3,2),(3,6),(4,7),(5,8),(6,9),(7,10),(8,6),(9,10),(10,7),(10,9);
select * from friends

with Karl as (
select friend_id
from friends
where user_id=1),

Hans as(
select friend_id
from friends
where user_id=2)

select u.user_id,u.user_name
from users u
join Karl K on u.user_id=K.friend_id
join Hans H on u.user_id=H.friend_id

--second solution
select u.user_id,u.user_name
from users u
where user_id in (
select friend_id from friends where user_id=1
intersect
select friend_id from friends where user_id=2)
