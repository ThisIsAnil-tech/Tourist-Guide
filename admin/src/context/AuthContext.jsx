import { createContext, useContext, useState, useEffect, useCallback } from "react";
import client, { setTokens, clearTokens, setLogoutHandler } from "../api/client";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  const logout = useCallback(async () => {
    try {
      await client.post("/auth/logout");
    } catch {
      // logout endpoint failure should not block clearing local state
    }
    clearTokens();
    setUser(null);
  }, []);

  useEffect(() => {
    setLogoutHandler(logout);
    setIsLoading(false);
  }, [logout]);

  async function login(email, password) {
    const res = await client.post("/auth/login", { email, password });
    const { access_token, refresh_token } = res.data;
    setTokens(access_token, refresh_token);

    const meRes = await client.get("/users/me");
    if (meRes.data.role !== "admin") {
      clearTokens();
      throw new Error("Only admin accounts can access this dashboard");
    }

    setUser(meRes.data);
    return meRes.data;
  }

  const value = {
    user,
    isAuthenticated: !!user,
    isLoading,
    login,
    logout,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) {
    throw new Error("useAuth must be used within AuthProvider");
  }
  return ctx;
}