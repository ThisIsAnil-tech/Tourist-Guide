import { useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export default function Topbar() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  async function handleLogout() {
    await logout();
    navigate("/login");
  }

  return (
    <header className="topbar">
      <span className="topbar-user">{user?.name}</span>
      <button className="btn btn-secondary btn-sm" onClick={handleLogout}>
        Logout
      </button>
    </header>
  );
}