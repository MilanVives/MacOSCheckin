const mongoose = require("mongoose");
const express = require("express");
const app = express();

// Define the MongoDB Schema and Model
const clientSchema = new mongoose.Schema({
  name: String,
  ip: String,
  timestamp: { type: Date, default: Date.now }
});

const Client = mongoose.model('Client', clientSchema);

// Add schema for logs
const logSchema = new mongoose.Schema({
  method: String,
  path: String,
  timestamp: { type: Date, default: Date.now },
  ip: String,
  userAgent: String
});

const Log = mongoose.model('Log', logSchema);

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/clientDB');

// Add middleware to parse JSON bodies
app.use(express.json());

// Add middleware to parse URL-encoded bodies
app.use(express.urlencoded({ extended: true }));

app.get("/", async (req, res) => {
  try {
    // Get the real client IP from Cloudflare headers
    const clientIP = req.headers['cf-connecting-ip'] || 
                    req.headers['x-forwarded-for'] || 
                    req.headers['x-real-ip'] ||
                    req.ip;
    
    // Create log entry with real IP
    const log = new Log({
      method: 'GET',
      path: '/',
      ip: clientIP,
      userAgent: req.get('User-Agent')
    });
    
    // Save log to MongoDB
    await log.save();
    
    // Console log with real IP
    console.log(`[${new Date().toISOString()}] GET / - IP: ${clientIP} - User-Agent: ${req.get('User-Agent')}`);
    
    // Send original response
    res.send("You've logged in on the checkinserver https://checkin.vives.live");
  } catch (error) {
    console.error('Error logging request:', error);
    res.send("You've logged in on the checkinserver https://checkin.vives.live");
  }
});

// Helper function to extract IP address from ifconfig output
function extractIPAddress(ifconfigOutput) {
  try {
    // Look for IPv4 address pattern in ifconfig output
    const match = ifconfigOutput.match(/inet\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/);
    return match ? match[1] : null;
  } catch (error) {
    console.error('Error parsing IP address:', error);
    return null;
  }
}

// Add POST route
app.post("/", async (req, res) => {
  try {
    const parsedIP = extractIPAddress(req.body.ip);
    
    const newClient = new Client({
      name: req.body.name,
      ip: parsedIP || req.body.ip // fallback to raw input if parsing fails
    });
    
    await newClient.save();
    res.status(201).json({ message: "Client saved successfully", client: newClient });
  } catch (error) {
    res.status(500).json({ error: "Error saving client" });
  }
});

// Add GET route for all clients
app.get("/api/clients", async (req, res) => {
  try {
    const clients = await Client.find({})
      .sort({ timestamp: -1 }); // Sort by timestamp, newest first
    
    res.status(200).json(clients);
  } catch (error) {
    console.error('Error fetching clients:', error);
    res.status(500).json({ error: "Error fetching clients" });
  }
});

// Optional: Add endpoint to view logs
app.get("/api/logs", async (req, res) => {
  try {
    const logs = await Log.find({})
      .sort({ timestamp: -1 })
      .limit(100); // Limit to last 100 logs
    
    res.status(200).json(logs);
  } catch (error) {
    console.error('Error fetching logs:', error);
    res.status(500).json({ error: "Error fetching logs" });
  }
});

app.listen(3100, () => {
  console.log("Server is running on port 3100");
});

