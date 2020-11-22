#!/bin/bash
# Download maps from geoportal
# Xml file: It should be easy to find a correct xml file on the net;
# within the xml, the best tile size is currently 512x512
# Note that coords from Geoportal needs to be switched - "Y X" instead of "X Y"

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
    gdal_translate -of GTiff -projwin ${SRS_topleft} ${SRS_btmrght} -tr ${RES} ${RES} ../gdal-geop_public-orto_std-web.xml  "${OUTFILE}"
    n=$[n + 1]
    break
  done
  cd ..
}

mkdir -p  "./merged_maps_ortophoto"

RES=0.1

OUTFILE="brzeg_lewy_test1.tif"
SRS_topleft="172200 564500"
SRS_btmrght="172500 564160"
dl_ortophoto_image

OUTFILE="brzeg_prawy_test1.tif"
SRS_topleft="861000 345200"
SRS_btmrght="861360 344950"
dl_ortophoto_image

OUTFILE="brzeg_gorny_test1.tif"
SRS_topleft="456350 774540"
SRS_btmrght="456600 774340"
dl_ortophoto_image

OUTFILE="brzeg_dolny_test1.tif"
SRS_topleft="782650 135750"
SRS_btmrght="782800 135550"
dl_ortophoto_image

OUTFILE="brzeg_lewydolny_test1.tif"
SRS_topleft="206900 343700"
SRS_btmrght="207150 343550"
dl_ortophoto_image

OUTFILE="brzeg_lewygorny_test1.tif"
SRS_topleft="187600 683100"
SRS_btmrght="188100 682850"
dl_ortophoto_image

OUTFILE="brzeg_prawygorny_test1.tif"
SRS_topleft="759600 731460"
SRS_btmrght="759990 731300"
dl_ortophoto_image

RES=100
OUTFILE="whole_poland_test1.tif"
SRS_topleft="172200 774540"
#SRS_btmrght="759990 135550"
SRS_btmrght="861300 135550"
dl_ortophoto_image

exit 0
