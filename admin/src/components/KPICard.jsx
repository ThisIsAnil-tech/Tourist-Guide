export default function KPICard({ label, value, highlight }) {
  return (
    <div className={`kpi-card ${highlight ? "kpi-card-highlight" : ""}`}>
      <span className="kpi-value">{value}</span>
      <span className="kpi-label">{label}</span>
    </div>
  );
}