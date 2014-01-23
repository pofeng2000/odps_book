-- 1. basic DDL Opeartions
CREATE TABLE page_view(
    user_id BIGINT,
    view_time BIGINT,
    page_url STRING, 
    referrer_url STRING,
    ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the page view table'
PARTITIONED BY(dt STRING, country STRING);


CREATE TABLE page_view_test LIKE page_view;

CREATE TABLE page_view_url AS
    SELECT page_url, referrer_url FROM page_view;

CREATE TABLE user(
    user_id BIGINT,
    gender BIGINT COMMENT '0 Unknown, 1 Male, 2 Female',
    age BIGINT,
    active BIGINT);

ALTER TABLE user ADD COLUMNS(info STRING);
ALTER TABLE user CHANGE COLUMN active active BIGINT COMMENT '0 Unknown, 1 Active, 2 Not-active';


ALTER TABLE page_view ADD PARTITION (dt='2011-12-17',country='US');
ALTER TABLE page_view ADD PARTITION (dt='2011-12-17',country='China');
ALTER TABLE page_view ADD IF NOT EXISTS PARTITION (dt='2011-12-17',country='US');

ALTER TABLE page_view DROP PARTITION(dt='201301111',country='US');

SHOW TABLES;
SHOW TABLES 'page.*';
SHOW PARTITIONS page_view;
DESCRIBE page_view;
DESC page_view;

-- this is forbiden
-- DESC EXTENDED page_view;

-- 2. DML Operations
-- generate data
--      123 1386213971  http://www.tmall.com    http://www.taobao.com/  192.91.189.6
--      798 1387213003  http://www.tmall.com    http://www.taobao.com/  112.92.142.7

INSERT INTO TABLE page_view PARTITION(dt='2011-12-17', country='US') 
SELECT 123, 1386213971, "http://www.tmall.com", "http://www.taobao.com/", "192.91.189.6" 
FROM (SELECT count(*) FROM user)a;

insert into table page_view partition(dt='2011-12-17', country='China') 
select 798, 1387213003, "http://www.tmall.com", "http://www.taobao.com/", "112.92.142.7" 
from (select count(*) from user)a;

insert into table user select 798, 2, 30, 1, "test2" from (select count(*) from user)a;

INSERT INTO TABLE user 
SELECT 123, 1, 15, 1, "test1" 
FROM (SELECT count(*) FROM user)a;

SELECT user.*
FROM user
WHERE user.active=1;

CREATE TABLE user_active LIKE user;
INSERT OVERWRITE TABLE user_active
SELECT user.*
FROM user
WHERE user.active=1;

CREATE TABLE IF NOT EXISTS user_active AS
    SELECT user.*
    FROM user
    WHERE user.active=1;

CREATE TABLE taobao_com_page_view LIKE page_view;
--ALTER TABLE taobao_com_page_view ADD PARTITION (dt='2011-12-17', country='China');
INSERT OVERWRITE TABLE taobao_com_page_view PARTITION(dt,country)
SELECT page_view.*
FROM page_view
WHERE page_view.dt='2011-12-17' AND
      page_view.referrer_url LIKE '%taobao.com/';

-- partitioned based search
SELECT page_view.*
FROM page_view
WHERE page_view.dt='2011-12-17' AND
      page_view.referrer_url LIKE '%taobao.com/';

CREATE TABLE from_taobao_no_partition(
    user_id BIGINT,
    view_time BIGINT,
    page_url STRING, 
    referrer_url STRING,
    ip STRING); 

CREATE TABLE from_taobao_with_partition LIKE page_view;

-- this will not work
INSERT OVERWRITE TABLE from_taobao_no_partition
SELECT page_view.*
FROM page_view
WHERE page_view.dt='2011-12-17' AND
      page_view.referrer_url LIKE '%taobao.com/';
-- end

-- this works
INSERT OVERWRITE TABLE from_taobao_no_partition
SELECT pv.user_id, pv.view_time, pv.page_url, pv.referrer_url, pv.ip
FROM page_view pv
WHERE pv.dt='2011-12-17' AND 
      pv.referrer_url LIKE '%taobao.com/';

INSERT OVERWRITE TABLE from_taobao_with_partition 
       PARTITION(dt='2011-12-17',country='US')
SELECT pv.user_id, pv.view_time, pv.page_url, pv.referrer_url, pv.ip
FROM page_view pv
WHERE pv.dt='2011-12-17' AND pv.country='US' AND
      pv.referrer_url LIKE '%taobao.com/';
INSERT OVERWRITE TABLE from_taobao_with_partition 
       PARTITION(dt='2011-12-17',country='China')
SELECT pv.user_id, pv.view_time, pv.page_url, pv.referrer_url, pv.ip
FROM page_view pv
WHERE pv.dt='2011-12-17' AND pv.country='China' AND
      pv.referrer_url LIKE '%taobao.com/';


INSERT OVERWRITE TABLE taobao_com_page_view PARTITION(dt='2011-12-17',country='US')
SELECT page_view.user_id, page_view.view_time, page_view.page_url, page_view.referrer_url, page_view.ip
FROM page_view
WHERE page_view.dt='2011-12-17' AND country='US' AND
      page_view.referrer_url LIKE '%taobao.com/';

INSERT OVERWRITE TABLE taobao_com_page_view PARTITION(dt='2011-12-17',country='China')
SELECT page_view.user_id, page_view.view_time, page_view.page_url, page_view.referrer_url, page_view.ip
FROM page_view
WHERE page_view.dt='2011-12-17' AND country='China' AND
      page_view.referrer_url LIKE '%taobao.com/';

CREATE TABLE pv_users(
    user_id BIGINT,
    view_time BIGINT,
    page_url STRING, 
    referrer_url STRING,
    ip STRING COMMENT 'IP Address of the User',
    gender BIGINT COMMENT '0 Unknown, 1 Male, 2 Female',
    age BIGINT)
PARTITIONED BY(dt STRING, country STRING);

INSERT OVERWRITE TABLE pv_users PARTITION(dt,country)
SELECT pv.user_id, pv.view_time, pv.page_url, pv.referrer_url, pv.ip, u.gender, u.age, pv.dt, pv.country
FROM user u JOIN page_view pv ON (pv.user_id = u.user_id)
WHERE pv.dt = '2011-12-17';

