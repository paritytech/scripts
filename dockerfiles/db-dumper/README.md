# db-dumper

## Description

db-dumper is a script that makes dumps of GCP Cloud SQL Postgres databases to a GCP Cloud storage bucket.

## Features

* uses a stream to read DB and writes every row directly to a bucket blob,
  it allows dumping any DBs avoiding custom RAM or disk caches
* a dump query can be defined as a configuration variable
* runs query in read-only mode, it's safe for DB data
* uses the simple CSV output format
* uses cloud-sql-python-connector, which allows connecting to DB using IAM authentication
* uses native Google libraries, it allows to move the script to GCP Cloud Functions with minimum changes

## Configuration

The script can be configured using environment variables

Required:
* `DBDUMPER_DB_INSTANCE_NAME` - GCP Cloud sql instance name, e.g. `project:region:instance`
* `DBDUMPER_DB_NAME` - DB  name lo login
* `DBDUMPER_DB_USER` - DB user name lo login
* `DBDUMPER_DB_PASS` - DB user password lo login
* `DBDUMPER_QUERY` - DB query, e.g. `SELECT * FROM Customers`
* `DBDUMPER_BUCKET_NAME` - name of a GCP Cloud storage bucket

Optional:
* `DBDUMPER_BUCKET_PATH` - base path in the bucket, the default value is the empty string (the root of the bucket)
* `DBDUMPER_BUCKET_FILE_BASE_NAME` - first part of the dump file name, the default value is `dump`
* `DBDUMPER_LOG_LEVEL`- log levels of the `logging` Python module, the default value is `INFO`

## Dump path

`{DBDUMPER_BUCKET_PATH}/{DBDUMPER_BUCKET_FILE_BASE_NAME}-%m%d%Y-%H%M%S.csv`