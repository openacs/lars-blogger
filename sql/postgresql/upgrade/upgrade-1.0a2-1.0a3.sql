-- this had select title into v_name but title did not exist 
-- 
create or replace function pinds_blog_category__name (integer)
returns varchar as '
declare
    p_category_id     alias for $1;
    v_name            varchar;
begin
    select name into v_name
        from pinds_blog_categories
        where category_id = p_category_id;
    return v_name;
end;
' language 'plpgsql';
