var alertThrown = false;
UIATarget.onAlert = function onAlert(alert) { // this is never called
    UIALogger.logDebug("Incorrect password alert thrown");
    alertThrown = true;
    target.frontMostApp().alert().buttons()["OK"].tap();
    return true;
}
var target = UIATarget.localTarget();
if(target.frontMostApp().mainWindow().buttons()["Log out"].checkIsValid()){
    target.frontMostApp().mainWindow().buttons()["Log out"].tap();
    target.delay(1);
}
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].setValue("test");
target.frontMostApp().mainWindow().scrollViews()[0].secureTextFields()[0].setValue("password123");
target.frontMostApp().mainWindow().scrollViews()[0].buttons()["Log In"].tap();
target.delay(2);
if(alertThrown == false){
    UIALogger.logError("Incorrect password alert was not thrown when it should have been");
}
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].setValue("");
target.frontMostApp().mainWindow().scrollViews()[0].secureTextFields()[0].setValue("");