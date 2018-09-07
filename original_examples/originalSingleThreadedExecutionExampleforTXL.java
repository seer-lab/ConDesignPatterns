class HoldDatum {
    private Datum datum;
    
    public static void test(){
    
    }
    
    //***SingleThreadedExecutionPattern:  Role = 1(Use of synchronized keyword, Java's way of implementing a guarded method); ID = 1.
    public synchronized void set (Datum d) { datum = d; }
    
    public static void test2(){
    
    }
    
    //***SingleThreadedExecutionPattern:  Role = 1(Use of synchronized keyword (Java's way of implementing a guarded method); ID = 2.
    public synchronized Datum get () { return datum; }
    
    public static void test3(){
    
    }
}
