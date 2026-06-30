CREATE FILE FORMAT IF NOT EXISTS csv_format
  TYPE = 'CSV' 
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

SHOW FILE FORMATS;

CREATE OR REPLACE STAGE snowstage
FILE_FORMAT = csv_format
URL='your_s3_bucket_path';
    
SHOW STAGES;

COPY INTO BOOKINGS
FRoM @snowstage
FILES=('bookings.csv')
CREDENTIALS=(aws_key_id = 'yourkey', aws_secret_key = 'yoursecretkey');

COPY INTO LISTINGS
FRoM @snowstage
FILES=('listings.csv')
CREDENTIALS=(aws_key_id = 'yourkey', aws_secret_key = 'yoursecretkey');

COPY INTO HOSTS
FRoM @snowstage
FILES=('hosts.csv')
CREDENTIALS=(aws_key_id = 'yourkey', aws_secret_key = 'yoursecretkey');

SELECT * FROM BOOKINGS;
SELECT * FROM LISTINGS;
SELECT * FROM HOSTS;

--You can get your credentials by going to aws and create an IAM user (Make sure to attach policies directly (s3fullaccess))

