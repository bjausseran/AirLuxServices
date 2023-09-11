// 'use strict';

// // NOTE - Require
// const redis = require('redis');

// // NOTE - REDIS
// const client = redis.createClient({
//     url: 'redis://redis-server',
//     port: 6379
//   });

// async function redis_connection() {
//     client.connect(function(err) {
//         if(err) throw err;
//         console.log("Redis database connected!")
//     })
// }
// // --------------------

// // NOTE - Redis connection
// redis_connection();

// // NOTE - API
// const http = require('http');

// http.get('http://127.0.0.1/api/captor', (resp) => {
//   let data = '';

//   // A chunk of data has been received.
//   resp.on('data', (chunk) => {
//     data += chunk;
//   });

//   // The whole response has been received. Print out the result.
//   resp.on('end', () => {
//     console.log(JSON.parse(data).explanation);
//   });

// }).on("error", (err) => {
//   console.log("Error: " + err.message);
// });
// // --------------------
