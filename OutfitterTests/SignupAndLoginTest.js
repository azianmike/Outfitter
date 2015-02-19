#import "APIKeys.js"
UIATarget.onAlert = function onAlert(alert) { // this is never called
    var title = alert.name();
    if(title == "Sign Up Error"){
        UIALogger.logError("Signup error and this should not have happened");
        target.frontMostApp().alert().buttons()["OK"].tap();
        target.frontMostApp().mainWindow().scrollViews()[0].tapWithOptions({tapOffset:{x:0.24, y:0.19}});
    } else {
        UIALogger.logError("Username and Password combination incorrect but should have been correct.");
        target.frontMostApp().alert().buttons()["OK"].tap();
        target.frontMostApp().mainWindow().scrollViews()[0].tapWithOptions({tapOffset:{x:0.27, y:0.19}});
    }
    return true;
}
var target = UIATarget.localTarget();
/*target.delay(1)
if(target.frontMostApp().mainWindow().buttons()["Log out"].checkIsValid()){
    target.frontMostApp().mainWindow().buttons()["Log out"].tap();
    target.delay(1);
}
target.frontMostApp().mainWindow().scrollViews()[0].buttons()["Sign Up"].tap();
target.delay(2)
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].setValue("test");
target.frontMostApp().mainWindow().scrollViews()[0].secureTextFields()[0].setValue("password");
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[1].setValue("testemail@testing.com");
target.frontMostApp().mainWindow().scrollViews()[0].buttons()["Sign Up"].tap();
target.delay(10)
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].setValue("");
target.frontMostApp().mainWindow().scrollViews()[0].secureTextFields()[0].setValue("");
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[1].setValue("");

target.frontMostApp().mainWindow().scrollViews()[0].buttons()[0].tap();
target.delay(2)
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].setValue("test");
target.frontMostApp().mainWindow().scrollViews()[0].secureTextFields()[0].setValue("password");
target.frontMostApp().mainWindow().scrollViews()[0].buttons()["Log In"].tap();
if(target.frontMostApp().mainWindow().buttons()["Log out"].checkIsValid()){
    target.frontMostApp().mainWindow().buttons()["Log out"].tap();
    target.delay(1);
}
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].setValue("");
target.frontMostApp().mainWindow().scrollViews()[0].secureTextFields()[0].setValue("");*/

// Remove the test user from Parse
var masterKeyString = "X-Parse-Master-Key: " + parseMasterKey;
var result = target.host().performTaskWithPathArgumentsTimeout("/usr/bin/curl", ["-X", "DELETE",
                                                                                 "-H", "X-Parse-Application-Id: SOzwRu6FgQqXZutDyUx25OhuydwfBhY5amOqp2Td",
                                                                                 "-H", masterKeyString ,
                                                                                 "-H", "X-Parse-Session-Token: pnktnjyb996sj4p156gjtp4im" ,
                                                                                 "https://api.parse.com/1/users/9seqj8nSeV"], 30);
UIALogger.logDebug(result.stdout);
