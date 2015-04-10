var target = UIATarget.localTarget();
if(target.frontMostApp().mainWindow().buttons()["Log out"].checkIsValid()){
      target.frontMostApp().mainWindow().buttons()["Log out"].tap();
      target.delay(1);
}
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].setValue("test_user")
target.frontMostApp().mainWindow().scrollViews()[0].secureTextFields()[0].setValue("asdf")
target.frontMostApp().mainWindow().scrollViews()[0].buttons()["Log In"].tap();
// Now we are logged in
target.frontMostApp().mainWindow().buttons()["Portfolio"].tap();
// need to sleep
target.delay(12);
target.tap({x:60.00, y:156.00});
target.delay(1)
// check if new view is up
if(target.frontMostApp().mainWindow().staticTexts()["like"].name()=="like")
{
    // Passed
    target.delay(2)
    target.frontMostApp().navigationBar().leftButton().tap();
    target.delay(12)
    target.frontMostApp().navigationBar().leftButton().tap();
}
else{
    UIALogger.logError("The UI is not on the correct page");
}