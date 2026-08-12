const express = require('express');
const client = require('prom-client');

const app = express();
const PORT = process.env.PORT || 3000;

// Collect default Node.js metrics (CPU, memory, event loop, etc.)
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();

// Custom metric: counts total requests to "/"
const requestCounter = new client.Counter({
  name: 'app_requests_total',
  help: 'Total number of requests to the home route',
});

app.get('/', (req, res) => {
  requestCounter.inc();
  res.send('Hello from my DevOps project! 🚀');
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Metrics endpoint - Prometheus will scrape this
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});