SELECT pv_users.gender, count (DISTINCT pv_users.user_id)
FROM pv_users
GROUP BY pv_users.gender;

SELECT pv_users.gender, count (DISTINCT pv_users.user_id) as count
FROM pv_users
GROUP BY pv_users.gender;

SELECT pv_users.gender, 
       count(DISTINCT pv_users.user_id) as user_count,
       count(DISTINCT pv_users.ip)
FROM pv_users
GROUP BY pv_users.gender;

-- this will not work
SELECT pv_users.gender, count (DISTINCT pv_users.user_id) as count, pv_users.ip as count
FROM pv_users
GROUP BY pv_users.gender;
-- end

CREATE TABLE pv_gender_sum (
    gender BIGINT,
    cnt BIGINT);
CREATE TABLE pv_age_sum (
    age BIGINT,
    cnt BIGINT);
FROM pv_users
INSERT OVERWRITE TABLE pv_gender_sum
    SELECT pv_users.gender, count(distinct pv_users.user_id)
    GROUP BY pv_users.gender
INSERT INTO TABLE pv_age_sum
    SELECT pv_users.age, count(distinct pv_users.user_id)
    GROUP BY pv_users.age;

