export interface EditProfileInput {
    firstname?: string;
    lastname?: string;
    dob?: number;
    phone?: number;
}

export interface Connection {
    id: string;
    followedBy: string;
    followedTo: string;
    createdAt: string;
}