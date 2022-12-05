<div class="container home-page">
            <table class="table">
              <g:each in="${recentAnnouncements}" var="ra">
                <tr>
                  <td><strong>${ra.title}</strong> <br/>
                  ${ra.content} <span class="pull-right">posted by <em><g:link controller="userDetails" action="pub" id="${ra.user?.id}">${ra.user?.displayName}</g:link></em> on <g:formatDate date="${ra.dateCreated}" format="yyyy-MM-dd hh:mm a"/></span></td>
                </tr>
              </g:each>
            </table>

      <div class="pagination" style="text-align:center">
        <g:if test="${recentAnnouncements!=null}" >
          <bootstrap:paginate  action="announcements" controller="myInstitutions" params="${params}" next="Next" prev="Prev" maxsteps="10" total="${num_announcements}" />
        </g:if>
      </div>


</div>
