-- TODO: Implementation
create keyspace users_posts_ks
            with replication = {'class':'SimpleStrategy','replication_factor':1};
use users_posts_ks;
----------------------------
-- 1 task
create table post_on_create
(
    post_id    int,
    content    text,
    created_at timestamp,
    user_id    int,
    username   varchar,
    primary key ( user_id, created_at, post_id )
) with clustering order by (created_at desc);
select post_id, content, created_at
from post_on_create
where user_id = ?;
----------------------------
-- 2 task
select post_id, content, created_at, username
from post_on_create
where user_id = ?
limit 1;
----------------------------
-- 3 task
select post_id, content, created_at
from post_on_create
where user_id = ?
  and created_at > ?;
----------------------------
-- 4 task
create table users_on_post_created
(
    user_id    int,
    username   varchar,
    post_id    int,
    post_date  date,
    created_at timestamp,
    topic_id   int,
    primary key ( (post_date, topic_id), created_at, post_id )
) with clustering order by (created_at desc);
select user_id, username, post_id, created_at
from users_on_post_created
where post_date = ?
  and topic_id = ?;
