var ScriptVars = Java.type('org.zaproxy.zap.extension.script.ScriptVars');

function browserLaunched(utils) {
    var url = utils.waitForURL(5000);
    logger('browserLaunched ' + utils.getBrowserId() + ' url: ' + url);
   
    var wd = utils.getWebDriver();
    // var jsUrl = 'https://dev-aftersale-portal.cdc.ais.th/';
    var jsUrl = ScriptVars.getGlobalVar('baseScanUrl');
    var val = ScriptVars.getGlobalVar('sessionValue');
    logger('jsUrl: '+jsUrl);
    logger('sessionValue: '+val);
    
    if (url.startsWith(jsUrl)) {
        logger('url: ' + jsUrl + ' setting token ');
        var script = 'window.sessionStorage.setItem(\'dXNlcmFmc0RldGFpbA==\', \'' + val + '\');\n' +
            'window.sessionStorage.setItem(\'Y2hlY2ttZW51\', \'' + 'dHJ1ZQ==' + '\');';
        wd.executeScript(script);
    }
	
	logger("set session storage " + utils.getBrowserId() + ' url: ' + jsUrl);
     
    url = wd.get("https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/main-menu");
    utils.waitForURL(5000);
    logger('loading to afs portal ' + utils.getBrowserId() + ' url: ' + url);

    var screenshotBase64 = wd.getScreenshotAs('OutputType.BASE64');
    logger('screenshot: ' + screenshotBase64);
}
// Logging with the script name is super helpful!
function logger() {
	print("[" + this["zap.script.name"] + "] " + arguments[0]);
}