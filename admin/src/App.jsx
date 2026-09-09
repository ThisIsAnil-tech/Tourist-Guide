import { Routes, Route } from "react-router-dom";
import Home from "./pages/Home";
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import SosList from "./pages/SosList";
import SosDetail from "./pages/SosDetail";
import TestResults from "./pages/TestResults";
import Zones from "./pages/Zones";
import Tourists from "./pages/Tourists";
import Responders from "./pages/Responders";
import Settings from "./pages/Settings";
import NotFound from "./pages/NotFound";
import DashboardLayout from "./layouts/DashboardLayout";
import ProtectedRoute from "./routes/ProtectedRoute";

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/login" element={<Login />} />

      <Route
        element={
          <ProtectedRoute>
            <DashboardLayout />
          </ProtectedRoute>
        }
      >
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/sos" element={<SosList />} />
        <Route path="/sos/:id" element={<SosDetail />} />
        <Route path="/test-results" element={<TestResults />} />
        <Route path="/zones" element={<Zones />} />
        <Route path="/tourists" element={<Tourists />} />
        <Route path="/responders" element={<Responders />} />
        <Route path="/settings" element={<Settings />} />
      </Route>

      <Route path="*" element={<NotFound />} />
    </Routes>
  );
}