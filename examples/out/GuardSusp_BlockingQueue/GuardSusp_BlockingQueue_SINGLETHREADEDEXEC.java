package nl.justobjects.pushlet.core;

public class BlockingQueue {
    private int capacity = 8;
    private Object [] queue = null;
    private int front, rear;

    public BlockingQueue () {
        this (8);
    }

    public BlockingQueue (int capacity) {
        this.capacity = capacity;
        queue = new Object [capacity];
        front = rear = 0;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized boolean enQueue (Object item) throws InterruptedException {
        return enQueue (item, - 1);
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized boolean enQueue (Object item, long maxWaitTime) throws InterruptedException {
        while (isFull ()) {
            if (maxWaitTime > 0) {
                wait (maxWaitTime);
                if (isFull ()) {
                    return false;
                }
            } else {
                wait ();
            }
        }
        queue [rear] = item;
        rear = next (rear);
        notifyAll ();
        return true;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=3, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized Object deQueue () throws InterruptedException {
        return deQueue (- 1);
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=4, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized Object deQueue (long maxWaitTime) throws InterruptedException {
        while (isEmpty ()) {
            if (maxWaitTime > 0) {
                wait (maxWaitTime);
                if (isEmpty ()) {
                    return null;
                }
            } else {
                wait ();
            }
        }
        Object temp = queue [front];
        queue [front] = null;
        front = next (front);
        notifyAll ();
        return temp;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=5, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized int getSize () {
        return (rear >= front) ? (rear - front) : (capacity - front + rear);
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=6, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized boolean isEmpty () {
        return front == rear;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=7, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized boolean isFull () {
        return (next (rear) == front);
    }

    private int next (int index) {
        return (index + 1 < capacity ? index + 1 : 0);
    }

    public static void p (String s) {
        System.out.println (s);
    }

    public static void main (String [] args) {
        BlockingQueue q = new BlockingQueue (8);
        try {
            q.enQueue ("a");
            p ("(1) size = " + q.getSize ());
            q.enQueue ("a");
            p ("(2) size = " + q.getSize ());
            q.deQueue ();
            p ("(1) size = " + q.getSize ());
            q.deQueue ();
            p ("(0) size = " + q.getSize ());
            q.enQueue ("a");
            q.enQueue ("a");
            q.enQueue ("a");
            p ("(3) size = " + q.getSize ());
            q.deQueue ();
            p ("(2) size = " + q.getSize ());
            q.enQueue ("a");
            q.enQueue ("a");
            q.enQueue ("a");
            p ("(5) size = " + q.getSize ());
            q.enQueue ("a");
            q.enQueue ("a");
            p ("(7) size = " + q.getSize ());
            q.deQueue ();
            q.deQueue ();
            q.deQueue ();
            p ("(4) size = " + q.getSize ());
            q.deQueue ();
            q.deQueue ();
            q.deQueue ();
            ;
            q.deQueue ();
            p ("(0) size = " + q.getSize ());
            q.enQueue ("a");
            q.enQueue ("a");
            q.enQueue ("a");
            q.enQueue ("a");
            q.enQueue ("a");
            p ("(5) size = " + q.getSize ());
            q.deQueue ();
            q.deQueue ();
            q.deQueue ();
            ;
            q.deQueue ();
            p ("(1) size = " + q.getSize ());
        } catch (InterruptedException ie) {
        }
    }

}

