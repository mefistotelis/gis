#!/bin/bash
#set -x

# Log in to the service, view the map within it, then use "Export cookies" plugin to create cookies.txt.
sessionid=$(sed -n 's/^interop[.]doplaty[.]gov[.]pl	.*	\/lids\/browser	.*	JSESSIONID	\(.*\)$/\1/p' cookies.txt | tr -d '\r\n')

for z in {7..7}; do
  for x in {8..1219}; do # whole width of poland
    mkdir -p "tms_ortofotomapa/${z}/${x}"
    for y in {952..2182}; do # whole height of poland
      fname="tms_ortofotomapa/${z}/${x}/${y}.png"
      if [ -f "${fname}" ]; then
        if file "${fname}" | grep -q ' image data,'; then
          echo "${fname}: Image already exists"
          continue
        else
          echo "${fname}: File exists but DAMAGED"
        fi
      fi
      curl \
        -A "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3" \
        --cookie cookies.txt "https://interop.doplaty.gov.pl/lids/browser/proxy/TileMapService/tms_ortofotomapa/${z}/${x}/${y}.png;jsessionid=${sessionid}?" \
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
