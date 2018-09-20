package nl.justobjects.pushlet.core;

public class EventQueue {
    private int capacity = 8;
    private Event [] queue = null;
    private int front, rear;

    public EventQueue () {
        this (8);
    }

    public EventQueue (int capacity) {
        this.capacity = capacity;
        queue = new Event [capacity];
        front = rear = 0;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized boolean enQueue (Event item) throws InterruptedException {
        return enQueue (item, - 1);
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized boolean enQueue (Event item, long maxWaitTime) throws InterruptedException {
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
    public synchronized Event deQueue () throws InterruptedException {
        return deQueue (- 1);
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=4, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized Event deQueue (long maxWaitTime) throws InterruptedException {
        while (isEmpty ()) {
            if (maxWaitTime >= 0) {
                wait (maxWaitTime);
                if (isEmpty ()) {
                    return null;
                }
            } else {
                wait ();
            }
        }
        Event result = fetchNext ();
        notifyAll ();
        return result;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=5, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized Event [] deQueueAll (long maxWaitTime) throws InterruptedException {
        while (isEmpty ()) {
            if (maxWaitTime >= 0) {
                wait (maxWaitTime);
                if (isEmpty ()) {
                    return null;
                }
            } else {
                wait ();
            }
        }
        Event [] events = new Event [getSize ()];
        for (int i = 0;
        i < events.length; i ++) {
            events [i] = fetchNext ();
        }
        notifyAll ();
        return events;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=6, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized int getSize () {
        return (rear >= front) ? (rear - front) : (capacity - front + rear);
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=7, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized boolean isEmpty () {
        return front == rear;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=8, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized boolean isFull () {
        return (next (rear) == front);
    }

    private int next (int index) {
        return (index + 1 < capacity ? index + 1 : 0);
    }

    private Event fetchNext () {
        Event temp = queue [front];
        queue [front] = null;
        front = next (front);
        return temp;
    }

    public static void p (String s) {
        System.out.println (s);
    }

    public static void main (String [] args) {
        EventQueue q = new EventQueue (8);
        Event event = new Event ("t");
        try {
            q.enQueue (event);
            p ("(1) size = " + q.getSize ());
            q.enQueue (event);
            p ("(2) size = " + q.getSize ());
            q.deQueue ();
            p ("(1) size = " + q.getSize ());
            q.deQueue ();
            p ("(0) size = " + q.getSize ());
            q.enQueue (event);
            q.enQueue (event);
            q.enQueue (event);
            p ("(3) size = " + q.getSize ());
            q.deQueue ();
            p ("(2) size = " + q.getSize ());
            q.enQueue (event);
            q.enQueue (event);
            q.enQueue (event);
            p ("(5) size = " + q.getSize ());
            q.enQueue (event);
            q.enQueue (event);
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
            q.enQueue (event);
            q.enQueue (event);
            q.enQueue (event);
            q.enQueue (event);
            q.enQueue (event);
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

