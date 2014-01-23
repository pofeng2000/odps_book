--window function
SELECT *
FROM
(SELECT user_id, age, gender, 
    rank() over (partition by 1 order by age) as rk
From user
) t
WHERE t.rk <=10; 

--this will not work
SELECT user_id, age, gender, 
    rank() over (partition by 1 order by age) as rk
From user
WHERE rk <=10; 
-- end not work

