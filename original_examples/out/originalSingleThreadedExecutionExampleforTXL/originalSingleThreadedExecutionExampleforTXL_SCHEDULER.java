class HoldDatum {
    private Datum datum;
    public static void test () {
    }

    public synchronized void set (Datum d) {
        datum = d;}

    public static void test2 () {
    }

    public synchronized Datum get () {
        return datum;
    }

    public static void test3 () {
    }

}

