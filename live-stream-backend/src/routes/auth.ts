import { Router } from 'express';
import { login, signup } from '../controllers/authController';
import { SignupInputType } from '../models/signup.input'

export const authRoutes = Router();

authRoutes.post('/login', async (req, res, next) => {
    const {token} = req.body
    // console.log(googleToken, appleToken)
    try {
        const data = await login(token)
        res.status(200).json({'success': true, ...data })
    } catch(e) {
        next(e)
    }
});

authRoutes.post('/signup', async (req, res, next) => {
    try {
        const body = req.body as SignupInputType;
        const data = await signup(body)
        res.status(200).json({'success': true, ...data })
    } catch(e) {
        next(e)
    }
});