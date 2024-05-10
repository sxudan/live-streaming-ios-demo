import { Router } from "express";
import { followUser, getProfile, searchUsers, unfollowUser, updateProfile } from "../controllers/profileController";

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

profileRoutes.get('/:uid', async (req, res, next) => {
    try {
        const { uid } = req.params
        const result = await getProfile(uid)
        res.status(200).json({'success': true, data: result })
    } catch(e) {
        next(e)
    }
});

profileRoutes.get('/', async (req, res, next) => {
    try {
        const { search } = req.query
        const result = await searchUsers((search as string).toLowerCase())
        res.status(200).json({'success': true, data: result })
    } catch(e) {
        next(e)
    }
});

profileRoutes.post('/:uid/follow/:id', async (req, res, next) => {
    try {
        const { uid, id } = req.params
        const result = await followUser(uid, id)
        res.status(200).json({'success': true, data: result })
    } catch(e) {
        next(e)
    }
});

profileRoutes.post('/:uid/unfollow/:id', async (req, res, next) => {
    try {
        const { uid, id } = req.params
        const result = await unfollowUser(uid, id)
        res.status(200).json({'success': true, })
    } catch(e) {
        next(e)
    }
});