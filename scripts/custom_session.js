var ScriptVars = Java.type('org.zaproxy.zap.extension.script.ScriptVars');

function browserLaunched(utils) {
    var url = utils.waitForURL(5000);
    logger('browserLaunched ' + utils.getBrowserId() + ' url: ' + url);

    var wd = utils.getWebDriver();

    // force navigate to specific url 
    navigate_url = ScriptVars.getGlobalVar('navigateUrl');
    var val = ScriptVars.getGlobalVar('sessionValue');

    logger('navigate url: '+navigate_url);
    logger('sessionValue: '+val);
    
    wd.navigate().to(navigate_url);
    // wd.navigate().to("https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/main-menu");
    logger('navigated');

    var script = 'window.sessionStorage.setItem(\'dXNlcmFmc0RldGFpbA==\', \'' + val + '\');\n' +
        'window.sessionStorage.setItem(\'Y2hlY2ttZW51\', \'' + 'dHJ1ZQ==' + '\');';

    wd.executeScript(script);

    logger("finish set session storage " + utils.getBrowserId());

    // force redirect again
    wd.navigate().to(navigate_url);
    // wd.navigate().to("https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/main-menu");
    
    // refresh
    wd.navigate().refresh();
    logger('navigate and refresh');

}
// Logging with the script name is super helpful!
function logger() {
	print("[" + this["zap.script.name"] + "] " + arguments[0]);
}