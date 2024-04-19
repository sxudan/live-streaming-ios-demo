import { Router } from "express";
import { updateProfile } from "../controllers/profileController";

export const profileRoutes = Router();

profileRoutes.put('/', async (req, res, next) => {
    try {
        const { uid, firstname, lastname, phone, dob } = req.body
        const user = await updateProfile(uid, {firstname, lastname, phone, dob})
        res.status(200).json({'success': true, data: user })
    } catch(e) {
        next(e)
    }
});