import { User } from "./user"

export interface Media {
    streamId: string
    url: string
    postedBy: User
    createdAt: number
    metadata?: any,
    status: 'PUBLISHING' | 'STOPPED'
}

export interface Comment {
    id: string
    postedBy: User
    comment: string
    createdAt: number
}