import java.util.ArrayList;

public class ReadWriteLock {
    private int waitingForReadLock = 0;
    private int outstandingReadLocks = 0;
    private ArrayList < Thread > waitingForWriteLock = new ArrayList < Thread > ();
    private Thread writeLockedThread = null;
    private int heldReadingLocks = 0;
    private boolean writing = false;
    private Thread writingThread = null;

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    synchronized public void readLock () throws InterruptedException {
        while (writing && writingThread == null) {
            this.wait ();
        }
        heldReadingLocks ++;
    }

    public void writeLock () throws InterruptedException {
        writing = true;
        while (heldReadingLocks != 0) {
            Thread.sleep (1000);
        }
        writingThread = Thread.currentThread ();
        return;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    synchronized public void done () {
        if (Thread.currentThread () == this.writingThread) {
            writing = false;
            writingThread = null;
        } else {
            heldReadingLocks --;
        }
        notifyAll ();
    }

}

