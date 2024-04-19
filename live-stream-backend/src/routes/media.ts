import { Router } from "express";
import { getMedias } from "../controllers/mediaController";

export const mediaRoutes = Router();

mediaRoutes.get('/', async (req, res, next) => {
    try {
        const medias = await getMedias()
        res.status(200).json({'success': true, data: medias })
    } catch(e) {
        next(e)
    }
});