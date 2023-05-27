const pgp = require('pg-promise')

const connection = pgp()("postgres://postgres:123456@localhost:5432/app");

async function listMovies() {
  const movies = await connection.query("select * from thiago.movie");
  console.log(movies);
  connection.$pool.end();
}

listMovies();