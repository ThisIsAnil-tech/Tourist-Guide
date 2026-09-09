import { useEffect, useState } from "react";
import client from "../api/client";
import KPICard from "../components/KPICard";
import PieChart from "../components/PieChart";
import BarChart from "../components/BarChart";
import OverviewMap from "../components/OverviewMap";
import Loader from "../components/Loader";

export default function Dashboard() {
  const [stats, setStats] = useState(null);
  const [activeEvents, setActiveEvents] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setIsLoading(true);
      const [statsRes, eventsRes] = await Promise.all([
        client.get("/admin/dashboard-stats"),
        client.get("/sos/active"),
      ]);
      setStats(statsRes.data);
      setActiveEvents(eventsRes.data);
      setIsLoading(false);
    }
    load();
  }, []);

  if (isLoading) return <Loader />;

  const deliveryData = (stats.delivery_breakdown || []).map((d) => ({
    name: d._id,
    value: d.count,
  }));

  const accuracyData = (stats.model_accuracy_by_version || []).map((d) => ({
    name: d._id,
    value: Math.round(d.avg_confidence * 100),
  }));

  return (
    <div className="page">
      <h1 className="page-title">Dashboard</h1>

      <div className="kpi-row">
        <KPICard label="Active SOS Events" value={stats.active_sos_count} highlight />
        <KPICard label="Registered Tourists" value={stats.total_users} />
        <KPICard label="Verified Responders" value={stats.total_responders} />
      </div>

      <div className="chart-row">
        <div className="chart-card">
          <h3>Delivery Tier Breakdown</h3>
          <PieChart data={deliveryData} />
        </div>
        <div className="chart-card">
          <h3>Model Accuracy by Version</h3>
          <BarChart data={accuracyData} yLabel="Avg Confidence %" />
        </div>
      </div>

      <div className="section-card">
        <h3>Live SOS Overview</h3>
        <OverviewMap events={activeEvents} />
      </div>
    </div>
  );
}