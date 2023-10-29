const http = require('http');
const hostname = '0.0.0.0';
const port = 3000;

// count the number of requests
let counter = 0;

const server = http.createServer((req, res) => {
  
  // Log request summary
  console.log(req.headers);
  // Log the request method
  console.log(req.method);

  counter++;

  // Log the number of requests
  console.log(`Request number ${counter}`);

  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World, my name is Waleed');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});