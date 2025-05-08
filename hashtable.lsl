//Hash Table Implementaton - v0.5 - By Potential Difference (Kejento), 2017 
//
// 8/29/2017 -- implemented and works, but no delete function
// Version: v0.5 -- Last Updated: 2017-08-29: 2:57PM
// Version: v0.4 -- Last Updated: 2017-08-29: 7:30AM
//
//
//


//Usage:
        //1. list data_items = init_table(data_items) 
        //2. data_items = insert("key", "data_string", data_items)
        //3. string search_result = search("key", data_items); // would return "data_string"; returns NULL_STRING if could not
        //find key.
        
integer SIZE = 200; //hash table length
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
    

    while(hash_index != 0) // eventually, the hash table reaches 0, O(n)--stop at that point.
    {

        if (llJsonGetValue(llList2String(table, hash_index), ["key"]) == skey)
        {
            return llJsonGetValue(llList2String(table, hash_index), ["data"]);
        }
        hash_index += 1;
        hash_index %= SIZE;
      //  debug((string)hash_index);
      
    } 
    return NULL_STRING;
}

list insert(string skey, string data, list table)
{
    string item = "[{\"key\":, \"data\":\"}]";
    item=llJsonSetValue(item, ["key"], skey);
    item=llJsonSetValue(item, ["data"], data);
    
    integer hash_index = hash_code(skey);
        
   while( llList2Integer(table, hash_index) != 0 && llJsonGetValue( llList2String(table, hash_index), ["key"] ) != "" )
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

list delete(string skey, list table)
{
    integer hash_index = hash_code(skey);

    while (hash_index != 0) // Traverse the hash table until it reaches the end or finds the key
    {
        if (llJsonGetValue(llList2String(table, hash_index), ["key"]) == skey) 
        {
            // Found the key, now remove it
            string removed_item = "[{\"key\":\"\", \"data\":\"\"}]"; // Replace the key and data with empty values
            table = llListReplaceList(table, [removed_item], hash_index, hash_index);
            return table; // Return the updated table
        }
        hash_index += 1;
        hash_index %= SIZE; // Wrap around the table
    }
    debug("Key not found for deletion.");
    return table; // Return the original table if the key is not found
}

//End Hash Table Implementation
