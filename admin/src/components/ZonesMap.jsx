import { MapContainer, TileLayer, Polygon, Tooltip } from "react-leaflet";

function riskColor(score) {
  if (score >= 7) return "#c0392b";
  if (score >= 4) return "#d97b66";
  return "#2f6f6a";
}

export default function ZonesMap({ zones }) {
  if (!zones || zones.length === 0) {
    return <p className="chart-empty">No zones to display.</p>;
  }

  const center = [zones[0].coordinates.lat, zones[0].coordinates.lon];

  return (
    <MapContainer center={center} zoom={11} className="map-container">
      <TileLayer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        attribution="&copy; OpenStreetMap contributors"
      />
      {zones.map((zone) => {
        const coords = zone.polygon?.coordinates?.[0] || [];
        const positions = coords.map(([lon, lat]) => [lat, lon]);
        return (
          <Polygon
            key={zone._id}
            positions={positions}
            pathOptions={{ color: riskColor(zone.risk_score), fillOpacity: 0.35 }}
          >
            <Tooltip>
              {zone.name} &mdash; Risk: {zone.risk_score}
            </Tooltip>
          </Polygon>
        );
      })}
    </MapContainer>
  );
}