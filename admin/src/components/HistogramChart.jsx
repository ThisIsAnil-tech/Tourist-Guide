import BarChart from "./BarChart";

export default function HistogramChart({ data }) {
  return <BarChart data={data} yLabel="Count" />;
}