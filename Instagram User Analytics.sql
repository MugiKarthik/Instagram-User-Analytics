use ig_clone;

select * from users;
select * from photos;
select * from comments;
select * from likes;
select * from follows;
select * from tags;
select * from photo_tags;
select count(*) from photo_tags;

#Rewarding Most Loyal Users
select * from users
order by created_at
limit 5;

#Remind Inactive Users to Start Posting
with inactive_users as (
select user_id, count(user_id) as no_of_post from photos
group by user_id)

select * from users
left join inactive_users
on users.id=inactive_users.user_id
where no_of_post is null;

#Declaring Contest Winner
with mostliked_users as (
select photo_id, count(photo_id) as no_of_likes from likes
group by photo_id)

select * from photos
left join mostliked_users
on photos.id=mostliked_users.photo_id
order by no_of_likes desc
limit 1;

#Hashtag Researching
with mosttaged_users as(
select tag_id, count(tag_id) as no_of_tags from photo_tags
group by tag_id)

select * from tags
left join mosttaged_users
on tags.id=mosttaged_users.tag_id
order by no_of_tags desc
limit 5;

#Launch AD Campaign
SELECT DAYNAME(created_at) AS weekday_name, dayofweek(created_at)AS weekday_number, count(*) as no_of_most_register
FROM users
group by weekday_number,weekday_name
order by no_of_most_register desc;

select extract(hour FROM created_at) AS Hour, count(*) as no_of_register from users
group by Hour
order by no_of_register desc;

#User Engagement
select count(user_id) / (select count(distinct user_id) from photos) as average_posts_per_user
from photos;

select count(user_id)as total_photos from photos;

select count(distinct user_id) as total_no_of_users_posted from photos;

#Bots & Fake Accounts
with bot_account as (select user_id from likes
GROUP BY user_id
having COUNT(distinct photo_id) = (select COUNT(id) from photos))

select * from users
right join bot_account
on users.id=bot_account.user_id;

select user_id from likes
GROUP BY user_id
having COUNT(distinct photo_id) = (select COUNT(id) from photos);