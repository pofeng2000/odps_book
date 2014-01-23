-- a simple example
create table t1(id bigint, name string);
create table t2(id bigint, score bigint);
insert into table t1 select 1, "a1" from (select count(*) from t1)a;
insert into table t1 select 2, "b1" from (select count(*) from t1)a;
insert into table t2 select 1, 80 from (select count(*) from t1)a;
insert into table t2 select 3, 90 from (select count(*) from t1)a;

SELECT t1.*, t2.score FROM t1 JOIN t2 ON (t1.id = t2.id); 
SELECT t1.*, t2.score FROM t1 LEFT OUTER JOIN t2 ON (t1.id = t2.id); 
SELECT t1.*, t2.score FROM t1 RIGHT OUTER JOIN t2 ON (t1.id = t2.id); 
SELECT t2.id, t1.name, t2.score FROM t1 RIGHT OUTER JOIN t2 ON (t1.id = t2.id); 
SELECT t1.*, t2.score FROM t1 FULL OUTER JOIN t2 ON (t1.id = t2.id); 
-- end simple example

CREATE TABLE friend_list(
    uid bigint,
    friends string);

CREATE TABLE pv_friends(
    user_id BIGINT,
    view_time BIGINT,
    page_url STRING, 
    referrer_url STRING,
    ip STRING COMMENT 'IP Address of the User',
    gender BIGINT COMMENT '0 Unknown, 1 Male, 2 Female',
    age BIGINT,
    friends STRING);

INSERT OVERWRITE TABLE pv_friends
SELECT pv.user_id, pv.view_time, pv.page_url, pv.referrer_url, pv.ip, 
       u.gender, u.age, f.friends
FROM user u JOIN page_view pv ON (pv.user_id = u.user_id) 
        JOIN friend_list f ON(u.user_id = f.uid)
WHERE pv.dt = '2011-12-17';

-- MapJoin
SELECT /*+ MAPJOIN(u) */
    u.user_id, u.gender, u.age,
    pv.view_time, pv.page_url, pv.referrer_url, pv.ip
FROM user u JOIN page_view pv
ON u.user_id = pv.user_id;


