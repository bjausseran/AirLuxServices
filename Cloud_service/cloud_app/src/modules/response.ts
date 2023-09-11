type ApiResponse = {
    response: string
    data?: Record<string, any>
    error?: string
    }
    
export const ComposeResponse = (response: string, data?:  Record<string, any>, error?: Error) =>
{
    let resp: ApiResponse = {
        response: response, 
        data: data, 
        error: error?.message
    };
    return resp;
}
    