// Poorly implemented hash table, finished working on at August 29, 2017 -- 2:34am -- By Potential.Difference (Kejento/ZeroPivot)
//
// 8/29/2017 -- implemented and works, but no delete function
                // Within the search function, the while loop doesn't make sense. Investigate (line 58 at this time)
//
//
//
//
//

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

integer SIZE = 200;
integer R = 31;
list data_items=[];
integer DEBUG = TRUE;
string NULL_STRING = "";

debug(string say) { 
    if (DEBUG == TRUE)
    {
     llOwnerSay(say);   
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
    
    integer list_length=llGetListLength(table);
    while(hash_index != 0)//llList2Integer(table, hash_index) != 0 ) //doesn't make much sense, fix later once you know what the real problem is...
    {
       llOwnerSay("past while");
     // llOwnerSay(llList2String(table, hash_index));
        if (llJsonGetValue(llList2String(table, hash_index), ["key"]) == skey)//(llSubStringIndex( llList2String(table, hash_index), skey) != -1)
        {
            return llJsonGetValue(llList2String(table, hash_index), ["data"]);
        }
        hash_index += 1;
        hash_index %= SIZE;
        debug((string)hash_index);
      
    } 
    return "nothing";
}
list insert(string skey, string data, list table)
{
    string item = "[{\"key\":, \"data\":\"}]";
    item=llJsonSetValue(item, ["key"], skey);
    item=llJsonSetValue(item, ["data"], data);
    
    integer hash_index = hash_code(skey);
        
   while( llList2Integer(table, hash_index) != 0 && llJsonGetValue( llList2String(table, hash_index), ["key"] ) != "" )
    //( llList2String(table, hash_index) != "" && llJsonGetValue( llList2String(table, hash_index), ["key"] ) != "" )
   {
       hash_index += 1;
       hash_index %= SIZE;           
    }
      return llListInsertList(table, [item], hash_index);
       
    }
    
list init_table(list table_to_start)//initialize list with string "nulls"
{
   
    list alist = table_to_start;
    integer i = 0;
    while (i < SIZE) 
     {
       alist = llListInsertList(alist, [0], i);
       i++;
     } 
    
    return alist; 
    
}
 
set_json_val(string jsonstring)
{ } 
default
{
    state_entry()
    {   
       data_items = init_table(data_items);
        llOwnerSay(llDumpList2String(data_items, ","));
       debug("adding items...");
       //llSleep(1);
       data_items = insert("Arity", "this_and_that2", data_items);
       data_items = insert("Potential Difference", "that_and_this", data_items);      
       data_items = insert("testing4_this", "testing4k", data_items);
       data_items = insert("testing", "testing this too", data_items);
       data_items = insert("testing2", "testing another", data_items);
       data_items = insert("testing3", "testing yet another", data_items);
        llOwnerSay(llDumpList2String(data_items, ","));
      // data_items = insert("testing4", "aye", data_items);
       
     // integer i = 0; //test inserts
     // for (i; i < SIZE; i++){
          //debug("inserting");
      //     data_items = insert("seven"+(string)i, (string)i, data_items);
       //    llOwnerSay(search("seven"+(string)i, data_items));
        //  }
     
      llOwnerSay(search("testing4", data_items));
     
      llOwnerSay(search("Arity", data_items));
      llOwnerSay(search("Potential Difference", data_items));
      llOwnerSay(search("testing4_this", data_items));
      llOwnerSay(search("testing", data_items));
      llOwnerSay(search("testing2", data_items));
      llOwnerSay(search("testing3", data_items));
    
     
     } 
    
    touch_start(integer total_number) 
    {
       
    }
}
