<h1>Housekeeping email template...</h1>

<h2>The following ${packagesInLastWeek.size()} packages have been added in the past week</h2>
<table>
  <thead>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Date Added</th>
      <th>Last Updated</th>
    </tr>
  <thead>
  <tbody>
    <% packagesInLastWeek.each { pkg -> %>
      <tr>
        <td>$pkg.id</td>
        <td><a href="http://package/URL">$pkg.name<a></td>
        <td>$pkg.dateCreated</td>
        <td>$pkg.lastUpdated</td>
      </tr>
    <% } %>
  </tbody>
</table>

<h2>Duplicate Org Processing</h2>

<% duplicateOrgs.each { k,v -> %>

  <h3>$k</h3>
  <table>
    <thead>
      <tr><th>Org ID</th><th>Name</th></tr>
    </thead>
    <tbody>
      <% v.each { dup_org -> %>
        <tr><td>${dup_org.id}</td><td>${dup_org.name}</td></tr>
      <% } %>
    </tbody>
  </table>

<% } %>

<h2>Duplicate Identifier Processing</h2>

<% identifiers.withinNS.each { k,v -> %>
  <h3>$v.message</h3>
   <table>
     <% v.details.each { dup_id -> %>
       <tr>
         <td>
           Identifier : $dup_id.identifier_value<br/>
           First Occurrence : $dup_id.first.id<br/>
           Duplicates : <ul><% $dup_id.duplicates.each { dup -> %>
             <li>$dup.id</li>
           <% } %></ul>
         
         </td>
         <td>
           Titles affected:
           <ul>
             <% dup_id.titles.each { t -> %>
               <li>KBPlus ID:$t.id - Title:$t.title</li>
             <% } %>
           </ul>
         </td>
       </tr>
     <% } %>
  </table>
<% } %>

<h2>Floating Identifiers Deleted</h2>
<table>
  <% floatingIdentifiers.each { i -> %>
    <tr>
      <td>$i.ns.ns $i.value</td>
    </tr>
  <% } %>
</table>

<h2>Titles with multiple identifiers in a single namespace</h2>
<table>
  <tr>
    <th>Title#</th>
    <th>Name</th>
    <th>Namespace</th>
    <th># Items in NS</th>
  </tr>
  <% titlesWithMultipleIdsInSingleNS.each { i -> %>
    <tr>
      <td>${i[0].id}</td>
      <td>${i[0].title}</td>
      <td>${i[1].ns}</td>
      <td>${i[2]}</td>
    </tr>
  <% } %>
</table>

<h2>Orgs with multiple identifiers in a single namespace</h2>
<table>
  <tr>
    <th>Org#</th>
    <th>Name</th>
    <th>Namespace</th>
    <th># Items in NS</th>
  </tr>
  <% orgsWithMultipleIdsInSingleNS.each { i -> %>
    <tr>
      <td>${i[0].id}</td>
      <td>${i[0].name}</td>
      <td>${i[1].ns}</td>
      <td>${i[2]}</td>
    </tr>
  <% } %>
</table>

<h2>Identifiers linked to more than one item</h2>
<table>
  <tr>
    <th>Identifier#</th>
    <th>Value</th>
    <th># Items Linked</th>
  </tr>
  <% identifiersLinkedToMultipleItems.each { i -> %>
    <tr>
      <td>${i[0].id}</td>
      <td>${i[0].ns.ns}:${i[0].value} <br/>
        <ul>
          <% i[0].occurrences.each { o -> %><li>
            <% if ( o.ti ) { %>Title [${o.ti.id}]: ${o.ti.title} <% } %>
            <% if ( o.tipp ) { %> TIPP [${o.tipp.id}]<% } %>
            <% if ( o.org ) { %> Org [${o.org.id}] ${o.org.name} <% } %>
            <% if ( o.pkg ) { %> Package [${o.pkg.id}] ${o.pkg.name} <% } %>
            <% if ( o.sub ) { %> Subscription [${o.sub.id}] ${o.sub.name} <% } %>
          </li><% } %>
        </ul>
      </td>
      <td>${i[1]}</td>
    <tr>
  <% } %>
</table>

<h2>Duplicated TIPPs </h2>
<table>
  <tr>
    <th>Package#</th>
    <th>Package</th>
    <th>Title#</th>
    <th>Title</th>
    <th>Platform#</th>
    <th>Platform</th>
    <th>Num duplicates</th>
  </tr>
<% multipleTipps.each { t -> %>
  <tr>
    <td>${t[1].id}</td>
    <td>${t[1].name}</td>
    <td>${t[0].id}</td>
    <td>${t[0].title}</td>
    <td>${t[2].id}</td>
    <td>${t[2].name}</td>
    <td>${t[3]}</td>
  </tr>
<% } %>
</table>

<h2>ISxN Family Duplicates</h2>
<table>
  <tr>
    <th>Value#</th>
    <th>Num duplicates</th>
  </tr>
<% isxnFamilyDuplicates.each { t -> %>
  <tr>
    <td>${t[0]}</td>
    <td>${t[1]}</td>
  </tr>
<% } %>
