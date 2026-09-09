import { useEffect, useState } from "react";
import client from "../api/client";
import DataTable from "../components/DataTable";
import Loader from "../components/Loader";
import { useToast } from "../components/Toast";

export default function Responders() {
  const [responders, setResponders] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const { showToast } = useToast();

  async function loadResponders() {
    setIsLoading(true);
    const res = await client.get("/responders");
    setResponders(res.data);
    setIsLoading(false);
  }

  useEffect(() => {
    loadResponders();
  }, []);

  async function handleVerify(id) {
    try {
      await client.put(`/responders/${id}/verify`);
      showToast("Responder verified", "success");
      loadResponders();
    } catch (err) {
      showToast(err.response?.data?.error || "Failed to verify", "error");
    }
  }

  async function handleCreate(userId, org) {
    try {
      await client.post("/responders", { user_id: userId, org });
      showToast("Responder created", "success");
      setShowForm(false);
      loadResponders();
    } catch (err) {
      showToast(err.response?.data?.error || "Failed to create responder", "error");
    }
  }

  if (isLoading) return <Loader />;

  const columns = [
    { key: "org", label: "Organization" },
    {
      key: "verified",
      label: "Status",
      render: (row) => (
        <span className={`status-badge status-${row.verified ? "resolved" : "active"}`}>
          {row.verified ? "Verified" : "Pending"}
        </span>
      ),
    },
    {
      key: "assigned_events",
      label: "Assigned Events",
      render: (row) => row.assigned_events?.length || 0,
    },
    {
      key: "actions",
      label: "",
      render: (row) =>
        !row.verified && (
          <button className="btn btn-secondary btn-sm" onClick={() => handleVerify(row._id)}>
            Verify
          </button>
        ),
    },
  ];

  return (
    <div className="page">
      <div className="page-header-row">
        <h1 className="page-title">Responders</h1>
        <button className="btn btn-primary" onClick={() => setShowForm(!showForm)}>
          {showForm ? "Cancel" : "Add Responder"}
        </button>
      </div>

      {showForm && <ResponderForm onSubmit={handleCreate} />}

      <div className="section-card">
        <DataTable columns={columns} data={responders} />
      </div>
    </div>
  );
}

function ResponderForm({ onSubmit }) {
  const [userId, setUserId] = useState("");
  const [org, setOrg] = useState("");

  function handleSubmit(e) {
    e.preventDefault();
    onSubmit(userId, org);
  }

  return (
    <form className="section-card" onSubmit={handleSubmit}>
      <h3>New Responder</h3>
      <label className="field-label">User ID</label>
      <input className="field-input" value={userId} onChange={(e) => setUserId(e.target.value)} required />

      <label className="field-label">Organization</label>
      <input className="field-input" value={org} onChange={(e) => setOrg(e.target.value)} />

      <button type="submit" className="btn btn-primary">Create Responder</button>
    </form>
  );
}