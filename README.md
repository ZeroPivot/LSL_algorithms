# LSL_hashtable
A basic hashtable implemented in the Linden Scripting Language

Usage:
 1. list data_items = init_table(data_items) 
 2. data_items = insert("key", "data_string", data_items)
 3. string search_result = search("key", data_items); // would return "data_string"; returns NULL_STRING if could not find key.
