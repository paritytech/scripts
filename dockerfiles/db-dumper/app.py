import csv
import posixpath
import logging
from datetime import datetime
from datetime import timezone

from environs import Env

from google.cloud.sql.connector import Connector
import pg8000
import sqlalchemy

from google.cloud import storage

LOGGING_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'

def connect_with_connector() -> sqlalchemy.engine.base.Engine:
    env = Env()
    instance_connection_name = config['DBDUMPER_DB_INSTANCE_NAME']
    db_user = config['DBDUMPER_DB_USER']
    db_pass = env.str("DBDUMPER_DB_PASS")
    db_name = config['DBDUMPER_DB_NAME']

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

    config = {}
    config['DBDUMPER_LOG_LEVEL'] = env.str("DBDUMPER_LOG_LEVEL", "INFO")
    config['DBDUMPER_QUERY'] = env.str("DBDUMPER_QUERY")
    config['DBDUMPER_BUCKET_PATH'] = env.str("DBDUMPER_BUCKET_PATH", "")
    config['DBDUMPER_BUCKET_FILE_BASE_NAME'] = env.str("DBDUMPER_BUCKET_FILE_BASE_NAME", "dump")
    config['DBDUMPER_BUCKET_NAME'] = env.str("DBDUMPER_BUCKET_NAME")
    config['DBDUMPER_DB_INSTANCE_NAME'] = env.str("DBDUMPER_DB_INSTANCE_NAME")
    config['DBDUMPER_DB_USER'] = env.str("DBDUMPER_DB_USER")
    config['DBDUMPER_DB_NAME'] = env.str("DBDUMPER_DB_NAME")


    # set up console log handler
    console = logging.StreamHandler()
    console.setLevel(getattr(logging, config['DBDUMPER_LOG_LEVEL']))
    formatter = logging.Formatter(LOGGING_FORMAT)
    console.setFormatter(formatter)
    # set up basic logging config
    logging.basicConfig(format=LOGGING_FORMAT, level=getattr(logging, config['DBDUMPER_LOG_LEVEL']), handlers=[console])

    logging.info(f'Config:\n{config}')
    logging.info(f'Backup started!')

    db = connect_with_connector()
    query = sqlalchemy.text(config['DBDUMPER_QUERY'])

    now = datetime.now(timezone.utc)
    bucket_blob_path = posixpath.join(config['DBDUMPER_BUCKET_PATH'],
                                    f'{config["DBDUMPER_BUCKET_FILE_BASE_NAME"]}-{now.strftime("%Y%m%d-%H%M%S")}.csv')
    storage_client = storage.Client()
    bucket = storage_client.bucket(config['DBDUMPER_BUCKET_NAME'])
    bucket_blob = bucket.blob(bucket_blob_path)

    with db.connect() as conn:
            q = conn.execution_options(stream_results=True, postgresql_readonly=True).execute(query)
            with bucket_blob.open("w") as f:
                csv_file = csv.writer(f)

                header=list(q.keys())
                csv_file.writerow(header)
                for record in q.all():
                    csv_file.writerow([getattr(record, c) for c in header])

    logging.info(f'Backup finished successfully!')
