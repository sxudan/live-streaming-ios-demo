"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.startServer = void 0;
const express_1 = __importDefault(require("express"));
const middlewares_1 = require("./middlewares");
const routes_1 = require("./routes");
const startServer = () => {
    const app = (0, express_1.default)();
    // Apply middleware
    (0, middlewares_1.applyMiddleware)(app);
    // Apply routes
    app.use(routes_1.router);
    // Start the server
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });
};
exports.startServer = startServer;
