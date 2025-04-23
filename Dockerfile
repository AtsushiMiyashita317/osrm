# ステージ1: データ取得用（wget入りのDebianベース）
FROM debian:bullseye as downloader

RUN apt-get update && apt-get install -y wget
RUN wget https://download.geofabrik.de/asia/japan/kanto-latest.osm.pbf -O /map.osm.pbf

# ステージ2: OSRMビルド
FROM osrm/osrm-backend

COPY --from=downloader /map.osm.pbf /data/map.osm.pbf

RUN osrm-extract -p /opt/car.lua /data/map.osm.pbf && \
    osrm-partition /data/map.osrm && \
    osrm-customize /data/map.osrm

CMD ["osrm-routed", "--algorithm", "mld", "/data/map.osrm"]
