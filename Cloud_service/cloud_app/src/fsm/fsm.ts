
import { UserController } from "../mysql/UserController";
import { DeviceController } from "../mysql/DeviceController";
import { BuildingController } from "../mysql/BuildingController";
import { RoomController } from "../mysql/RoomController";
import { CaptorController } from "../mysql/CaptorController";
import { CaptorValueController } from "../mysql/CaptorValueController";

import { State, StateMachine } from "@edium/fsm";
import { Controller } from "../mysql/Controller";
import { WebSocket } from "ws";
import { Box } from "../models/box";
import { GlobalContext } from '../models/globalContext';


class Context{
    actions: string[];
    currentController: Controller | undefined;
    data: string | undefined = "";
    wholeMessage: string;

    users: UserController;
    devices: DeviceController;
    buildings: BuildingController;
    rooms: RoomController;
    captors: CaptorController;
    captorValues: CaptorValueController;

    done: boolean;

    ws: WebSocket;
    gc: GlobalContext;
    building_id = "1";
    captorid = "";
    captorvalue= "";

    constructor(actions: string[], ws: WebSocket, gc: GlobalContext) {
        this.ws = ws;
        this.actions = actions;
        this.users = new UserController();
        this.devices = new DeviceController();
        this.buildings = new BuildingController();
        this.rooms = new RoomController();
        this.captors = new CaptorController();
        this.captorValues = new CaptorValueController();
        this.gc = gc;
        this.done = false;
        this.wholeMessage = actions.join("//");
        console.log(`Controllers : constructor, users = ${this.users}, devices = ${this.devices}`);
    }

    toString(): string{
        return this.actions.join(" ");
    }
}

export class FSM {
    context?: Context;


    constructor() {
        //this.context = new Context(message.split('//'));
        //console.log(`FSM : constructor : context = ${this.context}`);
    }

    setContext(message: string, ws: WebSocket, gc: GlobalContext){
        this.context = new Context(message.split('//'), ws, gc);
    }


    exitAction = ( state : State, context: string[] ) => {
        // Returning false will cancel the state transition
        console.log(`FSM : exit action, state = ${state}}, context ${context}`);
        return true;
    };
      
    directionAction ( state : State, context: Context ) {
        const currentMessage = context.actions.shift();
        console.log(`FSM : action = direction, context = {${context.toString()}}, message = ${currentMessage}`);
        if ( currentMessage === "tolocal" ) {
            state.trigger( "tolocal" );
        } else if ( currentMessage === "tocloud" ) {
            state.trigger( "tocloud" );
        } else if ( currentMessage === "connect" ) {
            state.trigger( "connect" );
        }
    }

    connectionAction ( state : State, context: Context ) {
        const currentMessage = context.actions.shift();
        console.log(`FSM : action = direction, context = {${context.toString()}}, message = ${currentMessage}`);

        switch (currentMessage) {
            case "box": 
                context.currentController = context.users; 
                state.trigger( "boxConnection" );
                break;
            case "user": 
                context.currentController = context.devices; 
                state.trigger( "userConnection" ); 
                break;
            default: break;
        }
    }

    tryConnectBox ( state : State, context: Context ) {
        
        const currentMessage = context.actions.shift();
        if(currentMessage)
        {
            if(context.gc.boxes == undefined) 
                context.gc.boxes = [new Box(context.ws, currentMessage)]
            else
                context.gc.boxes.push(new Box(context.ws, currentMessage));

            console.log(`tryConnectBox : New box registered, building id = ${currentMessage}`);
            console.log(`tryConnectBox : nb boxes = ${context.gc.boxes.length}`);
        }
        state.trigger( "end" ); 
    }
    tryConnectUser ( state : State, context: Context ) {
        const data = context.actions.shift();
        const credentials = data!.split("{#}");
        
        const email = credentials.shift();
        const password = credentials.shift();

        if(email == null || password == null) return;

        let isAuth = false; 
        context.users.connect(email, password)
            .then((id: string) => {

                isAuth = id !== undefined;
                // Use dataResult as an array of rows or objects
                console.log(`User is connected ? ${isAuth}, with id: ${id}`);
                context.ws.send(`connection//${isAuth}//${id}`);
                state.trigger( "end" ); 
            })
            .catch((error) => {
                console.error(`UError trying to connect, err: ? ${error}`);
              })

    }

