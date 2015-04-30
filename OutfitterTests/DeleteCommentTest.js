var target = UIATarget.localTarget();

UIATarget.onAlert = function onAlert(alert) { // this is never called
    var title = alert.name();
    var message = alert.staticTexts()[0].name();
    if(title == "Successfully deleted comment!"){
        
    } else {
        UIALogger.logError("Unknown alert appeared");
    }
    return true;
}

if(target.frontMostApp().mainWindow().buttons()["Log out"].checkIsValid()){
    target.frontMostApp().mainWindow().buttons()["Log out"].tap();
    target.delay(1);
}
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].setValue("test_user")
target.frontMostApp().mainWindow().scrollViews()[0].secureTextFields()[0].setValue("asdf")
target.frontMostApp().mainWindow().scrollViews()[0].buttons()["Log In"].tap();
// Now we are logged in
target.frontMostApp().mainWindow().buttons()["Portfolio"].tap();
target.delay(15)
target.tap({x:72.00, y:149.00});
target.delay(1)
target.frontMostApp().navigationBar().rightButton().tap();
target.delay(1)
target.frontMostApp().mainWindow().tableViews()[0].cells()[0].buttons()[0].tap();
// Alert detected. Expressions for handling alerts should be moved into the UIATarget.onAlert function definition.
// Check to make sure the comment was deleted
target.delay(2)
target.frontMostApp().alert().buttons()["Cancel"].tap();
target.delay(1)
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(15)
target.frontMostApp().navigationBar().leftButton().tap();