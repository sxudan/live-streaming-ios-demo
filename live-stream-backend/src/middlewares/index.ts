// src/middleware.ts
import { Express } from 'express';
import { json, urlencoded } from 'express';
import { logger } from './logger';

// Define your middleware functions here
// For example:
// import { logger } from './middleware/logger';

export const applyMiddleware = (app: Express) => {
    // Add middleware functions to the Express app
    app.use(json());
    app.use(urlencoded({ extended: true }));
    app.use(logger);
};