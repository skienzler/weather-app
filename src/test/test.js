// Import the dependencies for testing
const chai = require('chai');
const chaiHttp = require('chai-http');
const app = require('../server');

// Configure chai
chai.use(chaiHttp);
chai.should();

describe("Weather", () => {
    describe("GET /", () => {
        it("should return a 200 status code", (done) => {
            chai.request(app)
                .get('/')
                .end((err, res) => {
                    res.should.have.status(200);
                    done();
                });
        });
    });
    describe("POST /", () => {
        it("should return a 200 status code if a city is given", (done) => {
            chai.request(app)
                .post('/')
                .set('content-type', 'application/x-www-form-urlencoded')
                .send({
                    city: "Hamburg"
                })
                .end((err, res) => {
                    res.should.have.status(200);
                    done();
                });
        });
        it("should return a 422 status code if no city is given", (done) => {
            chai.request(app)
                .post('/')
                .end((err, res) => {
                    res.should.have.status(422);
                    done();
                });
        });
    });
});