drop table if exists authors cascade;
drop table if exists versions cascade;
drop table if exists documents cascade;
drop table if exists comments cascade;

create table authors(
	id serial primary key,
	first_name varchar(255) not null,
  last_name varchar(255) not null,
  username varchar(255) not null,
	password varchar(255) not null,
	created_at TIMESTAMP,
	updated_at TIMESTAMP
);

create table documents(
	id serial primary key,
	title text not null,
	img_url text,
	created_at TIMESTAMP,
	updated_at TIMESTAMP
);

create table versions(
	id serial primary key,
  blurb text not null,
	content text not null,
	author_id integer references authors,
  document_id integer references documents,
	created_at TIMESTAMP,
	updated_at TIMESTAMP
);

create table comments(
	id serial primary key,
	c_date integer not null,
	com text not null,
	author_id integer references authors,
	document_id integer references documents,
	created_at TIMESTAMP,
	updated_at TIMESTAMP
);
