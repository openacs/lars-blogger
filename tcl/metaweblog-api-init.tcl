# /packages/lars-blogger/tcl/metaweblog-api-init.tcl
ad_library {
    Register MetaWeblog API procs

    @author Vinod Kurup [vinod@kurup.com]
    @creation-date Sun Oct  5 23:13:45 2003
    @cvs-id $Id$
}

xmlrpc::register_proc metaWeblog.newPost
xmlrpc::register_proc metaWeblog.editPost
xmlrpc::register_proc metaWeblog.getPost
xmlrpc::register_proc metaWeblog.getRecentPosts
