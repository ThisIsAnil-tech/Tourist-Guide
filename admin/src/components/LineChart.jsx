import { LineChart as ReLineChart, Line, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from "recharts";

export default function LineChart({ data }) {
  if (!data || data.length === 0) {
    return <p className="chart-empty">No data available.</p>;
  }

  return (
    <ResponsiveContainer width="100%" height={260}>
      <ReLineChart data={data}>
        <CartesianGrid strokeDasharray="3 3" stroke="#e5e5e5" />
        <XAxis dataKey="name" tick={{ fontSize: 12 }} />
        <YAxis tick={{ fontSize: 12 }} />
        <Tooltip />
        <Line type="monotone" dataKey="value" stroke="#2f6f6a" strokeWidth={2} dot={false} />
      </ReLineChart>
    </ResponsiveContainer>
  );
}