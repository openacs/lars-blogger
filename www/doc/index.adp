
<property name="context">{/doc/lars-blogger {Weblogger}} {Weblogger Documentation}</property>
<property name="doc(title)">Weblogger Documentation</property>
<master>

<body>
<h2>Weblogger Documentation</h2>
By <a href="http://www.pinds.com/lars/">Lars Pind</a> and <a href="http://bcuni.net">Simon Carstensen</a><h3>Download</h3><p>The blogger now lives in the <a href="http://openacs.org">OpenACS</a> cvs repository.</p><h3>Getting started</h3><p>Install the package on your system, mount a new instance
somewhere on the site map, make sure you have create permission on
the instance, and then visit the URL where you mounted it. Now you
can add your first blog entry.</p><h3>Syndicating a blog (putting it on your front page)</h3><p>If you want to include a blog as part of another page, that's
pretty simple.</p><p>If you're including in an ADP, say:</p><blockquote><pre>
&lt;include src="/packages/lars-blogger/www/blog" url="/blog"&gt;
</pre></blockquote><p>... for the non-cached version, and ...</p><blockquote><pre>
&lt;%=[lars_blog_get_as_string -url "/blog"]%&gt;
</pre></blockquote><p>... for the cached version. There shouldn't be any problems
using the cached version, as the cache should be flushed whenever
anything changes.</p><p>From a Tcl page:</p><blockquote><pre>
set blog_html [template::adp_parse "[acs_package_root_dir "lars-blogger"]/www/blog" [list url "/blog"]]
</pre></blockquote><p>... for the non-cached version, and ...</p><blockquote><pre>
[lars_blog_get_as_string -url "/blog"]
</pre></blockquote><p>... for the cached version.</p><p>All of these are shown with an argument 'url' here, but they all
take a package_id argument instead, if you prefer that and know
what the package_id is. If nothing's supplied, the current package
is used, which is generally not what you want.</p><h3>Technical Info</h3><p>The package fully supports multiple instances. You can mount
several instances in your site map, and they'll stay properly
isolated from each other. Alternatively you can let multiple users
post to one instance by granting create permissions. Mounting
Weblogger under, say, /blog, you will have /blog/user/screenname
displaying the entries of one user and /blog displaying either a
list of all bloggers (this is done by setting the parameter
DisplayUsersP to 1) or all entries posted to the instance (the
default).</p><p>Contents in your blog entries are assumed to be full-blooded
ADP-ified HTML, so don't give people access to post a blog (i.e.
grant create permissions on the instance) unless you trust them.
This also means that if you've added custom ADP tags, those are
also available to you in your blog.</p><h3>Permissions</h3><ul>
<li>'read' means people can read entries.</li><li>'create' means people can create entries and
edit/publish/draft/delete their own entries.</li><li>'write' means people can edit/draft/publish/delete all entries
in the package instance.</li><li>'admin' means people can define categories, etc.</li>
</ul><h3>weblogs.com update ping</h3><p>There are a couple parameters governing this feature. You can
turn it on or off on a per-package basis. And you can specify which
URL you want to export to weblogs.com, in case it's not the one the
package instance is mounted at. This can be useful if you're
including the blog on other pages, for example your site's front
page. Thanks to Jerry Asher for the code to do this.</p><h3>RSS Feed</h3><p>The RSS feed is version 1.0 only, and uses the rss-support
package. You should be able to simply visit the admin page of your
new blogger instance and click the "Setup RSS" link, and you'll
have an RSS feed.</p><p>Then you'll need to set the parameters and say that your
rss_file_name is at /where-your-blogger-instnace-sists/rss/rss.xml.
If you leave this blank, we won't advertise your RSS feed URL
anywhere.</p><p>You can also supply your own channel image through the
parameters.</p><h3>XML-RPC APIs</h3><p>The Blogger and MetaWeblog APIs are supported. An <a href="http://archipelago.phrasewise.com/rsd">RSD</a> link is placed on
your Blog's front page, allowing XML-RPC client tools to
automatically discover which API's they can use. See the <a href="/doc/xml-rpc">XML-RPC package documentation</a> for more details.
Disable the XML-RPC server to disallow access to your blog via
XML-RPC.</p><h3>Posting From News Aggregator via URL</h3><p>Some news aggregators can blog items you read via simply sending
you to the proper URL. Here's what you need to specify in <a href="http://www.bradsoft.com/feeddemon/index.asp">FeedDemon</a> to make
Blog-this-item work there:</p><pre>
<i>URL-of-your-blog</i>/entry-edit?title=$ITEM_TITLE$&amp;title_url=$ITEM_LINK$&amp;content=$ITEM_DESCRIPTION$
</pre><h3>Road Map</h3><ul>
<li>Full-text-search-index blog entries so the archives are more
useful.</li><li>Use new categories package for categorization</li><li>Use content repository.</li><li>Ability to modify templates for each instance and user
individually through the UI.</li><li>WYISIYG editor</li><li>Improved RSS 2.0 feed stuff</li><li>Improved Configuration Settings.</li><li>Technorati</li><li>Blogroll.</li><li>Integrate with bookshelf, photo-album in a portal</li><li>Make it safe to use in a not-so-protected environment, e.g.,
disable &lt;% ... %&gt; ADP notation.</li><li>Better documentation.</li><li>Moderation-feature: Entries posted by non-admins must go
through a workflow-administered approval process.</li><li>Nicer interface (MovableType/TypePad has a nice interface)</li>
</ul><h3>Version History</h3><ul>
<li>
<b>1.0</b> Added support for categories, cleaned up permissions
handling, styled with stylesheets, trackback support.</li><li>
<b>0.9.2</b> Added parameters to control the number of entries
shown on the front page (July 10, 2003)</li><li>
<b>0.9</b> Added support for multiple users. (June 10,
2003)</li><li>
<b>0.8.7</b> Fixed notifications to include the title_url, and
to not have extra spaces in the month name. (May 11, 2003)</li><li>
<b>0.8.6</b> Cleaned up RSS-support even more and made it work
under Oracle. Also made a slight style change, using the
&amp;raquo; (») style for action links, which I've adopted
for other packages. It's less intrusive than the harshly-colored
arrow-box.gif I used to use. (May 9, 2003)</li><li>
<b>0.8.5</b> Added title URL, cleanup (March 28, 2003)</li><li>
<b>0.8.4</b> Oops, getting behind on the version history. In
the last few releases, I've rearranged a bunch of templates to make
it more consistent and easier to customize; I've fixed the code
that sets up the RSS stuff, so you can now simply go to the admin
page and say "setup RSS"; I've integrated the new richtext widget
which I added to the templating system. (February 6, 2003)</li><li>
<b>0.7d</b> Finished port to Oracle. Upgraded PG drop script.
Renamed RSS proc which requires running the SQL upgrade script (for
PG). Bug-fix to bypass 'draft' and publish directly. -vinodk
(August 15, 2002)</li><li>
<b>0.6.4d</b> Added poster information, optional per parameter.
Added "url" shortcut variable to the blog template. Updated
documentation. (July 23, 2002)</li><li>
<b>0.6.3d</b> Added drop scripts, and made the create script
call rss-register. Fixed minor bugs. (July 22, 2002)</li><li>
<b>0.6.1d</b> Fixed RSS last update bug. (Jun 2, 2002)</li><li>
<b>0.6d</b> Added RSS feed. Woohoo! (June 1, 2002)</li><li>
<b>0.5d</b> Added weblogs.com update ping. (June 1, 2002)</li><li>
<b>0.4d</b> Added Google link, new style. (May 31, 2002)</li><li>
<b>0.3.3d</b> Added Peter Marklund's arrow-box.gif patch. (May
13, 2002)</li><li>
<b>0.3.2d</b> Missing files from the distribution.</li><li>
<b>0.3d</b> Improved admin interface, added documentation.
(March 24, 2002)</li><li>
<b>0.2d</b> Allow and show comments on blog. (March 23,
2002)</li><li>
<b>0.1d</b> Initial version. (February 18, 2002)</li>
</ul><h3>License</h3>
Released under the <a href="http://www.gnu.org/licenses/gpl.txt">GPL</a>.
<hr><address><a href="mailto:lars\@pinds.com">lars\@pinds.com</a></address>
</body>
