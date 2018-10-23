

//string to ascii
   string ASCII = "             \n                   !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
   integer ord(string chr)
   {
       if(llStringLength(chr) != 1) return -1;
       if(chr == " ") return 32;
       return llSubStringIndex(ASCII, chr);
   }
   
   string chr(integer i)
   {
     i %= 127;
    return llGetSubString(ASCII, i, i);
}
//

//AGENT_IMPLEMENT: take data and send to a localized server
//Hash Table Implementaton - v2.0release - By Potential Difference (ArityWolf) -eigenfruit@gmail.com-, 2017 -----------------------------------------------------

// Version: v2.0release - implemented functions in sensor
// Later On: 2018-06-19: delete() function was implemented in the past
// Version: v1.1.1- Last Updated: 2018-07-26: 1:30AM -- fixed bug in delete()
// Version: v1.1 -- Last Updated: 2018-04-05: 11:50PM -- fixed delete function (wrong subroutine)
// Version: v1.0 --    Milestone: 2018-03-19: 09:05AM -- delete (based on search())
// Version: v0.6 -- Last Updated: 2017-09-17: 09:43AM -- search  work around when hash @ 0
// Version: v0.5 -- Last Updated: 2017-08-29: 02:57PM
// Version: v0.4 -- Last Updated: 2017-08-29: 07:30AM
//
//
//
//----

//Associative Array Usage:
        //1. list data_items = init_table(data_items) 
        //2. data_items = insert("key", "data_string", data_items)
        //3. string search_result = search("key", data_items); // would return "data_string"; returns NULL_STRING if could not
        //find key.
        //4. data_items = delete("key", data_items);

// Agent_Implement Server Sweep usage:
    //sweep:    /11sweep
    //ins:      /11ins<>key<>...data...
    //change:   /11change<>key<>...data...
    //get:      /11get<>key
    //del:      /11del<>key
    
    

        
integer SIZE = 250; //hash table length
integer R = 31;
list data_items=[];
integer DEBUG = TRUE;
string NULL_STRING = "";
integer ZERO = 0;


debug(string say) { 
    if (DEBUG == TRUE)
    {
     llSay(0, say);   
    }
}



integer hash_code(string skey)
{
    integer hash=0;    
    integer slen = llStringLength(skey);
    
    integer i;
    for (i=0; i < slen; i++)
    {
        hash=(R * hash + (integer)ord(llGetSubString(skey, i, i))) % SIZE;
        
    } 
    return hash;   
}

list delete(string skey, list table)
{
 integer hash_index = hash_code(skey);

 if (hash_index==0)
    {
     if (llJsonGetValue(llList2String(table, hash_index), ["key"]) == skey)
        {
           //table = llDeleteSubList(table, hash_index, hash_index);
           //table = llListInsertList(table, [0], hash_index);
 
           table = llListReplaceList(table, [NULL_STRING], hash_index, hash_index);           
           return table;  
        } 
    }  
 
 
    while (hash_index != 0)
    {
        if (llJsonGetValue(llList2String(table, hash_index), ["key"]) == skey)
        {
           // table = llDeleteSubList(table, hash_index, hash_index);
           // table = llListInsertList(table, [0], hash_index);
            table = llListReplaceList(table, [NULL_STRING], hash_index, hash_index);
            return table;
        }    
    hash_index += 1;
    hash_index %= SIZE;
     
    }
    
 if (hash_index == 0)
     {
        if (llJsonGetValue(llList2String(table, hash_index), ["key"]) == skey)
        {
            //table = llDeleteSubList(table, hash_index, hash_index);
            //table = llListInsertList(table, [0], hash_index);
            table = llListReplaceList(table, [NULL_STRING], hash_index, hash_index);
            return table;
        }
    }
    return table;
}


string search(string skey, list table)
{
    integer hash_index = hash_code(skey);
    
    if (hash_index == 0)
    {
     if (llJsonGetValue(llList2String(table, hash_index), ["key"]) == skey)
     {
        return llJsonGetValue(llList2String(table, hash_index), ["data"]);   
     }   
    }    
    

    while(hash_index != 0) // eventually, the hash table reaches 0, O(n)--stop at that point.
    {

        if (llJsonGetValue(llList2String(table, hash_index), ["key"]) == skey)
        {
            return llJsonGetValue(llList2String(table, hash_index), ["data"]);
        }
        hash_index += 1;
        hash_index %= SIZE;
       // debug((string)hash_index);
      
    }
    
    if (hash_index == 0)
    {
        if (llJsonGetValue(llList2String(table, hash_index), ["key"]) == skey) //so if the while loop breaks @ 0...
        {
          return llJsonGetValue(llList2String(table, hash_index), ["data"]);   
         } 
    }
    return NULL_STRING;
}

