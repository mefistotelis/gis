#!/bin/bash
# Make maps from ewniosek.arimr.gov.pl WMTS service
# Note that only farmers can request access to the source WMTS server

set -x

function dl_ortophoto_image {
  n=0
  cd "./merged_maps_ortophoto"
  if [ -f "${OUTFILE}" ]; then
    echo "File ${OUTFILE} already exists"
    cd ..
    return
  fi
  while [ ! -f "${OUTFILE}" ]; do
    echo "File ${OUTFILE}, retry: $n"
    GDAL_HTTP_HEADER_FILE=cookies-2020-header.txt gdal_translate -of GTiff -projwin ${SRS_topleft} ${SRS_btmrght} -tr ${RES} ${RES} ../gdal-doplaty_2020-orto_std-web.xml  "${OUTFILE}"
    n=$[n + 1]
    break
  done
  cd ..
}

mkdir -p  "./merged_maps_ortophoto"

# Parse Netscape cookie file; fields: domain access_flag  path secure expiration name value
COOKIE_NAM=$(sed -n 's/^\(ewniosek.arimr.gov.pl\)[ \t]\+\(FALSE\|TRUE\)[ \t]\+\([0-9a-zA-Z._\/-]\+\)[ \t]\+\(FALSE\|TRUE\)[ \t]\+\([0-9]\+\)[ \t]\+\([0-9A-Za-z._-]\+\)[ \t]\+\(.*\)$/\6/p' cookies-2020.txt)
COOKIE_VAL=$(sed -n 's/^\(ewniosek.arimr.gov.pl\)[ \t]\+\(FALSE\|TRUE\)[ \t]\+\([0-9a-zA-Z._\/-]\+\)[ \t]\+\(FALSE\|TRUE\)[ \t]\+\([0-9]\+\)[ \t]\+\([0-9A-Za-z._-]\+\)[ \t]\+\(.*\)$/\7/p' cookies-2020.txt)
# Create cookie file accepted by GDAL
echo "Cookie: ${COOKIE_NAM}=${COOKIE_VAL}" > merged_maps_ortophoto/cookies-2020-header.txt

RES=0.25

OUTFILE="brzeg_lewy_test5.tif"
SRS_topleft="172200 564500"
SRS_btmrght="172500 564160"
dl_ortophoto_image

OUTFILE="brzeg_prawy_test5.tif"
SRS_topleft="861000 345200"
SRS_btmrght="861360 344950"
dl_ortophoto_image

OUTFILE="brzeg_gorny_test5.tif"
SRS_topleft="456350 774540"
SRS_btmrght="456600 774340"
dl_ortophoto_image

OUTFILE="brzeg_dolny_test5.tif"
SRS_topleft="782650 135750"
SRS_btmrght="782800 135550"
dl_ortophoto_image

OUTFILE="brzeg_lewydolny_test5.tif"
SRS_topleft="206900 343700"
SRS_btmrght="207150 343550"
dl_ortophoto_image

OUTFILE="brzeg_lewygorny_test5.tif"
SRS_topleft="187600 683100"
SRS_btmrght="188100 682850"
dl_ortophoto_image

OUTFILE="brzeg_prawygorny_test5.tif"
SRS_topleft="759600 731460"
SRS_btmrght="759990 731300"
dl_ortophoto_image

exit 0

RES=100
OUTFILE="whole_poland_test5.tif"
SRS_topleft="172200 774540"
#SRS_btmrght="759990 135550"
SRS_btmrght="861300 135550"
dl_ortophoto_image

exit 0
