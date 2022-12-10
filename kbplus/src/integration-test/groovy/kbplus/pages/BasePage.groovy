package kbplus.pages

import geb.Page
import geb.error.RequiredPageContentNotPresent
//import grails.plugin.remotecontrol.*

/**
 * Created by ioannis on 28/05/2014.
 */
class BasePage extends Page {
	//MC/AF: Remote control support for grails 3 is non-existent at the moment!
    //def remote = new RemoteControl()

    /*String getMessage(String code, Object[] args = null, Locale locale=null) {
            remote.exec { ctx.messageSource.getMessage(code, args, locale) }
    }*/
    static content = {

        alertBox { msg ->
            println("alert for...");
            waitFor { $("div.alert-warning").displayed }
            println("alert box - looking for ${msg} in "+$("div.alert-warning").children().filter("p").text());
            $("div.alert-warning").children().filter("p").text().contains(msg)
        }

        messageBox { msg ->
            waitFor{ $("div.alert-block").displayed }
            $("div.alert-block").children().filter("p").text().contains(msg)
        }

        errorBox { msg ->
            waitFor{ $("div.alert-block").displayed }
            $("div.alert-block").children().filter("p").text().contains(msg)
        }
        terms {
            waitFor{ $("ul.footer-sublinks").displayed }
            $("ul.footer-sublinks").children().find("a", text: "Terms & Conditions").click()
        }
        privacy {
            waitFor{ $("ul.footer-sublinks").displayed }
            $("ul.footer-sublinks").children().find("a", text: "Privacy Policy").click()
        }
        freedom {
            waitFor{ $("ul.footer-sublinks").displayed }
            $("ul.footer-sublinks").children().find("a", text: "Freedom of Information Policy").click()
        }
        help {
            $("a", text: "Institutions").click()
            $("a", text: "Help").click()
        }
        home {
            $("a.brand", text: "KB+").click()
        }
        support {
            $("#zenbox_tab").click()
        }
        logout {
            $("ul.pull-right").children().find("a.dropdown-toggle").click()
            waitFor{$("a", text: "Logout")}
            $("a", text: "Logout").click()
        }
        manageAffiliationReq {
            waitFor{ $("#AdminActionsDropdownMenu").displayed }
            $("#AdminActionsDropdownMenu").click()
            waitFor{ $("#ManageAffiliationRequestsAction").displayed }
            $("#ManageAffiliationRequestsAction").click()
        }
        templateLicence {
            $("#DataManagersDropdownAction").click()
            waitFor{ $("a", text: "New Licence")}
            $("#NewLicenseAction").click()
        }
        changeUserNoDash { user, passwd ->
            System.out.println("changeUserNoDash - click logout button");
            waitFor{$("#userDropdownMenu").displayed}

            $("#userDropdownMenu").click();
            System.out.println("changeUserNoDash - Wait for logout");
            waitFor{$("#LogoutBtn").displayed}
            $("#LogoutBtn").click()

            waitFor { $("#LoginBTN").displayed }
            $("#LoginBTN").click()

            waitFor { $("#SubmitLoginFormBTN").displayed }
            $("form").j_username = user
            $("form").j_password = passwd
            $("#SubmitLoginFormBTN").click()
        }
        changeUser { user, passwd ->
            waitFor{$("#userDropdownMenu").displayed}
            $("#userDropdownMenu").click();

            waitFor{$("#LogoutBtn")}
            $("#LogoutBtn").click()

            waitFor { $("#LoginBTN").displayed }
            $("#LoginBTN").click()

            waitFor { $("#SubmitLoginFormBTN").displayed }
            $("form").j_username = user
            $("form").j_password = passwd
            $("#SubmitLoginFormBTN").click(DashboardPage)
        }
        hasInfoIcon {
            !$("i.icon-info-sign").isEmpty()
        }
        /*compareONIX {
            $("a", text: "Institutions").click()
            $("a", text: getMessage("menu.institutions.comp_onix")).click()
        }*/
        allPackages {
            $("a", text: "Institutions").click()
            $("a", text: "All Packages").click(PackageDetailsPage)
        }
        manageContent {
            $("a", text: "Admin Actions").click()
            $("a", text: "Manage Content Items").click(AdminMngContentItemsPage)
        }
        toCompareSubscriptions{
           $("#DataManagersDropdownAction").click()
           $("a", text: "Compare Subscriptions").click(SubscrDetailsPage) 
        }
        orgInfo { name ->
            $("input", name: "orgNameContains").value(name)
            $("input.btn-primary", value: "GO").click()
            $("a", text: name).click()
        }
        allTitles {
            $("a", text: "Institutions").click()
            $("a", text: "All Titles").click(TitleDetailsPage)
        }
        startESUpdate {
            $("a", text: "Admin Actions").click()
            $("a",text:"Batch tasks").click()
            $("a", text: "Start ES Index Update").click()
        }
        catchException { run ->
            def exec = false;
            try {
                run()
            } catch (RequiredPageContentNotPresent e) {
                exec = true;
            } catch (org.openqa.selenium.ElementNotVisibleException ex) {
                exec = true;
            }
            exec
        }
        waitElement {run ->
            try{
                waitFor{run()}
            } catch (geb.waiting.WaitTimeoutException e) {
                throw new RequiredPageContentNotPresent()
            }
        }

        uploadJasper { 
            $("a", text: "Admin Actions").click()
            waitFor{ $("a", text: "Upload Report Definitions")}
            $("a", text: "Upload Report Definitions").click(JasperPage)
        }

        generateJasper {
            waitFor{ $("#DataManagersDropdownAction").displayed }
            $("#DataManagersDropdownAction").click()
            waitFor{ $("#JasperReportsAction").displayed }
            $("#JasperReportsAction").click(JasperPage)
        }

        dmChangeLog {
            waitFor{ $("#DataManagersDropdownAction").displayed }
            $("#DataManagersDropdownAction").click()
            waitFor{ $("#DataManagerChangeLogAction").displayed }
            $("#DataManagerChangeLogAction").click(DataManagerPage)
        }

        showInstMenu {
            $("a",text:"Institutions").click()
            $("a",text:"Functional Test Organisation").siblings("ul").jquery.show()
        }

        toComparePackages {
            $("a",text:"Institutions").click()
            $("a",text:"Compare Packages").click(PackageDetailsPage)
        }

    }
}
