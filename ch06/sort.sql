-- sort
SELECT pv.*
FROM page_view pv
ORDER BY pv.user_id desc 
Limit 10;

SELECT pv.*
FROM page_view pv
DISTRIBUTE BY pv.user_id 
SORT BY pv.user_id, pv.view_time desc;

SELECT pv.*
FROM page_view pv
CLUSTER BY pv.user_id, pv.view_time;

