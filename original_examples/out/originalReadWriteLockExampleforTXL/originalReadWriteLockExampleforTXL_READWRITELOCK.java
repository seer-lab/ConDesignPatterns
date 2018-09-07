import java.util.*;

public class Bid {
    private int bid = 0;
    private ReadWriteLock lockManager = new ReadWriteLock ();
    public int getBid () throws InterruptedException {
        lockManager.readLock (); int bid = this.bid;
        lockManager.done (); return bid;
    }

    public void setBid (int bid) throws InterruptedException {
        lockManager.writeLock (); if (bid > this.bid) {
            this.bid = bid;}
        lockManager.done ();}

}

public class ReadWriteLock {
    private int waitingForReadLock = 0;
    private int outstandingReadLocks = 0;
    @SuppressWarnings("unchecked")
    private ArrayList waitingForWriteLock = new ArrayList ();
    private Thread writeLockedThread;

    /*
   "@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Synchronized method to issue a read 
      lock.')"*/
    synchronized public void readLock () throws InterruptedException {

        /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=1a, roleDescription='Boolean check if the designated writeLockedThread has the write lock.')"
        */
        if (writeLockedThread != null) {
            {

                /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=1aa, roleDescription='Increment designated waitingForReadLock counter variable by 1.')"
                */
                waitingForReadLock ++;
                /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=1ab, roleDescription='Loop iteratively checking if the designated writeLockedThread has the write lock.')"
                */
                while (writeLockedThread != null) {
                /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=1aba, roleDescription='wait() is called to pause further processing.')"
                */
                {
                    wait ();}}
                /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=1ac, roleDescription='Decrement designated waitingForReadLock counter variable by 1.')"
                */
                waitingForReadLock --;}}

        /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=1b, roleDescription='Increment designated outstandingReadLocks counter variable by 1.')"
        */
        outstandingReadLocks ++;}

    /* "@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Method to issue a write lock.')"*/
    @SuppressWarnings("unchecked")
    public void writeLock () throws InterruptedException {
        Thread thisThread;

        /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2b, roleDescription='Critical section creation by synchronization of this writeLock method.')"
        */
        synchronized (this) {
            {

                /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2ba, roleDescription='Within Role 2b checking if the designated writeLockedThread is null and designated outstandingReadLocks counter variable is zero.')"
                */
                if (writeLockedThread == null && outstandingReadLocks == 0) {
                    {

                        /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2baa, roleDescription='Assign the current thread to the designated writeLockedThread.')"
                        */
                        writeLockedThread = Thread.currentThread ();
                        /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2bab, roleDescription='Return to the calling object that is using this method Role 2 of an instance of this object Role 1.')"
                        */
                        return;
                    }}

                /*
  "@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2bac, roleDescription='Make thread Role 2a the current 
                  thread.')"*/
                thisThread = Thread.currentThread ();
                /*
         "@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2bad, roleDescription='Add thread Role 2a to 
                  arraylist.')"*/
                waitingForWriteLock.add (thisThread);}}

        /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2c, roleDescription='Critical section creation by synchronization of thread Role 2a.')"
        */
        synchronized (thisThread) {
            {

                /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2ca, roleDescription='A loop within critical section Role 2c to check if the new thread Role 2a is NOT the same as the designated writeLockedThread.')"
                */
                while (thisThread != writeLockedThread) {
                /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2caa, roleDescription='New thread Role 2a is placed in a waiting state until method Role 3 wakes it up using a nofityAll().')"
                */
                {
                    thisThread.wait ();}}}}

        /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2d, roleDescription='Critical section creation by synchronization of this writelock method.')"
        */
        synchronized (this) {
            {

                /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=2da, roleDescription='Remove current thread (Role 2a) from the arraylist of waiting threads.')"
                */
                waitingForWriteLock.remove (thisThread);}}
    }

    /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=3, roleDescription='Synchronized method called when the current thread is finished with resource.')"
    */
    synchronized public void done () {
        if (outstandingReadLocks > 0) {
            {
                outstandingReadLocks --; if (outstandingReadLocks == 0 && waitingForWriteLock.size () > 0) {
                    writeLockedThread = (Thread) waitingForWriteLock.get (0); writeLockedThread.notifyAll ();}
            }} else if (Thread.currentThread () == writeLockedThread) {
            {
                if (outstandingReadLocks == 0 && waitingForWriteLock.size () > 0) {
                    {
                        writeLockedThread = (Thread) waitingForWriteLock.get (0); writeLockedThread.notifyAll ();}} else {
                    writeLockedThread = null; if (waitingForReadLock > 0) {

                        /*
"@ReadWriteLockPatternAnnotation(patternInstanceID=1, roleID=3a, roleDescription='NotifyAll to wake up other waiting 
                          threads.')"*/
                        notifyAll ();}
                }
            }} else {
            String msg = "Thread does not have lock";
            throw new IllegalStateException (msg);
        }

    }

}

