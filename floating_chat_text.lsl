//Displays what you say wherever you place this script, as well as flashing "Typing..." As you type; slight delay in that if you've already typed something; I might make it better later.
//By  Kejento Drake/Potential Difference, 2007 - 2010


list Display;
float first_random;
float second_random;
float third_random;
integer last_status;
integer typed;

string inner;
string outer;
string title;
string typeset;
string leftc;
string rightc;

integer chat0;
integer chat1;
integer ao_enabled = FALSE;
integer disabledChat;




string getTypeset(string type) {
   // llSay(0, "type");
    if (typeset == "")
        {
            return "Typing...";}
    else
        return type;
    
    }

//string explicitMessage(integer explicitSet, 

default
{
    on_rez(integer start_param)
    {
        llResetScript(); 
    }
    
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        typeset = getTypeset(typeset);
        llAllowInventoryDrop(TRUE); 
        //llSetText("{ }", <1,1,1>, 1.5);
        llSetTimerEvent(0.5);
        chat0 = llListen(0, "", llGetOwner(), "");
        chat1 = llListen(9, "", llGetOwner(), "");
        llWhisper(0, "Running...");
    //llSay(0, "Testing");
        //llListen(0, "", NULL_KEY, "");
        //llSensorRepeat("", llGetOwner(), AGENT,20, PI, .5);
       
    }




    listen(integer channel, string name, key id, string message)
    
    {
        if (channel == 9 && message == "test")
            llSay(0, "testing");
        
        
        
        
        if (channel == 0 && message == "/enable_AO")
            ao_enabled = TRUE;
        
        if (channel == 0 && message == "/disable_AO")
            ao_enabled = FALSE;
        
        if (channel == 0 && message == "/disable_FCT")
            state disabled;
        
        if (channel == 0 && message == "/reset_text") 
            llResetScript();
        else
              if (channel == 0 && id == llGetOwner())
        {
            Display = llParseString2List(message, [" "],[]);
            
            if (llList2String(Display, 0) == "/change_brackets")
                {
                    inner = llList2String(Display, 1);
                    outer = llList2String(Display, 2);
                
                }
                else
            
            if (llList2String(Display, 0) == "/typeset")
            {
                Display = llDeleteSubList(Display,0,0);
                typeset = llDumpList2String(Display, " ");
            }
            else
            
            if (llList2String(Display, 0) == "/concatenate")
            {
                    leftc = llList2String(Display, 1);
                    rightc = llList2String(Display, 2);
            
            }
            else
            
            if (llList2String(Display, 0) == "/text_title")
            {
               
               Display = llDeleteSubList(Display,0,0);
               title = llDumpList2String(Display, " ");
                
            
            }
            else
            
            if (llList2String(Display, 0) == "/me")
                {
                    first_random = llFrand(1.0);
                    second_random = llFrand(1.0);
                    third_random = llFrand(1.0);
                    Display = llDeleteSubList(Display, 0, 0);
                    llSetText(inner+"    "+llKey2Name(id)+" "+llDumpList2String(Display, " ")    +outer,<first_random,second_random,third_random>, 1.5);
  llSetTimerEvent(10);
  typed = 1;
                
                }
            else 
                { 
                    first_random = llFrand(1.0);
                    second_random = llFrand(1.0);
                    third_random = llFrand(1.0);
                    llSetText(inner+"   "+leftc+message+rightc+"   "+outer,             <first_random,second_random,third_random>, 1.5);
typed = 1;
llSetTimerEvent(10);
                }
            
            
            Display = [];
        
        }
    
    
    }
    
    timer()
    {
        
        integer typing_or_not = llGetAgentInfo(llGetOwner()) & AGENT_TYPING; 
        
        while (typing_or_not == AGENT_TYPING)
        {
            if (ao_enabled == TRUE)
                llStartAnimation("lulz");
            first_random = llFrand(1.0);
            second_random = llFrand(1.0);
            third_random = llFrand(1.0);
            typing_or_not = llGetAgentInfo(llGetOwner()) & AGENT_TYPING;
             llSetText(inner+"  "+ typeset +"  "+outer, <first_random,second_random,third_random>, 1.5);
                //llSetText("{   Typing...   }", <first_random,second_random,third_random>, 1.5);


            
            
            //llSetTimer(.5);
            //last_status = typing_or_not;
        }
        if (typed = 1) 
        {
            if (ao_enabled == TRUE)
                llStopAnimation("lulz");
            typed = 0;
            llSetTimerEvent(10);
        }
        
        
        //llSleep(3);
        llSetText(inner+"  "+title+"  "+outer, <first_random,second_random,third_random>, 1.5);
        llSetTimerEvent(0.5);
      //llSleep(10);
    
          // llSetText("{        }", <first_random,second_random,third_random>, 1.5); 
            
        
        
            
                    
    }
}


state disabled {
    
    state_entry()
    {
       
        llListenRemove(chat0);
        llListenRemove(chat1);
        disabledChat = llListen(0, "", NULL_KEY, "");
        
     }
    
    state_exit()
    {
            llListenRemove(disabledChat);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "/enable_FCT")
            state enabled;
    
    }
    
        }
        
        
state enabled {
   state_entry() { 
  // disabledChat = 0;
   state default;}
    
    }
