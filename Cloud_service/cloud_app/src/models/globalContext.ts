import { Box } from "./box";

export class GlobalContext{

    constructor(){
        this.boxes = [];
    }
    boxes: Box[];
}