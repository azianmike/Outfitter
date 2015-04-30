var target = UIATarget.localTarget();

UIATarget.onAlert = function onAlert(alert) { // this is never called
    var title = alert.name();
    var message = alert.staticTexts()[0].name();
    if(title == "Successfully added comment!"){
        
    } else if (title == "Add comment") {
        
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
target.frontMostApp().mainWindow().buttons()["Browse"].tap();
target.frontMostApp().mainWindow().buttons()["Comments"].tap();
target.frontMostApp().navigationBar().rightButton().tap();
// Alert detected. Expressions for handling alerts should be moved into the UIATarget.onAlert function definition.
target.frontMostApp().alert().scrollViews()[0].tableViews()[0].cells()[0].textFields()[0].setValue("iPhone Automated Testing test")
target.frontMostApp().alert().buttons()["Add"].tap();
// Alert detected. Expressions for handling alerts should be moved into the UIATarget.onAlert function definition.
//Check if Successfully added comment
target.delay(2)
target.frontMostApp().alert().buttons()["Cancel"].tap();
target.delay(1)
target.frontMostApp().mainWindow().buttons()["Back"].tap();