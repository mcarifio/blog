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

* A GraphQL engine to return queries as a [GraphQL](https://graphql.org/) response. [Hasura](https://github.com/hasura/graphql-engine/tree/master/server) could be interesting, but they haven't presented a way to build from source. They're a company with an open source product licensed Apache 2, they don't want to make competition easy. In many ways, GraphQL would be the better approach, since it's more data oriented and generic.



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
mkdir ~/postgres/pg_dumpall
pg_dumpall | tee ~/postgres/pg_dumpall/11-to-12.pgdump | sudo -u postgres psql -p 5433  # load the contents of 11's db to 12.
```

This works because the distribution port for 12 is `5433`. You can test that 12 has all your 11 data: 

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

You may want to check for other changes specific to your database(s).


I now want 12 to listen to the default pg port `5432`: 

```bash
emacs -nw /etc/postgres/12/main/postgres.conf # change port to 5432 (default)
systemctl restart postgresql
systemctl status postgresql
journalctl -u postgresql
pgsql -c 'select version();'
```

At some distant future, you may conclude that 12 suits your needs and the 11 data is superfluous:

```bash
cd /var/lib/postgresql
tar -caf 11.tar.xz 11  # just in case you ever want to recover
rm -rf 11
apt purge $(dpkg --list|grep -e '\bpostgresql.*-11\b') # Find all 11 packages and purge them explicitly
```



## Upgrade on Fedora Core

A similar approach (but not the same commands, unfortunately) works on Fedora Core 30. Unlike Ubuntu, FC30 looks for
configuration information in "the default location" `/var/lib/pgsql/12/data`. And it must first be generated. Again as `root`:

```bash
dnf upgrade -y
dnf install -y postgresql12{,-server,-devel,-llvmjit,-contrib,-plpython}
export PATH=/usr/pgsql-12/bin:$PATH  # prefer the psql12 binaries
postgresql-12-setup initdb  # create /var/lib/pgsql/12/data/*.conf
```

Note that both 11 and 12 are configured to listen to the default port `5432` on FC30, unlike the default (above) for Ubuntu. So, let's override the port
for 12:

```bash
install -u postgres -g postgres -d /var/lib/pgsql/12/data/conf.d  # create a conf.d owned by user postgres
echo "include_dir = 'conf.d'" >> /var/lib/pgsql/12/data/postgresql.conf  # look for additional conf files in conf.d
echo 'port = 5433' > /var/lib/pgsql/12/data/conf.d/port-5433.conf # override the default port
systemctl start postgresql-12  # start 12
systemctl status postgresql-12
sudo -u postgres psql -p 5433 -c 'select version();'
```

At this point you have two running postgresql instances, 11 listening on the default port 5432 and 12 listening on port 5433. Copy the contents from 11 to 12:

```bash
mkdir ~/postgres/pg_dumpall
pg_dumpall | tee ~/postgres/pg_dumpall/11-to-12.pgdump | sudo -u postgres psql -p 5433  # load the contents of 11's db to 12.
```


You can test that 12 has your 11 data by looking for various things (e.g. users):

```bash
psql -p 5433 -c 'select version();'
psql -p 5433 -c "\du"
```

At some distant future, you may conclude that 12 suits your needs and the 11 data is superfluous:

```bash
cd /var/lib/pgsql
tar -caf 11.tar.xz 11  # just in case you ever want to recover
rm -rf 11
dnf remove postgresql-11
```



<!-- @publish: git commit -am "Postgres 12 just released. Let's upgrade." && git push -->
