import java.util.ArrayList;

public class ReadWriteLock {
    private int waitingForReadLock = 0;
    private int outstandingReadLocks = 0;

    /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Thread(s) declaration - thread(s) that will be checked for an interrupt in Role 2.')"
    */
    private ArrayList < Thread > waitingForWriteLock = new ArrayList < Thread > ();

    /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Thread(s) declaration - thread(s) that will be checked for an interrupt in Role 2.')"
    */
    private Thread writeLockedThread = null;
    private int heldReadingLocks = 0;
    private boolean writing = false;

    /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=3, roleID=1, roleDescription='Thread(s) declaration - thread(s) that will be checked for an interrupt in Role 2.')"
    */
    private Thread writingThread = null;
    synchronized public void readLock () throws InterruptedException {
        while (writing && writingThread == null) {
            this.wait ();} heldReadingLocks ++;}

    public void writeLock () throws InterruptedException {
        writing = true; while (heldReadingLocks != 0) {
            Thread.sleep (1000);} writingThread = Thread.currentThread (); return;
    }

    synchronized public void done () {
        if (Thread.currentThread () == this.writingThread) {
            writing = false; writingThread = null;} else {
            heldReadingLocks --;}
        notifyAll ();}

}

