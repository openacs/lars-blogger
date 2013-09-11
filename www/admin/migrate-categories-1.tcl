ad_page_contract {
    @author bdolicki@branimir.com
    @cvs-id $Id$
    Migrate Categories -- actual migration
} {
}

# Some formalities first

set package_id [ad_conn package_id]

set admin_p [permission::require_permission -object_id $package_id -privilege admin]

# Getting fancy - display progress bar

ad_progress_bar_begin \
    -title "[_ lars-blogger.lt_Migrating_categories_]" \
    -message_1 "[_ lars-blogger.lt_Migrating_categories__1]" \
    -message_2 "[_ lars-blogger.lt_It_might_be_a_good_id]"

# Migrate categories

db_transaction {
  set instance_name [lars_blog_name -package_id $package_id]
  ns_log Notice catmig
  ns_log Notice catmig ################### Starting category migration \
    of $instance_name $package_id ###############
  ns_log Notice catmig Creating new site wide tree
  set tree_id [category_tree::add \
    -name "[_ lars-blogger.lt_instance_name_Categor]" \
    -description "[_ lars-blogger.lt_This_category_tree_is]"]
  ns_log Notice catmig Done. tree_id = $tree_id
  category_tree::map \
    -tree_id $tree_id \
    -object_id $package_id

  ns_log Notice catmig Mapping done

  ns_log Notice catmig Getting list of categories

  set category_list [db_list_of_lists foo {
    select category_id, name
      from pinds_blog_categories
     where package_id = :package_id}]

  ns_log Notice catmig Got the list:
  ns_log Notice catmig $category_list
  ns_log Notice creating site wide category \"tree\"

  foreach rec $category_list {
    util_unlist $rec category_id name
    set sw_category_id [category::add \
      -tree_id $tree_id \
      -parent_id "" \
      -name $name]
    set oldtonew($category_id) $sw_category_id
    ns_log Notice catmig old category_id=$category_id,\
      new sw_category_id=$sw_category_id
  }

  set oldcat_entry_list [db_list_of_lists foo {
    select category_id, entry_id
      from pinds_blog_entries
     where package_id = :package_id
       and category_id is not null}]

  ns_log Notice catmig $oldcat_entry_list

  set count 0
  foreach rec $oldcat_entry_list {
    util_unlist $rec category_id entry_id
    ns_log Notice catmig $oldtonew($category_id)
    # This -remove_old thing is something you may want to customize for
    # your site.  It will remove all current site-wide categorizations
    # of this item.
    #category::map_object -remove_old -object_id $entry_id $oldtonew($category_id)
    category::map_object -object_id $entry_id $oldtonew($category_id)
    incr count
  }

}

# Done

ad_progress_bar_end -url .. -message_after_redirect \
  "[_ lars-blogger.lt_Category_migration_fi]"
