import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";
import L from "leaflet";
import markerIcon from "leaflet/dist/images/marker-icon.png";
import markerShadow from "leaflet/dist/images/marker-shadow.png";

const defaultIcon = L.icon({
  iconUrl: markerIcon,
  shadowUrl: markerShadow,
  iconSize: [25, 41],
  iconAnchor: [12, 41],
});

export default function OverviewMap({ events, onSelect }) {
  if (!events || events.length === 0) {
    return <p className="chart-empty">No active events to display.</p>;
  }

  const center = [events[0].location.lat, events[0].location.lon];

  return (
    <MapContainer center={center} zoom={10} className="map-container">
      <TileLayer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        attribution="&copy; OpenStreetMap contributors"
      />
      {events.map((event) => (
        <Marker
          key={event._id}
          position={[event.location.lat, event.location.lon]}
          icon={defaultIcon}
          eventHandlers={{
            click: () => onSelect && onSelect(event._id),
          }}
        >
          <Popup>
            {event.event_type} &mdash; {event.delivered_via}
          </Popup>
        </Marker>
      ))}
    </MapContainer>
  );
}