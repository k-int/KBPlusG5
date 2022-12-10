package kbplus.pages
/**
 * check login
 */
class PublicPage extends BasePage {
    static url = "/"
    static at = { browser.page.title.startsWith "Knowledge Base+" };

    static content = {
        loginLink {
            waitFor { $("#LoginBTN")}
            $("#LoginBTN").click()
        }
        
    }
}
