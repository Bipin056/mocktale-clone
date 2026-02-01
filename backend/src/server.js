require("dotenv").config();
const express = require("express");

const app = express();
const PORT = process.env.PORT || 5000;

// middleware
app.use(express.json());

// routes
const authRoutes = require("./routes/auth.routes");
app.use("/api/v1/auth", authRoutes);

// health check
app.get("/", (req, res) => {
  res.send("Backend is running");
});

app.listen(PORT, () => {
  console.log("Server running on port " + PORT);
});