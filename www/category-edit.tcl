ad_page_contract {} {
    {category_id:integer ""}
    {return_url ""}
    {name:allhtml ""}
    {short_name:allhtml ""}
}

# Must be logged in
ad_maybe_redirect_for_registration

# Must have write privilege
permission::require_permission -object_id [ad_conn package_id] -privilege write

set package_id [ad_conn package_id]

if { [lars_blog_categories_p -package_id $package_id] != 1} {
    ad_return_error "No category support" "Categories are not supported. Modify the package parameters to add support."
    return
}

db_multirow categories categories { *SQL* }

if { [string length $return_url]==0 } {
    set return_url category-edit
}

form create category -cancel_url [ad_decode $return_url "" "." $return_url]

element create category name -label "Category" -datatype text -html { size 50 }

element create category short_name \
    -label "Category Short Name" \
    -datatype text \
    -html { size 20 } \
    -optional \
    -help_text "This is used to provide a pretty URL for viewing postings in this category"

element create category category_id -widget hidden -datatype text
element create category return_url -widget hidden -datatype text -value $return_url

if { [form is_request category] } {

    if { [empty_string_p $category_id] } {
        set insert_or_update insert
        set category_id [db_nextval "acs_object_id_seq"]

        # Prefill title and content with supplied values
        foreach element { name short_name } {
            if { [exists_and_not_null $element] } {
                element set_value entry $element [set $element]
            }
        }
    } else {
        set insert_or_update update
        db_1row category { *SQL* }
        
        element set_value category name $name
        element set_value category short_name $short_name
    }

    element set_properties category category_id -value $category_id
}


if { [form is_valid category] } {
    set category_id [element get_value category category_id]
    set name [element get_value category name]
    set short_name [element get_value category short_name]

    set return_url [element get_value category return_url]

    if { [string length $short_name]==0 } {
        set existing_short_names [db_list short_names {}]
	set short_name [util_text_to_url -existing_urls $existing_short_names -text $name]
    } else {
	db_1row short_name_exists { *SQL* }
	if { $short_name_exists > 0 } {
	    ad_return_error "Category short name exists" "The specified Category Short Name is already being used &minus; please select another one."
	    return
	}
    }
    

    db_1row category_exists { *SQL* }
    if { $category_exists == 0 } {
        set insert_or_update insert
        set creation_user [ad_conn user_id]
        set creation_ip [ns_conn peeraddr]
        db_exec_plsql insert_category { *SQL* }
    } else {
        set insert_or_update update
        db_dml update_category { *SQL* }
    }
    
    if { [empty_string_p $return_url] } {
        set return_url "[ad_conn package_url]admin"
    }

    ad_returnredirect $return_url
    ad_script_abort
} 

if { ![form is_request category] && ![form is_valid category] } {
    set insert_or_update [element get_value category insert_or_update]
}

switch -- $insert_or_update {
    insert {
        set page_title "Add Blog Category"
    }
    update {
        set page_title "Edit Blog Category"
    }
}

set context [list $page_title]
