
-- case when
SELECT u.user_id, 
    CASE
    WHEN u.gender=1 THEN 'male'
    WHEN u.gender=2 THEN 'female'
    ELSE "unknown"
    END AS gender
FROM user u;


