"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.routes = exports.router = void 0;
const express_1 = require("express");
const auth_1 = require("./auth");
// Combine all route handlers
exports.router = (0, express_1.Router)();
exports.routes = exports.router;
exports.router.use('/auth', auth_1.authRoutes);
