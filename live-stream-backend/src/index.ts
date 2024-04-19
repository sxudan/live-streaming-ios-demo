import express from 'express';
import { applyMiddleware } from './middlewares';
import { router } from './routes';
import setupFirebase from '../firebase'
import { configDotenv } from 'dotenv';
import { errorHandler } from './middlewares/error';

configDotenv()


console.log(process.env.GOOGLE_CLIENT_ID)

export const startServer = () => {
    const app = express();
    setupFirebase()
    // Apply middleware
    applyMiddleware(app);
    // Apply routes
    app.use(router)
    app.use(errorHandler)
    // Start the server
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });
};

startServer()