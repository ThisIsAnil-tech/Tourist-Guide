import { useEffect, useState } from "react";
import client from "../api/client";
import DataTable from "../components/DataTable";
import HistogramChart from "../components/HistogramChart";
import LineChart from "../components/LineChart";
import BarChart from "../components/BarChart";
import Loader from "../components/Loader";
import EmptyState from "../components/EmptyState";

export default function TestResults() {
  const [results, setResults] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [modelFilter, setModelFilter] = useState("");

  useEffect(() => {
    async function load() {
      setIsLoading(true);
      const params = modelFilter ? { model_version: modelFilter } : {};
      const res = await client.get("/test-results", { params });
      setResults(res.data);
      setIsLoading(false);
    }
    load();
  }, [modelFilter]);

  if (isLoading) return <Loader />;

  const columns = [
    { key: "model_version", label: "Model Version" },
    { key: "predicted_class", label: "Predicted Class" },
    {
      key: "confidence",
      label: "Confidence",
      render: (row) => `${(row.confidence * 100).toFixed(1)}%`,
    },
    {
      key: "inference_time_ms",
      label: "Inference Time (ms)",
      render: (row) => row.inference_time_ms.toFixed(1),
    },
    {
      key: "created_at",
      label: "Timestamp",
      render: (row) => new Date(row.created_at).toLocaleString(),
    },
  ];

  const confidenceBuckets = buildConfidenceHistogram(results);
  const trendData = buildTrendData(results);
  const inferenceByDevice = buildInferenceByDevice(results);

  return (
    <div className="page">
      <h1 className="page-title">Model Test Results</h1>

      <div className="filter-row">
        <input
          className="field-input"
          placeholder="Filter by model version"
          value={modelFilter}
          onChange={(e) => setModelFilter(e.target.value)}
        />
      </div>

      <div className="chart-row">
        <div className="chart-card">
          <h3>Confidence Distribution</h3>
          <HistogramChart data={confidenceBuckets} />
        </div>
        <div className="chart-card">
          <h3>Confidence Trend</h3>
          <LineChart data={trendData} />
        </div>
      </div>

      <div className="chart-card full-width">
        <h3>Inference Time by Device</h3>
        <BarChart data={inferenceByDevice} yLabel="Avg ms" />
      </div>

      <div className="section-card">
        {results.length === 0 ? (
          <EmptyState message="No test results found." />
        ) : (
          <DataTable columns={columns} data={results} />
        )}
      </div>
    </div>
  );
}

function buildConfidenceHistogram(results) {
  const buckets = [0, 0, 0, 0, 0];
  results.forEach((r) => {
    const idx = Math.min(4, Math.floor(r.confidence * 5));
    buckets[idx] += 1;
  });
  return buckets.map((count, i) => ({
    name: `${i * 20}-${i * 20 + 20}%`,
    value: count,
  }));
}

function buildTrendData(results) {
  return [...results]
    .sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
    .map((r) => ({
      name: new Date(r.created_at).toLocaleDateString(),
      value: Math.round(r.confidence * 100),
    }));
}

function buildInferenceByDevice(results) {
  const grouped = {};
  results.forEach((r) => {
    const device = r.device_info?.model || "Unknown";
    if (!grouped[device]) grouped[device] = { total: 0, count: 0 };
    grouped[device].total += r.inference_time_ms;
    grouped[device].count += 1;
  });
  return Object.entries(grouped).map(([name, v]) => ({
    name,
    value: Math.round(v.total / v.count),
  }));
}