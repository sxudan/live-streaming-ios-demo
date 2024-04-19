export interface SignupInputType {
    firstname: string;
    lastname: string;
    dob: number;
    username: string;
    token: string | undefined | null;
    phone?: string
}