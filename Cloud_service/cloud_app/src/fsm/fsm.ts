
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
import { AutomationController } from "../mysql/AutomationController";


class Context{
    actions: string[];
    currentController: Controller | undefined;
    data: string | undefined = "";
    wholeMessage: string;

    // gc.users: UserController;
    // gc.devices: DeviceController;
    // gc.buildings: BuildingController;
    // gc.rooms: RoomController;
    // gc.captors: CaptorController;
    // gc.captorValues: CaptorValueController;
    // gc.automations: AutomationController;

    done: boolean;

    ws: WebSocket;
    gc: GlobalContext;
    building_id = "1";
    captorid = "";
    captorvalue= "";

    constructor(actions: string[], ws: WebSocket, gc: GlobalContext) {
        this.ws = ws;
        this.actions = actions;
        this.gc = gc;
        this.done = false;
        this.wholeMessage = actions.join("//");
        console.log(`Controllers : constructor, gc.users = ${this.gc.users}, gc.devices = ${this.gc.devices}`);
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
                context.currentController = context.gc.users; 
                state.trigger( "boxConnection" );
                break;
            case "user": 
                context.currentController = context.gc.devices; 
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
        context.gc.users.connect(email, password)
            .then((id: string) => {

                isAuth = id !== undefined;
                // Use dataResult as an array of rows or objects
                console.log(`User is connected ? ${isAuth}, with id: ${id}`);
                context.ws.send(`connection//${isAuth}//${id}`);
                state.trigger( "end" ); 
            })
            .catch((error) => {
                context.ws.send(`Error trying to connect : ${error}`);
                console.error(`Error trying to connect : ${error}`);
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
            case "users": context.currentController = context.gc.users; state.trigger( "users" );break;
            case "devices": context.currentController = context.gc.devices; state.trigger( "devices" ); break;
            case "buildings": context.currentController = context.gc.buildings;  state.trigger( "buildings" ); break;
            case "rooms": context.currentController = context.gc.rooms;  state.trigger( "rooms" ); break;
            case "captors": context.currentController = context.gc.captors;  state.trigger( "captors" ); break;
            case "captor_values": context.currentController = context.gc.captorValues;  state.trigger( "captor_values" ); break;
            case "automations": context.currentController = context.gc.automations;  state.trigger( "automations" ); break;
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
            context.currentController.insert(context.data)
            .then((jsonString: string) => {
              // Use jsonString, which contains the JSON representation of the query result
              console.log('Query result as JSON:', jsonString);
              context.ws.send(jsonString);
            })
            .catch((error: any) => {
              console.error('Error:', error);
              context.ws.send('Error:', error);
            });
            const parsedData = JSON.parse(context.data);
            context.ws.send("OK");
            if(context.currentController instanceof CaptorValueController)
            {
                context.captorid = parsedData["captor_id"];
                context.captorvalue = parsedData["value"];
                context.gc.buildings.getBuildingByCaptor(context.captorid).then(
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
            context.ws.send("OK");
            state.trigger( "update" );
        } else if ( currentMessage === "delete"&& context.currentController !== undefined && context.data !== undefined ) {
            context.currentController?.remove(context.data);
            state.trigger( "delete" );
        }else if ( currentMessage === "conn" && context.data !== undefined ) {
            context.gc.buildings?.insertConnection(context.data);
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
        let group: string | undefined;
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
            
            if (nextData === "group") 
            {
                group = data.shift();
                nextData = data.shift();
            }
        }
        
        console.log(`FSM, invokeGet : join =  ${join}, where = ${where}, group = ${group}`);

        if(context.currentController instanceof CaptorController)
        {
            context.gc.captors.getCaptorWithLastData(where!)
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
            context.currentController.select(where, join, group)
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
        // if(context.gc.users.pool != null) { context.gc.users.pool.end(); console.log(`FSM : final action, end gc.users pool`)};
        // if(context.gc.devices.pool != null) { context.gc.devices.pool.end(); console.log(`FSM : final action, end gc.devices pool`)};
        // if(context.gc.rooms.pool != null) { context.gc.rooms.pool.end(); console.log(`FSM : final action, end gc.rooms pool`)};
        // if(context.gc.captors.pool != null) { context.gc.captors.pool.end(); console.log(`FSM : final action, end gc.captors pool`)};
        // if(context.gc.captorValues.pool != null) { context.gc.captorValues.pool.end(); console.log(`FSM : final action, end gc.captorValues pool`)};
        // if(context.gc.automations.pool != null) { context.gc.automations.pool.end(); console.log(`FSM : final action, end gc.automations pool`)};
        
        context.currentController = undefined;
        context.data = undefined;
        
    }
      
    startFsm() : boolean {
        console.log(`FSM : startFsm : context = ${this.context}`);
        const stateMachine = new StateMachine('StateMachine', this.context);
        
        const directionState = stateMachine.createState( "Direction state", false, this.directionAction, this.exitAction); // Trivial use of exit action as an example.
        
        const connectState = stateMachine.createState( "Connexion state", false, this.connectionAction, this.exitAction); // Trivial use of exit action as an example.
        const connectuserstate = stateMachine.createState( "Connect user state", false, this.tryConnectUser, this.exitAction); // Trivial use of exit action as an example.
        const connectBoxState = stateMachine.createState( "Connect box state", false, this.tryConnectBox, this.exitAction); // Trivial use of exit action as an example.
        
        const toLocalState = stateMachine.createState( "To local state", false, this.tableAction);
        const toCloudState = stateMachine.createState( "To cloud state", false, this.tableAction);

        const usersState = stateMachine.createState( "users state", false, this.parseDataAction);
        const devicesState = stateMachine.createState( "devices state", false, this.parseDataAction);
        const buildingsState = stateMachine.createState( "buildings state", false, this.parseDataAction);
        const roomsState = stateMachine.createState( "rooms state", false, this.parseDataAction);
        const captorsState = stateMachine.createState( "captors state", false, this.parseDataAction);
        const captorValuesState = stateMachine.createState( "Captor values state", false, this.parseDataAction);
        const automationsState = stateMachine.createState( "Automation state", false, this.parseDataAction);
        
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

        connectState.addTransition( "userConnection", connectuserstate );
        connectState.addTransition( "boxConnection", connectBoxState );
        // TO LOCAL/CLOUD
        connectuserstate.addTransition( "end", endState );
        connectBoxState.addTransition( "end", endState );

        toCloudState.addTransition( "users", usersState );
        toCloudState.addTransition( "devices", devicesState );
        toCloudState.addTransition( "buildings", buildingsState );
        toCloudState.addTransition( "rooms", roomsState );
        toCloudState.addTransition( "captors", captorsState );
        toCloudState.addTransition( "captor_values", captorValuesState );
        toCloudState.addTransition( "automations", automationsState );
        
        //PARSE DATA
        usersState.addTransition( "parse", parseDataState );
        devicesState.addTransition( "parse", parseDataState );
        buildingsState.addTransition( "parse", parseDataState );
        roomsState.addTransition( "parse", parseDataState );
        captorsState.addTransition( "parse", parseDataState );
        captorValuesState.addTransition( "parse", parseDataState );
        automationsState.addTransition( "parse", parseDataState );

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