-- drop table if exists authors;
-- drop table if exists versions;
-- drop table if exists documents;
drop table if exists comments cascade;

create table authors(
	id serial primary key,
	first_name varchar(255) not null,
  last_name varchar(255) not null,
  username varchar(255) not null
);

create table documents(
	id serial primary key,
	title text not null
);

create table versions(
	id serial primary key,
	v_date integer not null,
  blurb text not null,
	content text not null,
	author_id integer references authors,
  document_id integer references documents
);

create table comments(
	id serial primary key,
	c_date integer not null,
	com text not null,
	author_id integer references authors,
	document_id integer references documents
);
