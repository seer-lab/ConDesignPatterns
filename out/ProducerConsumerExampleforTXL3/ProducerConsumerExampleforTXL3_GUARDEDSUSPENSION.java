package org.exoplatform.services.threadpool.impl;

import java.util.ArrayList;

public class Queue {
    private ArrayList data = new ArrayList ();
    private int maxQueueSize = Integer.MAX_VALUE;

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    synchronized public void put (Object obj) throws InterruptedException {
        if (Thread.currentThread ().isInterrupted ()) throw new InterruptedException ();

        if (obj == null) throw new IllegalArgumentException ("null");

        while (data.size () >= maxQueueSize) {
            try {
                wait ();} catch (InterruptedException e) {
                return;
            }
        } data.add (obj);
        /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"
        */
        notify ();}

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    synchronized public boolean put (Object obj, long msecs) throws InterruptedException {
        if (Thread.currentThread ().isInterrupted ()) throw new InterruptedException ();

        if (obj == null) throw new IllegalArgumentException ("null");

        long startTime = System.currentTimeMillis ();
        long waitTime = msecs;
        while (data.size () >= maxQueueSize) {
            waitTime = msecs - (System.currentTimeMillis () - startTime); if (waitTime <= 0) return false;

            wait (waitTime);} data.add (obj);
        /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=2, roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"
        */
        notify (); return true;
    }

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=3, roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    synchronized public Object get () throws InterruptedException {
        while (data.size () == 0) {
            wait ();} Object obj = data.remove (0);

        /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=3, roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"
        */
        notify (); return obj;
    }

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=4, roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    synchronized public Object get (long msecs) throws InterruptedException {
        long startTime = System.currentTimeMillis ();
        long waitTime = msecs;
        if (data.size () > 0) return data.remove (0);

        while (true) {
            waitTime = msecs - (System.currentTimeMillis () - startTime); if (waitTime <= 0) return null;

            wait (waitTime); if (data.size () > 0) {
                Object obj = data.remove (0);

                /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=4, roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"
                */
                notify (); return obj;
            }
        }}

    public void setMaxQueueSize (int newValue) {
        maxQueueSize = newValue;}

}

