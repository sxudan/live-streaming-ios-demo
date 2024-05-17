import { Router } from "express";
import { addComment, createMedia, decreaseViewCount, fetchComments, getMedias, increaseViewCount, updateMediaStatus } from "../controllers/mediaController";
import { glob } from "glob";
import fs from 'fs'

export const mediaRoutes = Router();

mediaRoutes.get('/', async (req, res, next) => {
    try {
        const {uid} = req.query
        const medias = await getMedias(uid as string)
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
        const videoPath = `./mediamtx/recordings/${id}/*`; 
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

mediaRoutes.post('/:streamId/comment', async (req, res, next) => {
    try {
        const {streamId} = req.params
        const { comment, uid } = req.body
        await addComment(uid, comment, streamId)
        res.status(200).json({'success': true })
    } catch(e) {
        next(e)
    }
});

mediaRoutes.get('/:streamId/comment', async (req, res, next) => {
    try {
        const {streamId} = req.params
        const {comments, viewCount} = await fetchComments(streamId)
        res.status(200).json({'success': true , data: comments, viewCount: viewCount})
    } catch(e) {
        next(e)
    }
});

mediaRoutes.post('/viewcount/increase', async (req, res, next) => {
    try {
        const {streamId} = req.body
        const count = await increaseViewCount(streamId)
        res.status(200).json({'success': true, data: {count}})
    } catch(e) {
        console.log(e)
        next(e)
    }
});

mediaRoutes.post('/viewcount/decrease', async (req, res, next) => {
    try {
        const {streamId} = req.body
        const count = await decreaseViewCount(streamId)
        res.status(200).json({'success': true, data: {count} })
    } catch(e) {
        next(e)
    }
});