    sendToLocal ( state : State, context: Context ) {
        //const currentMessage = context.actions[0];
        if (context.currentController !== undefined)
        {
            const mess = `tolocal//${context.currentController.tableName}//${context.captorid}//${context.captorvalue}`
            console.log(`FSM : action = sendToLocal, wholeMessage = ${mess}, to box#${context.building_id}`);
            console.log(`FSM : action = sendToLocal, nb boxes = ${context.gc.boxes?.length}`);
            if(context.gc.boxes == undefined)
            {
                state.trigger( "end" ); 
                return;
            }
            for (let index = 0; index < context.gc.boxes.length; index++) {
                const element = context.gc.boxes[index];
                console.log(`FSM : action = sendToLocal, iterate : box#${index} = ${element.building_id}`);
                if(element.building_id == context.building_id)
                {
                    element.ws.send(mess);
                    console.log(`FSM : action = sending to local, ws = ${!element.ws.isPaused}`);
                }
            }
        }
        
        state.trigger( "end" ); 
    }

    tableAction ( state : State, context: Context ) {
        const currentMessage = context.actions.shift();
        console.log(`FSM : action = table, context = {${context.toString()}}, message = ${currentMessage}`);
        switch (currentMessage) {
            case "users": context.currentController = context.users; state.trigger( "users" );break;
            case "devices": context.currentController = context.devices; state.trigger( "devices" ); break;
            case "buildings": context.currentController = context.buildings;  state.trigger( "buildings" ); break;
            case "rooms": context.currentController = context.rooms;  state.trigger( "rooms" ); break;
            case "captors": context.currentController = context.captors;  state.trigger( "captors" ); break;
            case "captor_values": context.currentController = context.captorValues;  state.trigger( "captor_values" ); break;
            default: break;
        }
    }
    
    parseDataAction ( state : State, context: Context ) {
        context.data = context.actions.shift();
        console.log(`FSM : action = parse, context = {${context.toString()}}, data = ${context.data}`);
        //if(data is ok)
        state.trigger( "parse" );
    }
    
    statementAction ( state : State, context: Context ) {
        const currentMessage = context.actions.shift();
        console.log(`FSM : action = statement, context = {${context.toString()}}, message = ${currentMessage}`);
        if ( currentMessage === "get" && context.currentController !== undefined) {
            state.trigger( "get" );
        } else if ( currentMessage === "insert"  && context.currentController !== undefined && context.data !== undefined) {
            context.currentController.insert(context.data);
            const parsedData = JSON.parse(context.data);

            if(context.currentController instanceof CaptorValueController)
            {
                context.captorid = parsedData["captor_id"];
                context.captorvalue = parsedData["value"];
                context.buildings.getBuildingByCaptor(context.captorid).then(
                    (result) => {
                        const parsed = JSON.parse(result)[0]["building_id"];
                        console.log(`FSM : action = statement, send action to building#${parsed}`);
                        context.building_id = parsed; 
                        //state.trigger( "send" );
                    });
            }
            state.trigger( "insert" );
        } else if ( currentMessage === "update" && context.currentController !== undefined && context.data !== undefined) {
            context.currentController.update(context.data);
            state.trigger( "update" );
        } else if ( currentMessage === "delete"&& context.currentController !== undefined && context.data !== undefined ) {
            context.currentController?.remove(context.data);
            state.trigger( "delete" );
        }
    }

    invokeGet(state: State, context: Context)
    {
        if(context.currentController === undefined) return;

        //let currentMessage = context.actions.shift();

        const data = context.data?.split("{#}");
        let nextData = data?.shift();
        let where: string | undefined;
        let join: string | undefined;
        if(data !== undefined)
        {
            if (nextData === "join") 
            {
                join = data.shift();
                nextData = data.shift();
            }
    
            if (nextData === "where") 
            {
                where = data.shift();
                nextData = data.shift();
            }
        }
        
        console.log(`FSM, invokeGet : join =  ${join}, where = ${where}`);

        if(context.currentController instanceof CaptorController)
        {
            context.captors.getCaptorWithLastData(where!)
            .then((jsonString: string) => {
              // Use jsonString, which contains the JSON representation of the query result
              console.log('Query result as JSON:', jsonString);
              context.ws.send(jsonString);
            })
            .catch((error) => {
              console.error('Error:', error);
              context.ws.send('Error:', error);
            })
        }
        else{
            context.currentController.select(where, join)
            .then((jsonString: string) => {
              // Use jsonString, which contains the JSON representation of the query result
              console.log('Query result as JSON:', jsonString);
              context.ws.send(jsonString);
            })
            .catch((error: any) => {
              console.error('Error:', error);
              context.ws.send('Error:', error);
            })
        }


        
        state.trigger( "end" );
    }
    
        
    finalAction ( state : State, context: Context  ) {
        // Can perform some final actions, the state machine is finished running.
        //perform mysql request and/or send message to local
        console.log(`FSM : final action, state = ${state}}, context ${context}`);
        context.done = true;
        context.currentController = undefined;
        context.data = undefined;
        
    }
      
