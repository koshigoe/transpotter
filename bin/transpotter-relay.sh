#!/bin/sh -eu

SOURCE=$1
DESTINATION=s3://$TRANSPOTTER_S3_BUCKET/$2

if [ ! -e "$SOURCE" ]; then
    echo "No such file: $SOURCE"
    exit 1
fi

aws s3 cp $SOURCE $DESTINATION

rm -f $SOURCE
