import { useEffect, useState } from "react";
import client from "../api/client";
import DataTable from "../components/DataTable";
import Loader from "../components/Loader";
import EmptyState from "../components/EmptyState";

export default function Tourists() {
  const [users, setUsers] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState("");

  useEffect(() => {
    async function load() {
      setIsLoading(true);
      const res = await client.get("/users", { params: { search } });
      setUsers(res.data);
      setIsLoading(false);
    }
    load();
  }, [search]);

  if (isLoading) return <Loader />;

  const columns = [
    { key: "name", label: "Name" },
    { key: "email", label: "Email" },
    { key: "phone", label: "Phone" },
    {
      key: "identity_status",
      label: "Identity",
      render: (row) => (
        <span className={`status-badge status-${row.identity_status}`}>
          {row.identity_status}
        </span>
      ),
    },
    {
      key: "created_at",
      label: "Registered",
      render: (row) => new Date(row.created_at).toLocaleDateString(),
    },
  ];

  return (
    <div className="page">
      <h1 className="page-title">Tourists</h1>

      <div className="filter-row">
        <input
          className="field-input"
          placeholder="Search by name, email, or phone"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
      </div>

      <div className="section-card">
        {users.length === 0 ? (
          <EmptyState message="No tourists found." />
        ) : (
          <DataTable columns={columns} data={users} />
        )}
      </div>
    </div>
  );
}