function checkIfLoggedIn(){
    if(target.frontMostApp().mainWindow().buttons()["Log out"].checkIsValid()){
        target.frontMostApp().mainWindow().buttons()["Log out"].tap();
        target.delay(1);
    } else {
        UIALogger.logError("Facebook should have been logged in but was not.");
    }
}
UIATarget.onAlert = function onAlert(alert) { // this is never called
    var title = alert.name();
    var message = alert.staticTexts()[0].name();
    if(title == "Facebook"){
        target.frontMostApp().alert().buttons()["OK"].tap();
    } else {
        UIALogger.logError("Unknown alert appeared");
    }
    return true;
}
var target = UIATarget.localTarget();
if(target.frontMostApp().mainWindow().buttons()["Log out"].checkIsValid()){
    target.frontMostApp().mainWindow().buttons()["Log out"].tap();
    target.delay(1);
}
target.frontMostApp().mainWindow().scrollViews()[0].buttons()["Log In with Facebook"].tap();
target.delay(2)
checkIfLoggedIn();