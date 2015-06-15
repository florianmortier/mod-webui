%setdefault("search_string", "")
%setdefault("common_bookmarks", app.get_common_bookmarks())
%setdefault("user_bookmarks", app.get_user_bookmarks(user))

<form class="navbar-form navbar-left" method="get" action="all">
  <div class="dropdown form-group text-left">
    <button class="btn btn-default dropdown-toggle" type="button" id="filters_menu" data-toggle="dropdown" aria-expanded="true"><i class="fa fa-filter"></i><span class="hidden-xs hidden-sm"> Filters <span class="caret"></span></span></button>
    <ul class="dropdown-menu" role="menu" aria-labelledby="filters_menu">
      <li role="presentation"><a role="menuitem" tablindex="-1" href="?search=ack:true">Acknowledged</a></li>
      <li role="presentation"><a role="menuitem" tablindex="-1" href="?search=isnot:UP isnot:OK isnot:PENDING ack:false downtime:false">Problems</a></li>
      <li role="presentation"><a role="menuitem" tablindex="-1" href="#" data-toggle="modal" data-target="#searchSyntax"><strong><i class="fa fa-question-circle"></i> Search syntax</strong></a></li>
    </ul>
  </div>
  <div class="form-group">
    <label class="sr-only" for="search">Filter</label>
    <div class="input-group">
      <span class="input-group-addon"><i class="fa fa-search"></i></span>
      <!--:TODO:maethor:150609: Make the responsive-->
      <input class="form-control" type="search" id="search" name="search" value="{{ search_string }}">
    </div>
  </div>
  <div class="dropdown form-group text-left">
    <button class="btn btn-default dropdown-toggle" type="button" id="bookmarks_menu" data-toggle="dropdown" aria-expanded="true"><i class="fa fa-bookmark"></i><span class="hidden-xs hidden-sm"> Bookmarks <span class="caret"></span></span></button>
    <ul class="dropdown-menu dropdown-menu-right" role="menu" aria-labelledby="bookmarks_menu">
      <li role="presentation" class="dropdown-header">User bookmarks</li>
      %for b in user_bookmarks:
      <li role="presentation"><a role="menuitem" tablindex="-1" href="{{!b['uri']}}">{{!b['name']}}</a></li>
      %end
      <li role="presentation" class="dropdown-header">Global bookmarks</li>
      %for b in common_bookmarks:
      <li role="presentation"><a role="menuitem" tablindex="-1" href="{{!b['uri']}}">{{!b['name']}}</a></li>
      %end
      %if search_string:
      <li role="presentation" class="divider"></li>
      <li role="presentation"><a role="menuitem" tablindex="-1" href="#" data-toggle="modal" data-target="#newBookmark"><i class="fa fa-plus"></i> Bookmark the current filter</a></li>
      <li role="presentation"><a role="menuitem" tablindex="-1" href="#" data-toggle="modal" data-target="#manageBookmarks"><i class="fa fa-tags"></i> Manage bookmarks</a></li>
      %end
    </ul>
  </div>
</form>


<!-- DOCUMENTATION MODAL -->
<div class="modal fade" id="searchSyntax" tabindex="-1" role="dialog" aria-labelledby="Search syntax" aria-hidden=true>
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h3 class="modal-title">Searching hosts and services</h3>
      </div>

      <div class="modal-body">
        To search for services and hosts (elements), use the following search qualifiers in any combination.

        <h4>Search hosts or services</h4>
        <p>
          By default, searching for elements will return both hosts and services. However, you can use the type qualifier to restrict search results to hosts or services only.
        </p>
        <code>www type:host</code> Matches hosts with "www" in their hostname.

        <h4>Search by the state of an element</h4>
        <p>The <code>is</code> and <code>isnot</code> qualifiers finds elements by a certain state. For example:</p>
        <code>is:DOWN</code> Matches hosts that are DOWN.<br>
        <code>isnot:0</code> Matches services and hosts that are not OK or UP (all the problems). Equivalent to <code>isnot:OK isnot:UP</code><br>
        <code>load isnot:ok</code> Matches services with the word "load", in states warning, critical, unknown or pending.<br>

        <h4>Search by the business impact of an element</h4>
        <p>The <code>bp</code> qualifier finds elements by it's business priority. For example:</p>
        <code>bp:5</code> Matches hosts and services that are top for business.<br>
        <code>bp:>1</code> Matches hosts and services with a business impact greater than 1.<br>

        <h4>Search by host group, host tag and service tag</h4>
        Examples:
        <code>hg:infra</code> Matches hosts in the group "infra".<br>
        <code>htag:linux</code> Matches hosts tagged "linux".<br>
        <code>stag:mysql</code> Matches services tagged "mysql".<br>
        Obviously, you can't combine htag and stag qualifiers in a search and expect to get results.

        <h4>Find hosts and services by realm</h4>
        <p>The <code>realm</code> qualifier finds elements by a certain realm. For example:</p>
        <code>realm:aws</code> Matches all AWS hosts and services.
      </div>
    </div>
  </div>
</div>

<!-- NEW BOOKMARK MODAL -->
<div class="modal fade" id="newBookmark" tabindex="-1" role="dialog" aria-labelledby="New Bookmark" aria-hidden=true>
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h3 class="modal-title">New Bookmark</h3>
      </div>

      <div class="modal-body">
        <form role="form" name='bookmark_save' id='bookmark_save'>
          <div class="form-group">
            <label for="bookmark_name" class="control-label">Bookmark name</label>
            <input class="form-control input-sm" id="bookmark_name" name="bookmark_name" placeholder="..." aria-describedby="help_bookmark_name">
            <span id="help_bookmark_name" class="help-block">Use an identifier to create a bookmark referencing the current applied filters.</span>
          </div>
          <a class='btn btn-success' href='javascript:add_new_bookmark();'> <i class="fa fa-save"></i> Save</a>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- MANAGE BOOKMARKS MODAL -->
<div class="modal fade" id="manageBookmarks" tabindex="-1" role="dialog" aria-labelledby="Manage Bookmarks" aria-hidden=true>
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h3 class="modal-title">Manage Bookmarks</h3>
      </div>

      <div class="modal-body">
        <div id='bookmarks'></div>
        <div id='bookmarksro'></div>
      </div>
    </div>
  </div>
</div>
