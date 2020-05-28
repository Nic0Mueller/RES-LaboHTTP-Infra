var Chance = require('chance');
var chance = new Chance();

var Express = require('express');
var app = new Express();

app.get('/', function(req, res) {
	res.send( generateAnimals() );
});

app.listen(3000, function() {
	console.log('Accepting HTTP requests on port 3000');
});

function generateAnimals() {

	var numberOfAnimals = chance.integer({
        min:    0,
        max:    10
    });
    
    var animals = [];
    
    for (var i = 0;  i < numberOfAnimals; i++) {
        var name = chance.name();
        var animal = chance.animal();
        
        var birthYear = chance.year({
            min: 1900,
            max:2020
        });

        animals.push({
            specie: animal,
            name:name,
            birthYear:birthYear
        });
    };
    
    console.log(animals);
    return animals;
}
