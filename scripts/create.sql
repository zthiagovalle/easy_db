create schema thiago;

create table thiago.movie (
  id serial primary key,
  name text,
  year integer
);

insert into thiago.movie (name, year) values ('Jurassic Park', 1993);
insert into thiago.movie (name, year) values ('Back to the Future', 1985);
insert into thiago.movie (name, year) values ('Interstellar', 2014);