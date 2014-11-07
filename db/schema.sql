drop table if exists authors cascade;
drop table if exists versions cascade;
drop table if exists documents cascade;

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