list change(string skey, string data_change, list table)
{
    data_items=table; 
    data_items=delete(skey,data_items);
    data_items=insert(skey,data_change,data_items);
    
    if (DEBUG==TRUE)
        debug(search(skey, data_items));
    else    
        llOwnerSay(search(skey, data_items));
    
    return data_items;
}


list insert(string skey, string data, list table)
{ if (search(skey, table) == NULL_STRING) 
  {
    string item = "[{\"key\":, \"data\":\"}]";
    item=llJsonSetValue(item, ["key"], skey);
    item=llJsonSetValue(item, ["data"], data);
    
    integer hash_index = hash_code(skey);
        
   while( llList2Integer(table, hash_index) != 0 && llJsonGetValue( llList2String(table, hash_index), ["key"] ) != NULL_STRING ) //used to be != ZERO
   {
       hash_index += 1;
       hash_index %= SIZE;           
    }
      return llListInsertList(table, [item], hash_index);
       
    }
     return table;
    }
    
list init_table(list table_to_start)//initialize list with string "nulls"
{
   
    list alist = table_to_start;
    integer i = 0;
    while (i < SIZE) 
     {
       alist = llListInsertList(alist, [NULL_STRING], i);
       i++;
     } 
    
    return alist; 
    
}
 
set_json_val(string jsonstring)
{ } 


//End Hash Table Implementation-----------------------------------------------------------------------------------------------



list remove_null_strings(list table)
{
    integer length=llGetListLength(table);
    integer incrementor=0;
    list initial_table = table;
    list final_table;
    integer new_counter=0;
    while(incrementor < length)
    {
        if (llList2String(initial_table, incrementor) != "")
            {
            if (DEBUG==TRUE)
                debug((string)llList2String(initial_table,incrementor));
            else  
                llOwnerSay((string)llList2String(initial_table, incrementor)); 
                
             final_table = final_table + llList2String(initial_table, incrementor);  
            }
            incrementor++; 
    }
    //llOwnerSay(llDumpList2String(final_table, ""));
    return final_table;
}

push_to_server(list table)
{
   list post_table = remove_null_strings(table);
  // llOwnerSay("post table: " + llDumpList2String(post_table, ""));
   //key http_req=llHTTPRequest("http://173.27.84.101:8080/sl", [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-unencoded"],llList2CSV(post_table));
    
    
    
    }


//Agent Parser -- v0.1
//variables
integer chat_handle;
integer channel=11;


//
default
{
    state_entry()
    {  
    
        data_items = init_table(data_items);     
        chat_handle = llListen(channel, "", llGetOwner(), "");
        
       

 
     
     } 
     
     http_response(key request_id, integer status, list metadata, string body)
       {  
       if (DEBUG==TRUE)
         debug(body);
        else      
         llOwnerSay(body);
               
         
         }
   
     sensor(integer num)
     {
          
          integer i;
         for(i=0; i<num; i++)
         {  if (DEBUG==TRUE)
             debug((string)llDetectedName(i)+ " => "+(string)llDetectedKey(i));
            else
             llOwnerSay((string)llDetectedName(i)+ " => "+(string)llDetectedKey(i));
           
             data_items=insert(llDetectedName(i), (string)llDetectedKey(i)+","+(string)llGetTimestamp(), data_items);
       
             } 
        
         
         
         }
      
     listen(integer channel, string name, key id, string message)
     {
         debug(message);
         list display = llParseStringKeepNulls(message, ["<>"], []);
         if (llList2String(display, 0) == "ins")
         {
            //check to see if its a two length
             if (llGetListLength(display) == 3)
             {            
                string skey=llList2String(display,1);
                string data=llList2String(display,2);             
                data_items=insert(skey,data,data_items);
                if (DEBUG==TRUE)
                    debug(skey + " => " + data);
                else
                    llOwnerSay(skey + " => " + data);         
             }
             
          }   
        if (llList2String(display, 0)=="get")
            if (llGetListLength(display) >= 2)
                {
                    string skey= llList2String(display,1);
                    if(DEBUG==TRUE)
                        debug(search(skey, data_items));
                    else
                        llOwnerSay(search(skey, data_items));                 
                }
        if (llList2String(display, 0)=="del")
            if (llGetListLength(display) == 2)
            {
                    string skey = llList2String(display, 1);
                    data_items = delete(skey, data_items);
                }   
         if(llList2String(display,0)=="sweep")
            llSensor("", "", AGENT_BY_LEGACY_NAME, 96.0, PI);
             
         if(llList2String(display,0)=="dump")
            if(DEBUG==TRUE)
                debug(llDumpList2String(data_items, ""));
            else
                llOwnerSay(llDumpList2String(data_items, ""));
            
         if(llList2String(display,0)=="push")
            push_to_server(data_items);
                                
        if (llList2String(display,0)=="change")
            if(llGetListLength(display)==3)
                change(llList2String(display, 1), llList2String(display, 2), data_items);
            
        
    }
    
    
    
}
