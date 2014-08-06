ad_page_contract {} {
    entry_id:naturalnum,notnull
    {return_url "."}
}

ad_form -name confirmation \
    -cancel_url $return_url \
    -form {
	{entry_id:text(hidden)
	    {value $entry_id}
	}
    } -on_submit {
	lars_blogger::entry::delete -entry_id $entry_id
    } -after_submit {
	ad_returnredirect $return_url
	ad_script_abort
    } \
    -export {return_url}

set page_title "[_ lars-blogger.Confirm_Delete]"
set context [list $page_title]

ad_return_template



