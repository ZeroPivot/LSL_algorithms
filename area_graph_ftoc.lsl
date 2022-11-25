


    float function(float x)
    {
    
        return x*x*llSin(x);
        
        
    }
    
    
  
    
    curve(float offset2, float delta_time2, float constant_multiplier, float const_adder, integer i2)
    {
        
        float offset3 = llSqrt(offset2*offset2);
         
         llRezAtRoot("Plane2", llGetLocalPos() + <offset2,.01,(.5*function(offset2)*delta_time2*constant_multiplier)+const_adder>, ZERO_VECTOR, ZERO_ROTATION, i2);   
        llSay(i2, "<" + (string)((delta_time2*constant_multiplier)+const_adder) + "," + (string).5 + "," + (string)((function(offset3)*delta_time2*constant_multiplier)+const_adder) + ">");
       // i++;
        
        
}
    
    
    calcarea (integer n, integer a, integer b)
    
{        
    integer maximum = (integer)function(b);
    integer minumum = (integer)function(a);
    integer n_splits = n;
    float delta_time = (  (float)(b-a) / (float)(n_splits)  );
    
    
    
    llWhisper(0, (string)a);
    llWhisper(0, (string)delta_time);
    
    float offset;
    
    integer number = 0;
    list values;
    
    
    integer i;
    
    //Stopped here; this is an offset problem and not so much a summation
    
    if (b < 0) //Offset starts at b and goes to a (negative area)
    {
        llSay(0, "a");
        i=0;
        offset = a*b;
        
        while (offset >= a)
        {
            
        curve(offset, delta_time, 1, .01, i);    
        
        offset += delta_time;
        i++;
        
        }
        
       // while (offset
        
         
        }
    
    else
    if ((a < 0) && (b > 0)) //offset starts all the way at b and stops at 0, then goes to a (positive to negative area)
    {
        llSay(0, "b");
        i=0;
        offset = b;
        while (offset >= 0)
            {
                curve(offset, delta_time, 1, .01, i);
                offset -= delta_time;
                i++;
                
            
            }
            
        
        while (offset <= llAbs(a))
        {
            curve(-offset, delta_time, 1, .01, i);
            offset += delta_time;
            i++;
        
        }
        
        
    }
 else
   if (b > 0 && a == 0) //integral from  positive to 0
   {
    llSay(0, "c");
    i=0;
    offset = b;
    while (offset >= 0)
        {
            curve(offset, delta_time, 1, .01, i);
            offset -= delta_time;
            i++;
        }
    
    
    }
    
    else    
   if (a < 0 && b == 0) //integral from negative to 0
   {
       i=0;
       offset = a*delta_time;
       while (offset <= 0)
       {
            curve(offset, delta_time, 1, .01, i); //.01
            offset += delta_time;
            i++;
        
        
        }
    
             
    }         
        
  //  for (i = 0; i <= n; i++)        
   // {    
  //    llRezAtRoot("Plane2", llGetLocalPos() + <offset,.01,(.5*function(a+i)*delta_time*.04)+.01>, ZERO_VECTOR, ZERO_ROTATION, i);   
       // llGo
    //  offset+=((delta_time*.04)+.01);
    //  llSleep(.5);
    //  llSay(i, "<" + (string)((delta_time*.04)+.01) + "," + (string).5 + "," + (string)((function(a+i)*delta_time*.04)+.01) + ">");
//llWhisper(0, "<" + (string)(delta_time*.01) + "," + (string).5 + "," + (string)(function(i)*delta_time*.045) + ">");
      
      //llSetScale(<delta_time, .5, function(offset)>);    
    
            
   // } 
    
    
    //for (i = 0; i <= n-1; i++)
    //    llSay(i,      
        
         
}
 


default
{
    state_entry()
    {
       
       
       
    }

    touch_start(integer total_number)
    {
        //llSay(0, "Touched.");
        llSay( 0, (string)llGetLocalPos() );
        calcarea(300, -10, 20);
    }
    
    

    
    
}
