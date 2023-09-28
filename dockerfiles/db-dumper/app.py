import csv
import posixpath
from datetime import datetime
from datetime import timezone

from environs import Env

from google.cloud.sql.connector import Connector
import pg8000
import sqlalchemy

from google.cloud import storage


def connect_with_connector() -> sqlalchemy.engine.base.Engine:
    env = Env()
    instance_connection_name = env.str("DBDUMPER_DB_INSTANCE_NAME")
    db_user = env.str("DBDUMPER_DB_USER")
    db_pass = env.str("DBDUMPER_DB_PASS")
    db_name = env.str("DBDUMPER_DB_NAME")

    connector = Connector()

    def getconn() -> pg8000.dbapi.Connection:
        conn: pg8000.dbapi.Connection = connector.connect(
            instance_connection_name,
            "pg8000",
            user=db_user,
            password=db_pass,
            db=db_name,
        )
        return conn

    pool = sqlalchemy.create_engine(
        "postgresql+pg8000://",
        creator=getconn,
        pool_size=5,
        max_overflow=2,
        pool_timeout=30,  # 30 seconds
        pool_recycle=1800,  # 30 minutes
    )
    return pool


if __name__ == '__main__':
    env = Env()
    db = connect_with_connector()
    query = sqlalchemy.text(env.str("DBDUMPER_QUERY"))

    now = datetime.now(timezone.utc)
    bucket_blob_path = posixpath.join(env.str("DBDUMPER_BUCKET_PATH", ""),
                                    f'{env.str("DBDUMPER_BUCKET_FILE_BASE_NAME", "dump")}-{now.strftime("%m%d%Y-%H%M%S")}.csv')
    storage_client = storage.Client()
    bucket = storage_client.bucket(env.str("DBDUMPER_BUCKET_NAME"))
    bucket_blob = bucket.blob(bucket_blob_path)

    with db.connect() as conn:
            q = conn.execution_options(stream_results=True, postgresql_readonly=True).execute(query)
            with bucket_blob.open("w") as f:
                csv_file = csv.writer(f)

                header=list(q.keys())
                csv_file.writerow(header)
                for record in q.all():
                    csv_file.writerow([getattr(record, c) for c in header])
