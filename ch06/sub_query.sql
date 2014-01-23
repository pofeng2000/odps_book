-- sub query
SELECT a.user_id, b.cnt
FROM (SELECT user_id FROM user) a
JOIN 
    (SELECT pv.user_id, count(*) as cnt FROM page_view pv group by pv.user_id) b
ON a.user_id = b.user_id;

SELECT pv.*
FROM page_view pv
WHERE pv.user_id IN
(SELECT user.user_id from user);

-- this will not work
SELECT pv.user_id as uid
FROM page_view pv
UNION ALL
SELECT u.user_id as uid
FROM user u;
-- end not work

--this works
SELECT * FROM(
    SELECT pv.user_id as uid
    FROM page_view pv
    UNION ALL
    SELECT u.user_id as id
    FROM user u) tmp;
-- end
SELECT * FROM(
    SELECT pv.user_id as uid
    FROM page_view pv
    UNION ALL
    SELECT u.user_id as uid
    FROM user u) tmp;

