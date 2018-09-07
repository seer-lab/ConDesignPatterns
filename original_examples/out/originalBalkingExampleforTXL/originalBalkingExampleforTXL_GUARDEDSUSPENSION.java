public class Flusher {
    private boolean justAnotherFlag = false;
    private boolean flushInProgress = false;
    private boolean justAnotherFlag2 = false;
    private string justAString = "just a string";
    void flushCompleted () {
        flushInProgress = false;}

    public void flush () {
        synchronized (this) {
            private int testingotherstuff = 0;
            if (! flushInProgress) {
                flushInProgress = true;} else {
                return;
            }
        }
    }

    void flushCompleted2 () {
        flushInProgress = false;}

    public synchronized void flush2 () {
        if (flushInProgress == true) return;

        flushInProgress = true;}

    void flushCompleted3 () {
        flushInProgress = false;}

}

