package kbplus.pages
/**
 * Created by ioannis on 28/05/2014.
 */
class DashboardPage extends BasePage {
    static url = "/myInstitutions/University_of_Life/dashboard"//"/home/index"
    static at = { browser.page.title.startsWith "University" };

    static content = {
        
    }
}
