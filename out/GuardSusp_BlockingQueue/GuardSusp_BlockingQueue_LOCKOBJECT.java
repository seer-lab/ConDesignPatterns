package nl.justobjects.pushlet.core;

public class BlockingQueue {
    private int capacity = 8;
    private Object [] queue = null;
    private int front, rear;

    public BlockingQueue () {
        this (8);}

    public BlockingQueue (int capacity) {
        this.capacity = capacity; queue = new Object [capacity]; front = rear = 0;}

    public synchronized boolean enQueue (Object item) throws InterruptedException {
        return enQueue (item, - 1);
    }

    public synchronized boolean enQueue (Object item, long maxWaitTime) throws InterruptedException {
        while (isFull ()) {
            if (maxWaitTime > 0) {
                wait (maxWaitTime); if (isFull ()) {
                    return false;
                }
            } else {
                wait ();}
        } queue [rear] = item; rear = next (rear); notifyAll (); return true;
    }

    public synchronized Object deQueue () throws InterruptedException {
        return deQueue (- 1);
    }

    /*
"@LockObjectPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Creation of static method in the same class as Role 1 - getLockObject().')"
    */
    public synchronized Object deQueue (long maxWaitTime) throws InterruptedException {
        while (isEmpty ()) {
            if (maxWaitTime > 0) {
                wait (maxWaitTime); if (isEmpty ()) {
                    return null;
                }
            } else {
                wait ();}
        }
        /*
"@LockObjectPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Creation of static object in a class - lock object.')"
        */
        Object temp = queue [front];
        queue [front] = null; front = next (front); notifyAll ();
        /* "@LockObjectPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='Return of lock object, Role 1.')"*/
        return temp;
    }

    public synchronized int getSize () {
        return (rear >= front) ? (rear - front) : (capacity - front + rear);
    }

    public synchronized boolean isEmpty () {
        return front == rear;
    }

    public synchronized boolean isFull () {
        return (next (rear) == front);
    }

    private int next (int index) {
        return (index + 1 < capacity ? index + 1 : 0);
    }

    public static void p (String s) {
        System.out.println (s);}

    public static void main (String [] args) {
        BlockingQueue q = new BlockingQueue (8);
        try {
            q.enQueue ("a"); p ("(1) size = " + q.getSize ()); q.enQueue ("a"); p ("(2) size = " + q.getSize ()); q.deQueue ();
              p ("(1) size = " + q.getSize ()); q.deQueue (); p ("(0) size = " + q.getSize ()); q.enQueue ("a"); q.enQueue ("a"
              ); q.enQueue ("a"); p ("(3) size = " + q.getSize ()); q.deQueue (); p ("(2) size = " + q.getSize ()); q.enQueue (
              "a"); q.enQueue ("a"); q.enQueue ("a"); p ("(5) size = " + q.getSize ()); q.enQueue ("a"); q.enQueue ("a"); p (
              "(7) size = " + q.getSize ()); q.deQueue (); q.deQueue (); q.deQueue (); p ("(4) size = " + q.getSize ()); q.
              deQueue (); q.deQueue (); q.deQueue ();;
            q.deQueue (); p ("(0) size = " + q.getSize ()); q.enQueue ("a"); q.enQueue ("a"); q.enQueue ("a"); q.enQueue ("a");
              q.enQueue ("a"); p ("(5) size = " + q.getSize ()); q.deQueue (); q.deQueue (); q.deQueue ();;
            q.deQueue (); p ("(1) size = " + q.getSize ());} catch (InterruptedException ie) {
        }
    }

}

