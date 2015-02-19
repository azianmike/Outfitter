#import "parse-1.3.4.min.js"
Parse.initialize("SOzwRu6FgQqXZutDyUx25OhuydwfBhY5amOqp2Td", "i9D2vEJv4ZA6T0xE1Rmw80Zg8ynngqEJ2vCT1v7F");
var query = new Parse.Query(Parse.User);
query.equalTo("username", "test");
query.find({
           success: function(user) {
        
           }
           });