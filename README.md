<div align="center">

# 🛡️ Smart Tourist Safety & Incident Response System

**A connectivity-independent safety platform that detects distress automatically,
delivers SOS alerts through internet, SMS, and offline mesh relay, and protects
tourist identity with blockchain-gated access.**

*Project Phase I/II — Department of Artificial Intelligence & Machine Learning*

[![Backend](https://img.shields.io/badge/backend-FastAPI-2F6F6A?style=flat-square)](./backend)
[![Admin](https://img.shields.io/badge/admin-React-2F6F6A?style=flat-square)](./admin)
[![Mobile](https://img.shields.io/badge/mobile-Flutter-2F6F6A?style=flat-square)](./mobile)
[![Database](https://img.shields.io/badge/database-MongoDB-2F6F6A?style=flat-square)](#)
[![License](https://img.shields.io/badge/license-Academic-6B6F6D?style=flat-square)](#)

</div>

---

## 📖 Overview

Tourist safety in remote areas fails on three fronts: existing apps depend entirely
on internet connectivity, require the victim to consciously trigger an alert, and
store personal data on centralized servers with no user control.

This system solves all three by combining:

- 🎙️ **On-device AI** that listens for distress sounds without any server round-trip
- 📍 **GPS anomaly detection** that flags unusual immobility in high-risk zones
- 📡 **Three-tier communication fallback** — Internet → SMS → Peer-to-peer Mesh Relay
- 🔒 **Blockchain-gated identity** — locked by default, unlocked only for a verified responder during an active emergency
- 🌦️ **Dynamic risk scoring** — weather and news-driven zone risk that adapts detection sensitivity in real time

---

## 🏗️ System Architecture

```
                         ┌─────────────────────────┐
                         │   Flutter Mobile App    │
                         │  (iOS + Android + Web)  │
                         │                         │
                         │  Audio AI • GPS Monitor │
                         │  SOS Pipeline • Mesh    │
                         └────────────┬────────────┘
                                      │
                    Internet ─────────┼───────── SMS ─────────── Mesh Relay
                                      │
                         ┌────────────▼─────────────┐
                         │     FastAPI Backend      │
                         │                          │
                         │  Auth • SOS • Identity   │
                         │  Zones • Risk Engine     │
                         └──┬──────────┬──────────┬─┘
                            │          │          │
                     ┌──────▼───┐ ┌────▼────┐ ┌───▼──────┐
                     │ MongoDB  │ │  Redis  │ │  Mega.nz │
                     │  (data)  │ │ (rate-  │ │  (files/ │
                     │          │ │  limit) │ │  backups)│
                     └──────────┘ └─────────┘ └──────────┘
                            │
                         ┌──▼───────────────────────┐
                         │   React Admin Dashboard  │
                         │                          │
                         │  Live SOS • Analytics    │
                         │  Zones • Responders      │
                         └──────────────────────────┘
```

---

## 📦 Repository Structure

```
tourist-safety/
├── backend/     FastAPI + MongoDB + Redis — REST API, SOS pipeline, risk engine
├── admin/       React admin dashboard — live monitoring, analytics, management
├── mobile/      Flutter mobile app — tourist-facing iOS/Android/Web app
└── docker-compose.yml   Runs all three services together
```

Each folder has its own `README.md` and `run.txt` with component-specific setup details.

---

## 🚀 Quick Start

### Run everything with Docker

```bash
git clone <repo-url> tourist-safety
cd tourist-safety
docker-compose up --build
```

| Service | URL |
|---|---|
| 🔧 Backend API + Swagger Docs | http://localhost:8000/docs |
| 📊 Admin Dashboard | http://localhost:5173 |
| 📱 Mobile App (web preview) | http://localhost:8081 |

> **Note:** The mobile web build is for UI/demo purposes only — native features
> (background audio detection, Bluetooth mesh relay, SMS) require running on a
> real device or emulator via `flutter run`. See [`mobile/run.txt`](./mobile/run.txt).

### Create your first admin account

```bash
docker-compose exec backend python -m scripts.seed_admin
```

---

## 🧩 Core Modules

| Module | Description |
|---|---|
| **Audio Distress Classifier** | TensorFlow Lite model detecting screams and glass-break sounds entirely on-device |
| **GPS Anomaly Detector** | Haversine-based stillness detection with counter debouncing, adaptive to zone risk |
| **Multi-Tier SOS Pipeline** | Internet → SMS → Mesh, automatic fallback with no manual switching |
| **Blockchain Identity Layer** | Locked/unlocked access control, released only during a verified active SOS |
| **Dynamic Risk Engine** | Weather + news-driven scoring, recalculated every 15 minutes per zone |

---

## 🛠️ Tech Stack

<table>
<tr>
<td valign="top" width="33%">

**Backend**
- FastAPI
- MongoDB + Motor
- Redis
- Mega.nz
- Twilio
- APScheduler
- web3.py

</td>
<td valign="top" width="33%">

**Admin Dashboard**
- React + Vite
- Recharts
- React-Leaflet
- Axios

</td>
<td valign="top" width="33%">

**Mobile App**
- Flutter
- TensorFlow Lite
- Provider + go_router
- Nearby Connections
- Google Maps

</td>
</tr>
</table>

---

## 🔐 Security

This project follows a five-pass security review across every layer:

1. Secret leak prevention — no hardcoded credentials, `.env`-only secrets
2. Personal data flow audit — PII redaction in logs, hashed passwords, field-filtered API responses
3. Pre-deploy production checks — rate limiting, security headers, CORS restrictions
4. Deep auth/authorization audit — IDOR checks, role-gated endpoints, ownership verification
5. Attacker's-perspective review — token blacklisting, no default admin accounts, gated Swagger docs in production

See [`backend/README.md`](./backend/README.md) for details.

---

## 📚 Documentation

- [`backend/README.md`](./backend/README.md) — API setup, endpoints, environment variables
- [`admin/README.md`](./admin/README.md) — Dashboard setup and feature guide
- [`mobile/README.md`](./mobile/README.md) — Mobile app setup, permissions, build instructions

---

<div align="center">

**Smart Tourist Safety & Incident Response System**
*Department of Artificial Intelligence & Machine Learning*

</div>