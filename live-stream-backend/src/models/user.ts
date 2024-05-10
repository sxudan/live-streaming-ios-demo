import { Connection } from "./profile";

export interface User {
    uid: String;
    firstname: string;
    lastname: string;
    dob: number;
    username: string;
    email: string;
    phone?: string;
    followers?: Connection[];
    following?: Connection[];
}