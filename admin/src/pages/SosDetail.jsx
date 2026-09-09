import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import client from "../api/client";
import SosMap from "../components/SosMap";
import Loader from "../components/Loader";
import ConfirmModal from "../components/ConfirmModal";
import { useToast } from "../components/Toast";

export default function SosDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { showToast } = useToast();

  const [event, setEvent] = useState(null);
  const [identity, setIdentity] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [confirmAction, setConfirmAction] = useState(null);

  async function loadEvent() {
    const res = await client.get(`/sos/${id}`);
    setEvent(res.data);
  }

  useEffect(() => {
    async function init() {
      setIsLoading(true);
      await loadEvent();
      setIsLoading(false);
    }
    init();
  }, [id]);

  async function handleGrantAccess() {
    try {
      const res = await client.post(`/identity/grant-access/${id}`);
      setIdentity(res.data);
      showToast("Identity access granted", "success");
    } catch (err) {
      showToast(err.response?.data?.error || "Failed to grant access", "error");
    }
  }

  async function handleRevokeAccess() {
    try {
      await client.post(`/identity/revoke-access/${id}`);
      setIdentity(null);
      showToast("Identity access revoked", "success");
    } catch (err) {
      showToast(err.response?.data?.error || "Failed to revoke access", "error");
    }
  }

  async function handleResolve() {
    try {
      await client.put(`/sos/${id}/resolve`);
      showToast("Event marked as resolved", "success");
      await loadEvent();
    } catch (err) {
      showToast(err.response?.data?.error || "Failed to resolve event", "error");
    }
    setConfirmAction(null);
  }

  if (isLoading) return <Loader />;
  if (!event) return <div className="page">Event not found.</div>;

  const directionsUrl = `https://www.google.com/maps/dir/?api=1&destination=${event.location.lat},${event.location.lon}`;

  return (
    <div className="page">
      <button className="btn btn-secondary btn-sm" onClick={() => navigate(-1)}>
        &larr; Back
      </button>

      <h1 className="page-title">SOS Event Detail</h1>

      <div className="detail-grid">
        <div className="section-card">
          <h3>Event Info</h3>
          <dl className="detail-list">
            <dt>Type</dt>
            <dd>{event.event_type}</dd>
            <dt>Status</dt>
            <dd>
              <span className={`status-badge status-${event.status}`}>{event.status}</span>
            </dd>
            <dt>Delivered Via</dt>
            <dd>{event.delivered_via}</dd>
            <dt>Triggered At</dt>
            <dd>{new Date(event.created_at).toLocaleString()}</dd>
            {event.resolved_at && (
              <>
                <dt>Resolved At</dt>
                <dd>{new Date(event.resolved_at).toLocaleString()}</dd>
              </>
            )}
          </dl>

          <div className="btn-group">
            <a href={directionsUrl} target="_blank" rel="noreferrer" className="btn btn-secondary">
              Get Directions
            </a>
            {event.status === "active" && (
              <button className="btn btn-danger" onClick={() => setConfirmAction("resolve")}>
                Mark Resolved
              </button>
            )}
          </div>
        </div>

        <div className="section-card">
          <h3>Location</h3>
          <SosMap location={event.location} />
        </div>
      </div>

      <div className="section-card">
        <h3>Tourist Identity</h3>
        {identity ? (
          <>
            <dl className="detail-list">
              <dt>Name</dt>
              <dd>{identity.name}</dd>
              <dt>Phone</dt>
              <dd>{identity.phone}</dd>
              <dt>Medical Info</dt>
              <dd>{JSON.stringify(identity.medical_info)}</dd>
              <dt>Emergency Contacts</dt>
              <dd>
                {identity.emergency_contacts.map((c, i) => (
                  <div key={i}>
                    {c.name} &mdash; {c.phone}
                  </div>
                ))}
              </dd>
            </dl>
            <button className="btn btn-secondary" onClick={handleRevokeAccess}>
              Revoke Access
            </button>
          </>
        ) : (
          <button className="btn btn-primary" onClick={handleGrantAccess}>
            Unlock Identity
          </button>
        )}
      </div>

      {event.origin_meta?.relay_chain?.length > 0 && (
        <div className="section-card">
          <h3>Mesh Relay Chain</h3>
          <p>Hops: {event.origin_meta.hop_count}</p>
          <ol>
            {event.origin_meta.relay_chain.map((deviceId, i) => (
              <li key={i}>{deviceId}</li>
            ))}
          </ol>
        </div>
      )}

      {confirmAction === "resolve" && (
        <ConfirmModal
          title="Resolve this event?"
          message="This will mark the SOS event as resolved and revoke any active identity access."
          onConfirm={handleResolve}
          onCancel={() => setConfirmAction(null)}
        />
      )}
    </div>
  );
}