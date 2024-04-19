import { Request, Response, NextFunction } from 'express'
import { ErrorCode, HttpException } from '../models/exception'

export const errorHandler = (error: HttpException, req: Request, res: Response, next: NextFunction) => {
    const status = error.status || 500
    const code = error.code || ErrorCode.UNKNOWN
    const message = error.message || 'Something went wrong.'
    return res.status(status).json({
        error: {
            status: status,
            code: code,
            message: message
        }
    })
}
