import express from "express";
import authRouter from "./routes/auth";
import taksRouter from "./routes/task";

const app = express();

app.use(express.json());
app.use("/auth", authRouter);
app.use("/tasks", taksRouter);

app.get("/", (req, res) => {
    res.send("welcome to my application");
});

app.listen(8000, () => {
    console.log("asd 00");
});