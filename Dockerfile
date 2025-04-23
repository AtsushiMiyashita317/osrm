FROM osrm/osrm-backend

# 必要なデータをダウンロード（ここでwget）
RUN wget https://download.geofabrik.de/asia/japan/kanto-latest.osm.pbf -O /data/map.osm.pbf

# OSRMデータ作成
RUN osrm-extract -p /opt/car.lua /data/map.osm.pbf && \
    osrm-partition /data/map.osrm && \
    osrm-customize /data/map.osrm

# OSRMサーバ起動
CMD ["osrm-routed", "--algorithm", "mld", "/data/map.osrm"]
