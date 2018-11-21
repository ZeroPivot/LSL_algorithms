//Texture traversal script
//by ArityWolf Resident

integer maxInventory;
string inventoryTraversalName;
integer inventoryCurrentNumber;
integer rotatingOrNot;

float timer_time() //time of delay
{
    float setTime = 10.0; //Modify this delay time to your liking
    return setTime;
}
 

resetVariables() //(or start variables)
{
    
    inventoryCurrentNumber = 0;
    inventoryTraversalName = llGetInventoryName(INVENTORY_TEXTURE, 0);
    maxInventory = llGetInventoryNumber(INVENTORY_TEXTURE); 

}

setTraversal()
{
    if (inventoryCurrentNumber < maxInventory)
    {
        
        inventoryTraversalName = llGetInventoryName(INVENTORY_TEXTURE, inventoryCurrentNumber);
        llSetTexture(inventoryTraversalName, ALL_SIDES);
        inventoryCurrentNumber += 1; //optimized
    }
    else
    if (inventoryCurrentNumber == maxInventory)
    {
       inventoryCurrentNumber = 0; //reset
       inventoryTraversalName = llGetInventoryName(INVENTORY_TEXTURE, inventoryCurrentNumber);
       llSetTexture(inventoryTraversalName, ALL_SIDES);
        
        
                    
    }

}




default
{
    state_entry()
    {
        llSay(0, "Hello, Avatar! Touching starts the texture rotation.");
        resetVariables();
       
        
    }

    touch_start(integer total_number)
    {
        state running; //LET'S ROTATE!1!

    }
       
    
}

state running //When we're rotating through the textures
{
    
    
    state_entry()
    {
        llSay(0, "running");
        llSetTimerEvent(timer_time());
        setTraversal();
    }
    
    changed(integer change)
    {
        if (change == CHANGED_INVENTORY)
        {
            resetVariables();
            state running;
         
        }
    
    }
    
    touch_start(integer num)
    {
        llSetTimerEvent(0.0);
        state notRunning;
    
    }
    timer()
    {
        setTraversal();
        
    
    }

}

state notRunning //When we're on standby
{
   
    state_entry()
    {
        llSetTimerEvent(0.0); //0 == off
        //llSetTexture("", ALL_SIDES);
        llSay(0, "Standby");
        //inventoryCurrentNumber = 0;
        //resetVariables();
    }  
    
     changed(integer change)
    {
        if (change == CHANGED_INVENTORY)
                resetVariables();
    
    }
    
       touch_start(integer num)
       {
        state running; 
        
        
        }   
    
}
