class HoldDatum {
    private Datum datum;

    public static void test () {
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized void set (Datum d) {
        datum = d;
    }

    public static void test2 () {
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized Datum get () {
        return datum;
    }

    public static void test3 () {
    }

}

