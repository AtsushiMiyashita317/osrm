FROM debian:bullseye as downloader

RUN apt-get update && apt-get install -y wget

# 東京都PBFデータ取得
RUN wget https://download.geofabrik.de/asia/japan/kanto/tokyo-latest.osm.pbf -O /tokyo.osm.pbf

FROM osrm/osrm-backend

COPY --from=downloader /tokyo.osm.pbf /data/map.osm.pbf

RUN osrm-extract -p /opt/car.lua /data/map.osm.pbf && \
    osrm-partition /data/map.osrm && \
    osrm-customize /data/map.osrm

CMD ["osrm-routed", "--algorithm", "mld", "/data/map.osrm"]
