package kbplus.pages
/**
 * Created by ioannis on 28/05/2014.
 */
class LogInPage extends BasePage {
    static url = "/login/auth"
    static at = { browser.page.title.startsWith "Login" };

    static content = {
        login { name, passwd ->
            $("form").username = name
            $("form").password = passwd//maybe username and password now with no j_ prefix
            $("#submit", value: "Login").click()//id is now submit
        }
    }
}
