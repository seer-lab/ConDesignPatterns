package ORG.oclc.util;

import java.io.*;

public class CancellableThread extends Thread {
    private static final boolean debug = false;
    private boolean cancelled = false;
    private InputStream iobuf;
    public void cancel () {
        synchronized (this) {
            cancelled = true;}
        interrupt (); try {
            if (iobuf != null) iobuf.close ();
        } catch (Exception e) {
            if (debug) e.printStackTrace ();
        }
    }

    public void setInputIO (InputStream io) {
        synchronized (this) {
            iobuf = io;}
    }

    public boolean isCancelled () {
        if (cancelled) return true;

        synchronized (this) {
            return cancelled;
        }
    }

    public static boolean cancelled () {
        if (Thread.currentThread () instanceof CancellableThread) return ((CancellableThread) (Thread.currentThread ())).
          isCancelled ();

        return false;
    }

    public static boolean terminate (CancellableThread t, long maxWaitToDie) {
        if (t == null) return true;

        if (debug) System.out.println ("doing terminate for " + t);
        if (! t.isAlive ()) return true;

        t.cancel (); try {
            t.join (maxWaitToDie);} catch (InterruptedException ex) {
        }
        if (! t.isAlive ()) return true;

        return false;
    }

    public CancellableThread () {
        super ();}

    public CancellableThread (Runnable r) {
        super (r);}

    public CancellableThread (ThreadGroup g, Runnable r) {
        super (g, r);}

    public CancellableThread (Runnable r, String n) {
        super (r, n);}

    public CancellableThread (ThreadGroup g, String n) {
        super (g, n);}

    public CancellableThread (ThreadGroup g, Runnable r, String n) {
        super (g, r, n);}

}

