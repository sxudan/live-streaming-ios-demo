import { Router } from "express";
import { createMedia, getMedias, updateMediaStatus } from "../controllers/mediaController";
import { glob } from "glob";
import fs from 'fs'

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
        const { streamId, status, uid } = req.body
        const media = await updateMediaStatus(streamId, status)
        res.status(200).json({'success': true, data: media })
    } catch(e) {
        next(e)
    }
});

mediaRoutes.get('/:id', async (req, res, next) => {
    try {
        const { id } = req.params
        const range = req.headers.range ?? "0"
        const videoPath = `./mediamtx/${id}/*`; 
        const list = await glob(videoPath)
        console.log(list)
        const videoSize = fs.statSync(list[0]).size
        console.log(videoSize) 
        // const chunkSize = 1 * 1e6; 
        // const start = Number(range.replace(/\D/g, "")) 
        // const end = Math.min(start + chunkSize, videoSize - 1) 
        // const contentLength = end - start + 1; 
        const headers = { 
            // "Content-Range": `bytes ${start}-${end}/${videoSize}`, 
            // "Accept-Ranges": "bytes", 
            "Content-Length": videoSize, 
            "Content-Type": "video/mp4"
        } 
        res.writeHead(200, headers) 
        const stream = fs.createReadStream(list[0]);
    
        stream.pipe(res);
    } catch(e) {
        next(e)
    }
})