    startFsm() : boolean {
        console.log(`FSM : startFsm : context = ${this.context}`);
        const stateMachine = new StateMachine('StateMachine', this.context);
        
        const directionState = stateMachine.createState( "Direction state", false, this.directionAction, this.exitAction); // Trivial use of exit action as an example.
        
        const connectState = stateMachine.createState( "Connexion state", false, this.connectionAction, this.exitAction); // Trivial use of exit action as an example.
        const connectUserState = stateMachine.createState( "Connect user state", false, this.tryConnectUser, this.exitAction); // Trivial use of exit action as an example.
        const connectBoxState = stateMachine.createState( "Connect box state", false, this.tryConnectBox, this.exitAction); // Trivial use of exit action as an example.
        
        const toLocalState = stateMachine.createState( "To local state", false, this.tableAction);
        const toCloudState = stateMachine.createState( "To cloud state", false, this.tableAction);

        const usersState = stateMachine.createState( "Users state", false, this.parseDataAction);
        const devicesState = stateMachine.createState( "Devices state", false, this.parseDataAction);
        const buildingsState = stateMachine.createState( "Buildings state", false, this.parseDataAction);
        const roomsState = stateMachine.createState( "Rooms state", false, this.parseDataAction);
        const captorsState = stateMachine.createState( "Captors state", false, this.parseDataAction);
        const captorValuesState = stateMachine.createState( "Captor values state", false, this.parseDataAction);
        
        const parseDataState = stateMachine.createState( "Parse data state", false, this.statementAction);
        
        
        const endState = stateMachine.createState( "End state", false, this.finalAction);

        const getState = stateMachine.createState( "Get state", false, this.invokeGet);
        const insertState = stateMachine.createState( "Insert state", false, this.sendToLocal);
        const updateState = stateMachine.createState( "Update state", false, this.finalAction);
        const deleteState = stateMachine.createState( "Delete state", false, this.finalAction);
        
        // TO LOCAL/CLOUD
        directionState.addTransition( "tolocal", toLocalState );
        directionState.addTransition( "tocloud", toCloudState );
        directionState.addTransition( "connect", connectState );

        connectState.addTransition( "userConnection", connectUserState );
        connectState.addTransition( "boxConnection", connectBoxState );
        // TO LOCAL/CLOUD
        connectUserState.addTransition( "end", endState );
        connectBoxState.addTransition( "end", endState );

        toCloudState.addTransition( "users", usersState );
        toCloudState.addTransition( "devices", devicesState );
        toCloudState.addTransition( "buildings", buildingsState );
        toCloudState.addTransition( "rooms", roomsState );
        toCloudState.addTransition( "captors", captorsState );
        toCloudState.addTransition( "captor_values", captorValuesState );
        
        //PARSE DATA
        usersState.addTransition( "parse", parseDataState );
        devicesState.addTransition( "parse", parseDataState );
        buildingsState.addTransition( "parse", parseDataState );
        roomsState.addTransition( "parse", parseDataState );
        captorsState.addTransition( "parse", parseDataState );
        captorValuesState.addTransition( "parse", parseDataState );

        //FIND STATEMENT
        parseDataState.addTransition( "get", getState );
        getState.addTransition( "end", endState);

        parseDataState.addTransition( "insert", insertState );
        insertState.addTransition( "end", endState);
        //sendActionState.addTransition( "end", endState);

        parseDataState.addTransition( "update", updateState );
        parseDataState.addTransition( "delete", deleteState );
        
        // Start the state machine
        stateMachine.start( directionState );

        return true;
    }
}