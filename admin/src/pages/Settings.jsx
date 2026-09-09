import { useState, useEffect } from "react";
import client from "../api/client";
import { useToast } from "../components/Toast";
import Loader from "../components/Loader";

export default function Settings() {
  return (
    <div className="page">
      <h1 className="page-title">Settings</h1>
      <ChangePasswordSection />
      <AddAdminSection />
      <AuditLogSection />
    </div>
  );
}

function ChangePasswordSection() {
  const { showToast } = useToast();
  const [oldPassword, setOldPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");

  async function handleSubmit(e) {
    e.preventDefault();
    try {
      await client.put("/auth/change-password", {
        old_password: oldPassword,
        new_password: newPassword,
      });
      showToast("Password updated", "success");
      setOldPassword("");
      setNewPassword("");
    } catch (err) {
      showToast(err.response?.data?.error || "Failed to change password", "error");
    }
  }

  return (
    <form className="section-card" onSubmit={handleSubmit}>
      <h3>Change Password</h3>
      <label className="field-label">Current Password</label>
      <input
        type="password"
        className="field-input"
        value={oldPassword}
        onChange={(e) => setOldPassword(e.target.value)}
        required
      />
      <label className="field-label">New Password</label>
      <input
        type="password"
        className="field-input"
        value={newPassword}
        onChange={(e) => setNewPassword(e.target.value)}
        required
      />
      <button type="submit" className="btn btn-primary">Update Password</button>
    </form>
  );
}

function AddAdminSection() {
  const { showToast } = useToast();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [password, setPassword] = useState("");

  async function handleSubmit(e) {
    e.preventDefault();
    try {
      await client.post("/admin/create-admin", { name, email, phone, password });
      showToast("Admin account created", "success");
      setName("");
      setEmail("");
      setPhone("");
      setPassword("");
    } catch (err) {
      showToast(err.response?.data?.error || "Failed to create admin", "error");
    }
  }

  return (
    <form className="section-card" onSubmit={handleSubmit}>
      <h3>Add New Admin</h3>
      <label className="field-label">Name</label>
      <input className="field-input" value={name} onChange={(e) => setName(e.target.value)} required />
      <label className="field-label">Email</label>
      <input type="email" className="field-input" value={email} onChange={(e) => setEmail(e.target.value)} required />
      <label className="field-label">Phone</label>
      <input className="field-input" value={phone} onChange={(e) => setPhone(e.target.value)} required />
      <label className="field-label">Temporary Password</label>
      <input type="password" className="field-input" value={password} onChange={(e) => setPassword(e.target.value)} required />
      <button type="submit" className="btn btn-primary">Create Admin</button>
    </form>
  );
}

function AuditLogSection() {
  const [logs, setLogs] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setIsLoading(true);
      const res = await client.get("/identity/access-log");
      setLogs(res.data);
      setIsLoading(false);
    }
    load();
  }, []);

  return (
    <div className="section-card">
      <h3>Identity Access Audit Log</h3>
      {isLoading ? (
        <Loader />
      ) : logs.length === 0 ? (
        <p>No access log entries yet.</p>
      ) : (
        <table className="data-table">
          <thead>
            <tr>
              <th>Event ID</th>
              <th>Responder ID</th>
              <th>Action</th>
              <th>Timestamp</th>
            </tr>
          </thead>
          <tbody>
            {logs.map((log, i) => (
              <tr key={i}>
                <td>{log.event_id}</td>
                <td>{log.responder_id}</td>
                <td>{log.action}</td>
                <td>{new Date(log.timestamp).toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}