import { Link } from "react-router-dom";

export default function Home() {
  return (
    <div className="home-page">
      <header className="home-hero">
        <div className="home-hero-inner">
          <span className="home-badge">Project Phase I &mdash; AI &amp; ML</span>
          <h1>Smart Tourist Safety &amp; Incident Response System</h1>
          <p className="home-tagline">
            A connectivity-independent safety platform that detects distress
            automatically, delivers SOS alerts through internet, SMS, and
            offline mesh relay, and protects tourist identity with
            blockchain-gated access.
          </p>
          <Link to="/login" className="btn btn-primary btn-lg">
            Admin Login
          </Link>
        </div>
      </header>

      <section className="home-section">
        <h2>The Problem</h2>
        <div className="home-grid-3">
          <div className="home-card">
            <h3>No Connectivity, No Safety</h3>
            <p>
              Existing tourist safety apps depend entirely on internet or
              cellular signal, which fails exactly where tourists need it
              most &mdash; forests, mountains, and remote trails.
            </p>
          </div>
          <div className="home-card">
            <h3>Manual Triggers Fail</h3>
            <p>
              A victim who is unconscious, restrained, or panicked cannot
              press a panic button. Detection needs to happen automatically.
            </p>
          </div>
          <div className="home-card">
            <h3>Centralized Data Risk</h3>
            <p>
              Personal and medical data stored on a single server is a
              breach waiting to happen, with no control given back to the
              user.
            </p>
          </div>
        </div>
      </section>

      <section className="home-section home-section-alt">
        <h2>How It Works</h2>
        <div className="home-flow">
          <div className="home-flow-step">
            <div className="home-flow-number">1</div>
            <h4>Detect</h4>
            <p>On-device AI listens for distress sounds and tracks GPS anomalies.</p>
          </div>
          <div className="home-flow-arrow">&rarr;</div>
          <div className="home-flow-step">
            <div className="home-flow-number">2</div>
            <h4>Alert</h4>
            <p>Three-tier fallback: internet, then SMS, then offline mesh relay.</p>
          </div>
          <div className="home-flow-arrow">&rarr;</div>
          <div className="home-flow-step">
            <div className="home-flow-number">3</div>
            <h4>Verify</h4>
            <p>Identity stays encrypted until a verified responder unlocks it.</p>
          </div>
          <div className="home-flow-arrow">&rarr;</div>
          <div className="home-flow-step">
            <div className="home-flow-number">4</div>
            <h4>Respond</h4>
            <p>Responders see live location, evidence, and medical info instantly.</p>
          </div>
        </div>
      </section>

      <section className="home-section">
        <h2>Five Core Modules</h2>
        <div className="home-grid-5">
          <div className="home-module-card">
            <h4>Audio AI</h4>
            <p>TensorFlow Lite scream and glass-break detection, running fully on-device.</p>
          </div>
          <div className="home-module-card">
            <h4>GPS Anomaly Detection</h4>
            <p>Haversine-based stoppage detection with counter debouncing to prevent false alarms.</p>
          </div>
          <div className="home-module-card">
            <h4>Mesh Communication</h4>
            <p>Peer-to-peer offline relay with cost-based next-hop routing when there is no signal.</p>
          </div>
          <div className="home-module-card">
            <h4>Blockchain Identity</h4>
            <p>Locked-by-default identity access, unlocked only during a verified active SOS event.</p>
          </div>
          <div className="home-module-card">
            <h4>Dynamic Risk Engine</h4>
            <p>Weather and news-driven zone risk scoring that adapts on-device detection sensitivity.</p>
          </div>
        </div>
      </section>

      <section className="home-section home-section-alt">
        <h2>System Architecture</h2>
        <div className="home-architecture">
          <div className="home-arch-layer">Device Layer &mdash; Audio Classifier, GPS Monitor, SOS Engine</div>
          <div className="home-arch-layer">Communication Layer &mdash; Internet, SMS, Mesh Relay</div>
          <div className="home-arch-layer">Backend Layer &mdash; FastAPI, MongoDB, Risk Engine</div>
          <div className="home-arch-layer">Blockchain Layer &mdash; Identity Lock and Access Control</div>
        </div>
      </section>

      <section className="home-section">
        <h2>Built With</h2>
        <div className="home-badges">
          <span className="tech-badge">Flutter</span>
          <span className="tech-badge">FastAPI</span>
          <span className="tech-badge">MongoDB</span>
          <span className="tech-badge">TensorFlow Lite</span>
          <span className="tech-badge">Redis</span>
          <span className="tech-badge">Mega.nz</span>
          <span className="tech-badge">Polygon / Solidity</span>
          <span className="tech-badge">React</span>
        </div>
      </section>

      <footer className="home-footer">
        <p>Smart Tourist Safety &amp; Incident Response System &mdash; Admin Console</p>
      </footer>
    </div>
  );
}