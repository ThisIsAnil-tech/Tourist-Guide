import { PieChart as RePieChart, Pie, Cell, Tooltip, Legend, ResponsiveContainer } from "recharts";

const COLORS = ["#2f6f6a", "#d97b66", "#3f5f7a", "#8a8f6e"];

export default function PieChart({ data }) {
  if (!data || data.length === 0) {
    return <p className="chart-empty">No data available.</p>;
  }

  return (
    <ResponsiveContainer width="100%" height={260}>
      <RePieChart>
        <Pie data={data} dataKey="value" nameKey="name" outerRadius={90}>
          {data.map((_, i) => (
            <Cell key={i} fill={COLORS[i % COLORS.length]} />
          ))}
        </Pie>
        <Tooltip />
        <Legend />
      </RePieChart>
    </ResponsiveContainer>
  );
}