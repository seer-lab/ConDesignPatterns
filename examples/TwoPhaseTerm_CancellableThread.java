
package ORG.oclc.util;

import java.io.*;

public class CancellableThread extends Thread {

  private static final boolean debug = false;
  
  private boolean cancelled = false; // acts as latch

    private InputStream iobuf;
  
  // Issue a cancellation request
  public void cancel() {
    synchronized (this) { cancelled = true; } //set status;cannot be cleared
    interrupt();                              //waken blocked threads
    try {
        if (iobuf != null) 
            iobuf.close();
    }
    catch (Exception e) {
	if (debug)
	    e.printStackTrace();
    }
  }

  // Issue a cancellation request
  public void setInputIO(InputStream io) {
    synchronized (this) { iobuf = io; }
  }
  
  // Check cancellation status
  public boolean isCancelled() {
    if (cancelled) return true;
    synchronized (this) { return cancelled; }
  }
  
  // Convenience method to check for cancellation of current thread
  public static boolean cancelled() {
    if (Thread.currentThread() instanceof CancellableThread)
      return ((CancellableThread)(Thread.currentThread())).isCancelled();
    return false;
  }
  
  // Two-phase termination.
  // Return true if cleanly cancelled rather than forcibly killed
  public static boolean terminate(CancellableThread t, long maxWaitToDie) {

    if (t == null)
      return true;
    
    if (debug)
	System.out.println("doing terminate for " + t);


    if (!t.isAlive()) return true;  // bypass if already dead
    
    t.cancel();                     // try graceful cancellation
    
    try { t.join(maxWaitToDie); }   // wait for termination
    catch (InterruptedException ex) {} // ignore interrupts
    
    if (!t.isAlive()) return true;  // successful cancellation
    
    // destroy is preferred method but it does not exist yet
    //t.destroy();                    // kill by forcing
    //    t.stop();
    
    return false;
  }
  
  // Plus constructors
  public CancellableThread() { super(); }
  public CancellableThread(Runnable r) { super(r); }
  public CancellableThread(ThreadGroup g, Runnable r) { super(g, r); }
  public CancellableThread(Runnable r, String n) { super(r, n); }
  public CancellableThread(ThreadGroup g, String n) { super(g, n); }
  public CancellableThread(ThreadGroup g, Runnable r, String n) { 
    super(g, r, n); 
  }
}

