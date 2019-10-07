---
Author: Mike Carifio &lt;<mike@carif.io>&gt; \
Title: Postgres 12 Was Just Released. Let's Upgrade. \
Date: 2019-10-06 \
Tags: #postgres, #systemctl \ 
Blog: [https://mike.carif.io/blog/upgrade-postgres-to-12.html](https://mike.carif.io/blog/upgrade-postgres-to-12.html) \
VCS: [https://www.github.com/mcarifio/blog/blob/master/tree/src/upgrade-postgres-to-12.md](https://www.github.com/mcarifio/blog/blob/master/src/upgrade-postgres-to-12.md)
---

# PostgreSQL 12 Was Just Released. Let's Upgrade.

## Motivation

PostgreSQL 12 was [recently released](https://www.postgresql.org/about/news/1976/). I thought I would install it and kick the tires over the next few days and beyond.
My ulterior motive is to explore three features that "documentize" psql:

1. [pl/v8](https://plv8.github.io/), an extension to write "stored procedures" in javascript/es2015+. The integration can be a little crufty and lags behind the most current
   v8, nevertheless I'm intrigued.
   
2. Using [JSON/JSONB to store data](http://www.postgresqltutorial.com/postgresql-json/) and to format query results using the [to_json](https://www.postgresql.org/docs/12/functions-json.html) function.

3. Exposing the database using [postgREST](https://github.com/PostgREST) for a "direct api" experience.

There are still missing pieces:

* A "meta-data" description of the API exported using either [OpenAPI](https://www.openapis.org/) or [gRPC](https://grpc.io/). I used to be bullish on OpenAPI aka swagger, but for various reasons, I think gRPC will win the day, especially if and when [it's integrated into browsers](https://grpc.io/blog/state-of-grpc-web/). gRPC also has _far_ better documentation and a more approachable programming model. 

* A GraphQL engine to return queries as GraphQL response. [Hasura](https://github.com/hasura/graphql-engine/tree/master/server) could be interesting, but they haven't presented a way to build from source. They're a company with an open source product licensed Apache 2, they don't want to make competition easy.

## Upgrade on Ubuntu

The PostgreSQL 12 documentation gives [a recipe for upgrading an existing installation](https://www.postgresql.org/docs/12/upgrading.html) but it's pretty generic and doesn't take advantage of Ubuntu's packaging and ability to run multiple version of pg at once. Here's a different way to upgrade from 11 to 12 (all commands issued as `root`):

```bash
apt upgrade
apt upgrade -y
apt install postgresql-12 postgresql-plpython3-12 libpq-dev # YMMV
```

At this point, you actually two running instances of pg, 11 and 12. To see that:

```bash
systemctl list-units | grep postgres
```

You want to copy your existing databases from 11 to 12. I assume here that your 11 instance is listening on the default pg port `5432`.

```bash
pg_dumpall | (cd ~postgres; sudo -u postgres /usr/bin/psql -d postgres -p 5433)  # load the contents of 11's db to 12.
```

This works because the distribution port for 12 is `5433`. You can test that 12 has your 11 data:

```bash
psql -p 5433 -c 'select version();'
                                                          version                                                          
---------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 12.0 (Ubuntu 12.0-1.pgdg19.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 8.3.0-6ubuntu1) 8.3.0, 64-bit
(1 row)

psql -p 5433 -c "\du"
                                   List of roles
 Role name |                         Attributes                         | Member of 
-----------+------------------------------------------------------------+-----------
 mcarifio  | Superuser, Create role, Create DB                          | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 root      | Superuser, Create role, Create DB                          | {}
```

You can use some other query to confirm that the `pg_dumpall` worked.

You probably want to keep 11 around for a while. I decided to stop the service and disable it.

```bash
systemctl stop postgresql@11-main.service
systemctl stop postgresql@11-main.service
```

I now want 12 to listen to the default pg port `5432`: 

```bash
emacs -nw /etc/postgres/12/main/postgres.conf # change port to 5432 (default)
systemctl restart postgresql
systemctl status postgresql
journalctl -u postgresql
pgsql -c 'select version();'
```

<!-- @publish: git commit -am "Postgres 12 just released. Let's upgrade." && git push -->
