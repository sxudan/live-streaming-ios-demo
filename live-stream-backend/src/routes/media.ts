import { Router } from "express";
import { createMedia, getMedias, updateMediaStatus } from "../controllers/mediaController";

export const mediaRoutes = Router();

mediaRoutes.get('/', async (req, res, next) => {
    try {
        const medias = await getMedias()
        res.status(200).json({'success': true, data: medias })
    } catch(e) {
        next(e)
    }
});

mediaRoutes.post('/', async (req, res, next) => {
    try {
        const { uid } = req.body
        const media = await createMedia(uid)
        res.status(200).json({'success': true, data: media })
    } catch(e) {
        next(e)
    }
});

mediaRoutes.put('/', async (req, res, next) => {
    try {
        const { streamId, status } = req.body
        const media = await updateMediaStatus(streamId, status)
        res.status(200).json({'success': true, data: media })
    } catch(e) {
        next(e)
    }
});