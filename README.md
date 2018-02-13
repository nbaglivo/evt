# Up and running

* Build container
  `docker-compose build`
* Run container
  `docker-compose build`
* Run tests
  `docker-compose web rspec`  
* check [the api](http://0.0.0.0:3000)

## Test with postman

* Import the postman collection.
* Sign up with the endpoint.
* Copy the response token.
* Select any other endpoint and use the token on the header Authorization:

    e.g: `Authorization Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MTg2NDAwNTN9.QPsHLR780lNOhDyF00UTMhuKKBkQ0aQDCTPTUuzGYHA`
