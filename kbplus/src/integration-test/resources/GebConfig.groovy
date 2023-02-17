import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.chrome.ChromeOptions
import org.openqa.selenium.firefox.FirefoxDriver
import org.openqa.selenium.firefox.FirefoxOptions

// See https://stackoverflow.com/questions/13575999/mantain-session-between-tests-using-geb
// https://www.gebish.org/manual/current/
autoClearCookies = false

environments {

    // run via “./gradlew -Dgeb.env=chrome iT”
    chrome {
        driver = { new ChromeDriver() }
    }

    // run via “./gradlew -Dgeb.env=chromeHeadless iT”
    chromeHeadless {
        driver = {
            ChromeOptions o = new ChromeOptions()
            o.addArguments('headless')
            new ChromeDriver(o)
        }
    }

    // run via “./gradlew -Dgeb.env=firefox iT”
    firefox {
        driver = { new FirefoxDriver() }
    }

    firefoxHeadless {
      driver = {
        FirefoxOptions o = new FirefoxOptions()
        o.addArguments('--headless')
        new FirefoxDriver(o)
      }
    }

}
