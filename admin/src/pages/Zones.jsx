import { useEffect, useState } from "react";
import client from "../api/client";
import ZonesMap from "../components/ZonesMap";
import DataTable from "../components/DataTable";
import Loader from "../components/Loader";
import { useToast } from "../components/Toast";

export default function Zones() {
  const [zones, setZones] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const { showToast } = useToast();

  async function loadZones() {
    setIsLoading(true);
    const res = await client.get("/zones");
    setZones(res.data);
    setIsLoading(false);
  }

  useEffect(() => {
    loadZones();
  }, []);

  async function handleCreate(zone) {
    try {
      await client.post("/zones", zone);
      showToast("Zone created", "success");
      setShowForm(false);
      loadZones();
    } catch (err) {
      showToast(err.response?.data?.error || "Failed to create zone", "error");
    }
  }

  if (isLoading) return <Loader />;

  const columns = [
    { key: "name", label: "Name" },
    { key: "risk_score", label: "Risk Score" },
    {
      key: "last_updated",
      label: "Last Updated",
      render: (row) => new Date(row.last_updated).toLocaleString(),
    },
  ];

  return (
    <div className="page">
      <div className="page-header-row">
        <h1 className="page-title">Risk Zones</h1>
        <button className="btn btn-primary" onClick={() => setShowForm(!showForm)}>
          {showForm ? "Cancel" : "Add Zone"}
        </button>
      </div>

      {showForm && <ZoneForm onSubmit={handleCreate} />}

      <div className="section-card">
        <ZonesMap zones={zones} />
      </div>

      <div className="section-card">
        <DataTable columns={columns} data={zones} />
      </div>
    </div>
  );
}

function ZoneForm({ onSubmit }) {
  const [name, setName] = useState("");
  const [lat, setLat] = useState("");
  const [lon, setLon] = useState("");
  const [riskScore, setRiskScore] = useState(1);
  const [keywords, setKeywords] = useState("");

  function handleSubmit(e) {
    e.preventDefault();
    const latNum = parseFloat(lat);
    const lonNum = parseFloat(lon);
    const delta = 0.01;
    onSubmit({
      name,
      coordinates: { lat: latNum, lon: lonNum },
      polygon: {
        type: "Polygon",
        coordinates: [[
          [lonNum - delta, latNum - delta],
          [lonNum + delta, latNum - delta],
          [lonNum + delta, latNum + delta],
          [lonNum - delta, latNum + delta],
          [lonNum - delta, latNum - delta],
        ]],
      },
      region_keywords: keywords.split(",").map((k) => k.trim()).filter(Boolean),
      risk_score: parseFloat(riskScore),
    });
  }

  return (
    <form className="section-card" onSubmit={handleSubmit}>
      <h3>New Zone</h3>
      <label className="field-label">Name</label>
      <input className="field-input" value={name} onChange={(e) => setName(e.target.value)} required />

      <div className="form-row">
        <div>
          <label className="field-label">Latitude</label>
          <input className="field-input" value={lat} onChange={(e) => setLat(e.target.value)} required />
        </div>
        <div>
          <label className="field-label">Longitude</label>
          <input className="field-input" value={lon} onChange={(e) => setLon(e.target.value)} required />
        </div>
      </div>

      <label className="field-label">Initial Risk Score (1-10)</label>
      <input
        type="number"
        min="1"
        max="10"
        className="field-input"
        value={riskScore}
        onChange={(e) => setRiskScore(e.target.value)}
      />

      <label className="field-label">Region Keywords (comma separated)</label>
      <input className="field-input" value={keywords} onChange={(e) => setKeywords(e.target.value)} />

      <button type="submit" className="btn btn-primary">Create Zone</button>
    </form>
  );
}