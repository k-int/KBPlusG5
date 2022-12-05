var customcss = 'undefined';
var variables ='site=QPlZQ&width=100%25&inverse=FALSE&row=TRUE&responsive=TRUE&display=1-1&website=http%3A%2F%2Fkbplus.ac.uk%2Fkbplus%2F&innercss=&outercss='
/*jslint browser:true */
/*global data, variables, css, console, customcss */

//Wrapper object for banner JS

var jiscbanner = {};
    
jiscbanner.main = function () {
    
    "use strict";
    
    if (!window.postMessage) {
        
        return false;
        
    }
    
    //Check if variables are defined, if not set them as the default
    
    if (variables !== 'undefined') {
        
        //Assign passed through variables
        
        jiscbanner.rawvariables = variables;
    
    } else {
     
        jiscbanner.rawvariables = "&row=FALSE&inverse=FALSE&width=100%";
        
    }
    
    jiscbanner.variablearray = jiscbanner.rawvariables.split("&");

    var i,
        eventMethod = window.addEventListener ? "addEventListener" : "attachEvent",
        eventer = window[eventMethod],
        messageEvent = eventMethod === "attachEvent" ? "onmessage" : "message";
    
    // Object for processed variables
    
    jiscbanner.variables = {};
    
    for (i = 1; i < jiscbanner.variablearray.length; i += 1) {
     
        jiscbanner.variables[jiscbanner.variablearray[i].split("=")[0]] = jiscbanner.variablearray[i].split("=")[1];
        
    }
    
    //Function for removing elements
    
    var removelement = function(el) {
el.parentNode.removeChild(el);
    }
    
    //Inverse version of placeholder
    
    if(document.getElementById("banner")){
       
       removelement(document.getElementById("banner"));
        removelement(document.getElementById("banner_placeholder"));
    
       
    };
    
    
    //Add placeholder to be removed later
    
    //Inverse version of placeholder
    
    if (jiscbanner.variables.row === "TRUE" && jiscbanner.variables.inverse === "TRUE") {
            
        document.body.insertAdjacentHTML("afterBegin", "<div id='banner_placeholder' style='height:25px; position:relative; width:100%; background-color:#0c2931;'></div>");
            
    } else if (jiscbanner.variables.row === "TRUE") {
            
    //Default version of row placeholder
            
        document.body.insertAdjacentHTML("afterBegin", "<div id='banner_placeholder' style='height:25px; position:relative; width:100%; background-color:#e4e9ec;'></div>");
            
    }
    
    //Add control if tab frame
    
    if (jiscbanner.variables.row === "FALSE") {
        
        if (jiscbanner.variables.inverse === "TRUE") {
            
            jiscbanner.tabimage = "tab-inverse.png";
            
        } else {
            
            jiscbanner.tabimage = "tab-default.png";
            
        }
        
        document.body.insertAdjacentHTML("afterBegin", "<div id='bannertabcontainer' style='width:" + jiscbanner.variables.width + "; margin:auto;'><div id='jiscbannertab' style='position:relative; top:32px; z-index:99999999; display:block; height:43px; width:143px; background-position: 0 -93px; margin-bottom:-100px; margin-top:-33px; float:right; cursor:pointer; color:transparent; background-image:url(https://uwp-jb.jisc.ac.uk/" + jiscbanner.tabimage + ");' onclick=jiscbanner.toggletab()>Banner tab</div></div>");
        
        //document.getElementById("jiscbannertab").style.left = "960px";
        
    }
    
    //Add frame
    
    document.body.insertAdjacentHTML("afterBegin", "<iframe title='Jisc masthead' id='banner' frameborder='0' style='overflow:hidden; transition: margin-top 200ms; display:block; position:relative; margin-top:0px; z-index:99999; position:absolute; margin-left:-99999px; height:0px; width:100%' src=https://uwp-jb.jisc.ac.uk/frame.html?" + jiscbanner.rawvariables + "></iframe>");
    
    
    jiscbanner.bannerframe = document.getElementById("banner");


    // Listen to message from child window
    eventer(messageEvent, function (e) {

        //If message contains the height set the height variable locally

        if (e.data.indexOf("HEIGHT") !== -1) {

            jiscbanner.bannerheight = parseInt(e.data.replace("HEIGHT=", ""), 10);
            jiscbanner.rowbannerheight = jiscbanner.bannerheight + 25;

            // Row height
            
            if (jiscbanner.variables.row === "TRUE") {
                
                jiscbanner.bannerframe.style.height = jiscbanner.rowbannerheight + "px";
                jiscbanner.bannerframe.style.marginTop = "-" + jiscbanner.bannerheight + "px";
                
                window.setTimeout(function () {
                    jiscbanner.bannerframe.style.marginLeft = "0px";
                    jiscbanner.bannerframe.style.position = "relative";
                    document.getElementById("banner_placeholder").style.display = "none";
                    
                }, 300);

            // Tab height
                
            } else {
                
                jiscbanner.bannerframe.style.height = jiscbanner.bannerheight + "px";
                
                //Offset for tab border
                
                jiscbanner.tabmargin = jiscbanner.bannerheight - 4;
                
                jiscbanner.bannerframe.style.marginTop = "-" + jiscbanner.tabmargin + "px";
                
                
            }
        }

        // If message is an open banner message (this applies to the row version)

        if (e.data === "OPEN") {

            jiscbanner.bannerframe.style.marginTop = "0px";

        }

        if (e.data === "CLOSE") {

            jiscbanner.bannerframe.style.marginTop = "-" + jiscbanner.bannerheight + "px";

        }

    }, false);
    
    //Open tab version
    
    jiscbanner.toggletab = function () {
      
        if (jiscbanner.bannerframe.style.marginTop !== "0px") {
        
            jiscbanner.bannerframe.style.marginTop = "0px";
            
            document.getElementById("jiscbannertab").style.backgroundPosition = "0 0px";
            
        } else {
            
            jiscbanner.bannerframe.style.marginTop = "-" + jiscbanner.tabmargin + "px";
            document.getElementById("jiscbannertab").style.backgroundPosition = "0 -93px";

            
        }
        
        return true;
        
    };
};


//Function for creating styles (via Stack Overflow - 2041495)

document.addStyle = function (str, med) {
    var el = document.createElement('style');
    el.type = "text/css";
    el.media = med || 'screen';
    if (el.styleSheet) {
        el.styleSheet.cssText = str;
    } else {
        el.appendChild(document.createTextNode(str));
    }
    return document.getElementsByTagName('head')[0].appendChild(el);
};

var ieconditional = '<!--[if lt IE 10]><style>body {display:none;}</style><![endif]-->'

document.body.insertAdjacentHTML('afterbegin', ieconditional);

document.addStyle(customcss, "screen and (min-width: 300px)");

jiscbanner.main();
