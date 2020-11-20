#!/bin/bash
# This script downloads a whole ortophoto map from Polish agricultular maps
# The maps are only available for registered farmers, who have login to the
# direct subsides application system.
# Usage:
# Log in to the service, view the map within it, then use "Export cookies"
# plugin to create cookies-*.txt. Rename the cookie file and place with
# this script. The whole map of Poland will get downloaded.
# Make sure you have a lot of free disk space. You can also narrow down
# the x and y range to download only a chunk of the whole map.

#set -x

for z in {13..13}; do
  for x in {1250..6804}; do # whole width of poland
    mkdir -p "wmts_ortofotomapa/${z}/${x}"
    for y in {2121..7254}; do # whole height of poland
      fname="wmts_ortofotomapa/${z}/${x}/${y}.png"
      if [ -f "${fname}" ]; then
        if file "${fname}" | grep -q ' image data,'; then
          echo "${fname}: Image already exists"
          continue
        else
          echo "${fname}: File exists but DAMAGED"
        fi
      fi
      curl --insecure \
        -A "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3" \
        --cookie cookies-2020.txt "https://ewniosek.arimr.gov.pl/lpis/ortofotomapa/gwc/service/wmts?layer=arimr%3Aortofotomapa&tilematrixset=EPSG%3A2180&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image%2Fjpeg&TileMatrix=EPSG%3A2180%3A${z}&TileCol=${x}&TileRow=${y}" \
        > "${fname}"
        fsize=$(wc -c <"${fname}")
      if [ "${fsize}" -lt "256" ]; then
          if file "${fname}" | grep -q ' image data,'; then
            echo "${fname}: File is empty image"
          else
            echo "${fname}: File is NOT image"
            cat "${fname}"
            rm "${fname}"
            exit 1
          fi
      else
          echo "${fname}: Image OK"
      fi
    done
  done
done

exit 0
