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

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/clientDB');

// Add middleware to parse JSON bodies
app.use(express.json());

// Add middleware to parse URL-encoded bodies
app.use(express.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.send("You've logged in on the checkinserver https://checkin.vives.live");
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

app.listen(3100, () => {
  console.log("Server is running on port 3100");
});

