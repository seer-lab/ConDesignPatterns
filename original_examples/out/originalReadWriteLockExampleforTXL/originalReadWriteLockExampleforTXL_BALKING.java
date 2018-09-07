import java.util.*;

public class Bid {
    private int bid = 0;
    private ReadWriteLock lockManager = new ReadWriteLock ();
    public int getBid () throws InterruptedException {
        lockManager.readLock ();
        int bid = this.bid;
        lockManager.done ();
        return bid;
    }

    public void setBid (int bid) throws InterruptedException {
        lockManager.writeLock ();
        if (bid > this.bid) {
            this.bid = bid;
        }
        lockManager.done ();
    }

}

public class ReadWriteLock {
    private int waitingForReadLock = 0;
    private int outstandingReadLocks = 0;
    @SuppressWarnings("unchecked")
    private ArrayList waitingForWriteLock = new ArrayList ();
    private Thread writeLockedThread;
    synchronized public void readLock () throws InterruptedException {
        if (writeLockedThread != null) {
            waitingForReadLock ++;
            while (writeLockedThread != null) {
                wait ();
            }
            waitingForReadLock --;
        }
        outstandingReadLocks ++;
    }

    @SuppressWarnings("unchecked")
    public void writeLock () throws InterruptedException {
        Thread thisThread;
        synchronized (this) {
            if (writeLockedThread == null && outstandingReadLocks == 0) {
                writeLockedThread = Thread.currentThread ();
                return;
            }
            thisThread = Thread.currentThread ();
            waitingForWriteLock.add (thisThread);
        }
        synchronized (thisThread) {
            while (thisThread != writeLockedThread) {
                thisThread.wait ();
            }
        }
        synchronized (this) {
            waitingForWriteLock.remove (thisThread);
        }
    }

    synchronized public void done () {
        if (outstandingReadLocks > 0) {
            outstandingReadLocks --;
            if (outstandingReadLocks == 0 && waitingForWriteLock.size () > 0) {
                writeLockedThread = (Thread) waitingForWriteLock.get (0);
                writeLockedThread.notifyAll ();
            }
        } else if (Thread.currentThread () == writeLockedThread) {
            if (outstandingReadLocks == 0 && waitingForWriteLock.size () > 0) {
                writeLockedThread = (Thread) waitingForWriteLock.get (0);
                writeLockedThread.notifyAll ();
            } else {
                writeLockedThread = null;
                if (waitingForReadLock > 0) notifyAll ();

            }
        } else {
            String msg = "Thread does not have lock";
            throw new IllegalStateException (msg);
        }

    }

}

