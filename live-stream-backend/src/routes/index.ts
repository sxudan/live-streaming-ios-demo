import { Router } from 'express';
import { authRoutes } from './auth';
import { mediaRoutes } from './media';
import { profileRoutes } from './profile';

// Combine all route handlers
export const router = Router();
router.use('/auth', authRoutes);
router.use('/medias', mediaRoutes);
router.use('/profile', profileRoutes);

// Export the router
export { router as routes };