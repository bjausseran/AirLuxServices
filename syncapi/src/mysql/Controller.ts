
export interface Controller{
    select(where: string | undefined, join: string | undefined) : Promise<string>;
    find(id: string) : Promise<string>;
    insert(json: string) : void;
    update(json: string) : void;
    remove(id: string) : void;
}
