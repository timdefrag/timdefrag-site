require("coffee-script"); 

var app = require("./src/server");
app.listen(process.env.PORT);