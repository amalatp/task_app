import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { NewTask, tasks } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";

const taksRouter = Router();

taksRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        req.body = { ...req.body, dueAt: new Date(req.body.dueAt), uid: req.user };
        const newTask: NewTask = req.body;
        const [task] = await db.insert(tasks).values(newTask).returning();

        res.status(201).json(task);

    } catch (e) {
        res.status(500).json({ error: e });
    }
});

taksRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const allTasks = await db.select().from(tasks).where(eq(tasks.uid, req.user!));

        res.json(allTasks);

    } catch (e) {
        res.status(500).json({ error: e });
    }
});

taksRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { taskId }: { taskId: string } = await req.body;
        await db.delete(tasks).where(eq(tasks.id, taskId));
        res.json(true);

    } catch (e) {
        res.status(500).json({ error: e });
    }
});

taksRouter.post("/sync", auth, async (req: AuthRequest, res) => {
    try {
        // req.body = { ...req.body, dueAt: new Date(req.body.dueAt), uid: req.user };
        const taskList = req.body;

        const filteredTasks: NewTask[] = [];

        for (let t of taskList) {
            t = { ...t, dueAt: new Date(t.dueAt), createdAt: new Date(t.createdAt), updatedAt: new Date(t.updatedAt), uid: req.user };
            filteredTasks.push(t);
        }
        const pushedTasks = await db.insert(tasks).values(filteredTasks).returning();

        res.status(201).json(pushedTasks);

    } catch (e) {
        res.status(500).json({ error: e });
    }
});

export default taksRouter;