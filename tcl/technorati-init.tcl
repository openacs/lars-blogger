# Schedule a job that fetches Technorati for all weblogs
ad_schedule_proc \
    -thread t \
    1200 lars_blogger::technorati::scheduled_job