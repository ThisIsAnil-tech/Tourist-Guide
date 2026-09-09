import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import client from "../api/client";
import DataTable from "../components/DataTable";
import OverviewMap from "../components/OverviewMap";
import Loader from "../components/Loader";
import EmptyState from "../components/EmptyState";

export default function SosList() {
  const [events, setEvents] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    async function load() {
      setIsLoading(true);
      const res = await client.get("/sos/active");
      setEvents(res.data);
      setIsLoading(false);
    }
    load();
  }, []);

  if (isLoading) return <Loader />;

  const columns = [
    { key: "event_type", label: "Type" },
    { key: "delivered_via", label: "Delivered Via" },
    { key: "status", label: "Status" },
    {
      key: "created_at",
      label: "Triggered At",
      render: (row) => new Date(row.created_at).toLocaleString(),
    },
  ];

  return (
    <div className="page">
      <h1 className="page-title">Active SOS Events</h1>

      <div className="section-card">
        <OverviewMap events={events} onSelect={(id) => navigate(`/sos/${id}`)} />
      </div>

      <div className="section-card">
        {events.length === 0 ? (
          <EmptyState message="No active SOS events right now." />
        ) : (
          <DataTable
            columns={columns}
            data={events}
            onRowClick={(row) => navigate(`/sos/${row._id}`)}
          />
        )}
      </div>
    </div>
  );
}