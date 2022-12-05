<!doctype html>
<html>
	<head>
		<title>Grails Runtime Exception</title>
		<meta name="layout" content="main">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'errors.css')}" type="text/css">
	</head>
	<body>
    <g:if test="${Throwable.isInstance(exception)}">
      <g:renderException exception="${exception}" />
    </g:if>
    <g:elseif test="${request.getAttribute('javax.servlet.error.exception')}">
      <g:renderException exception="${request.getAttribute('javax.servlet.error.exception')}" />
    </g:elseif>
    <g:else>
      <ul class="errors">
        <li>An error has occurred</li>
        <li>Exception: ${exception}</li>
        <li>Message: ${message}</li>
        <li>Path: ${path}</li>
      </ul>
    </g:else>
  </body>

</html>
