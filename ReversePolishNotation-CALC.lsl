//Reverse Polish Notation calculator
//By Potential Difference, 2010

string CALCULATIONS="+-^*/";
integer ADD=0;
integer SUB=1;
integer EXP=2;
integer MLT=3;
integer DIV=4;
string NULL_STRING = "";
integer listen_handle;
list message_list;
integer message_length;
integer DEBUG = TRUE;

debug(string message)
{
    if (DEBUG == TRUE)
        llWhisper(0, message);
}

default
{    
    
    state_entry()
    {
    
       listen_handle = llListen(0, NULL_STRING, llGetOwner(), "/calc");
    } 
    
    listen(integer channel, string name, key id, string message)
    {
      llListenRemove(listen_handle);
      state setup;
           
    }
    
}

state setup
{
    
 state_entry()
 {
     llWhisper(0, "Accepting next message as input...");
     listen_handle = llListen(0, NULL_STRING, llGetOwner(), NULL_STRING);
     
  }   
    
 listen(integer channel, string name, key id, string _message)
 {   
   message_length = llStringLength(_message);
   message_list = llParseString2List(_message,[" "],[]);
   llListenRemove(listen_handle); 
   state calculate;
  }//end listen   
    
    
    
}//end state
// while
state calculate
{
 state_entry()
 {
   integer lLength = llGetListLength(message_list);
   integer count = 0;
   list stack;
   string temp;
   string e1; string e2;
   while (count < lLength) 
   {
       temp = llList2String(message_list,count);
       if (llSubStringIndex(CALCULATIONS,temp) == -1)
       {
           stack = temp + stack;
       }
       else
       {
          e1 = llList2String(stack, 0); 
          stack = llDeleteSubList(stack,0,0);
          e2 = llList2String(stack, 0);
          stack = llDeleteSubList(stack,0,0); 
             
          if (llSubStringIndex(CALCULATIONS, temp) == MLT)
          {stack = ((float)e2 * (float)e1) + stack;
           debug((string)e2 + "*" + (string)e1);
          }
          else
          if (llSubStringIndex(CALCULATIONS, temp) == ADD)
          {stack = ((float)e2 + (float)e1) + stack;
           debug((string)e2 + "+" + (string)e1);
          }
          else 
          if(llSubStringIndex(CALCULATIONS, temp) == SUB)
          {stack = ((float)e2 - (float)e1) + stack;
            debug((string)e2 + "-" + (string)e1);
          }
          else
          if(llSubStringIndex(CALCULATIONS, temp) == DIV)
          {stack = ((float)e2 / (float)e1) + stack;
          debug((string)e2 + "/" + (string)e1);
          }
          else
          if(llSubStringIndex(CALCULATIONS, temp) == EXP)
          {stack = llPow((float)e2,(float)e1) + stack;
           debug((string)e2 + "^" + (string)e1);
            }        
           
       }
       ++count;
      }
      
      if (llGetListLength(stack) > 1) {llWhisper(0, "Error: too many/invalid arguments");state default;}
     else
     {llSay(0, llList2String(stack,0));state default;}
 }
 
 
}

