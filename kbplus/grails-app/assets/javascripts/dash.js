/**
 * 
 */

/*
IAN: Commented this out - it's not trivially easy to control the order of js includes.
This file was being included before application.js, which causes JQuery to be loaded.
Therefore, the call to $ in this file causes the whole app to blow up. Either the app needs to be
restructured so that the root page does not include application.js and then individual page js 
files make sure they use the /== require directive for the dependencies, or this file can only have
functions that will be called after the page has loaded.

$(document).ready(function() {
});
*/
