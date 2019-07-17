const express = require('express');
const bodyParser = require('body-parser');
const request = require('request');
const app = express()

const apiKey = '82977f4341d6d96ac3226cbdb6d28306';

app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: true }));
app.set('view engine', 'ejs')

app.get('/', function (req, res) {
    res.render('index', { weather: null, error: null });
})

app.post('/', function (req, res) {
    if(req.body.city == undefined) {
        res.status(422);
        res.render('index', { weather: null, error: 'Error, please try again' });
        return;
    }

    let city = req.body.city;
    let url = `http://api.openweathermap.org/data/2.5/weather?q=${city}&units=metric&appid=${apiKey}`

    request(url, function (err, response, body) {
        if (err) {
            res.render('index', { weather: null, error: 'Error, please try again' });
        } else {
            let weather = JSON.parse(body);
            if (weather.main == undefined) {
                res.render('index', { weather: null, error: 'Error, please try again' });
            } else {
                let view = {
                    temp: weather.main.temp,
                    city: weather.name
                };
                res.render('index', { weather: view, error: null });
            }
        }
    });
})

app.listen(3000, function () {
    console.log('Example app listening on port 3000!')
})

module.exports = app;