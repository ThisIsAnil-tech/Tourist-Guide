import { BarChart as ReBarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from "recharts";

export default function BarChart({ data, yLabel }) {
  if (!data || data.length === 0) {
    return <p className="chart-empty">No data available.</p>;
  }

  return (
    <ResponsiveContainer width="100%" height={260}>
      <ReBarChart data={data}>
        <CartesianGrid strokeDasharray="3 3" stroke="#e5e5e5" />
        <XAxis dataKey="name" tick={{ fontSize: 12 }} />
        <YAxis tick={{ fontSize: 12 }} label={{ value: yLabel, angle: -90, position: "insideLeft" }} />
        <Tooltip />
        <Bar dataKey="value" fill="#2f6f6a" radius={[4, 4, 0, 0]} />
      </ReBarChart>
    </ResponsiveContainer>
  );
}