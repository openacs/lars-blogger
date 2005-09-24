ad_page_contract {
    Generate a bookmarlet for posting on the blog quickly.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-13
}

set package_id [ad_conn package_id]
set entry_edit_url "[ad_url][lars_blog_public_package_url]entry-edit"

set blog_name [lars_blog_name]
set context [list "[_ lars-blogger.Bookmarklet]"]

set bookmarklet_link "javascript:d=document;w=window;t='';if(d.selection){t=d.selection.createRange().text}else%20if(d.getSelection){t=d.getSelection()}else%20if(w.getSelection){t=w.getSelection()}void(w.open('$entry_edit_url?title='+escape(d.title)+'&title_url='+escape(d.location.href)+'&content='+escape(t),'_blank','scrollbars=yes,width=500,height=575,status=yes,resizable=yes,scrollbars=yes'))"
