"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.applyMiddleware = void 0;
const express_1 = require("express");
const logger_1 = require("./logger");
// Define your middleware functions here
// For example:
// import { logger } from './middleware/logger';
const applyMiddleware = (app) => {
    // Add middleware functions to the Express app
    app.use((0, express_1.json)());
    app.use((0, express_1.urlencoded)({ extended: true }));
    app.use(logger_1.logger);
};
exports.applyMiddleware = applyMiddleware;
