// Copyright (c) 2000 Just Objects B.V. <just@justobjects.nl>
// Distributable under LGPL license. See terms of license at gnu.org.

package nl.justobjects.pushlet.core;

/**
 * FIFO queue with guarded suspension.
 * <b>Purpose</b><br>
 * <p>
 * <b>Implementation</b><br>
 * FIFO queue class implemented with circular array. The enQueue() and
 * deQueue() methods use guarded suspension according to a readers/writers
 * pattern, implemented with java.lang.Object.wait()/notify().
 *
 * <b>Examples</b><br>
 * <p>
 * <br>
 *
 * @version $Id: BlockingQueue.java,v 1.3 2003/08/15 08:37:40 justb Exp $
 * @author Just van den Broecke - Just Objects &copy;
 */
public class BlockingQueue {
        /** Defines maximum queue size */
        private int capacity = 8;
        private Object[] queue = null;
        private int front, rear;

        /** Construct queue with default (8) capacity. */
        public BlockingQueue() {
                this(8);
        }

        /** Construct queue with specified capacity. */
        public BlockingQueue(int capacity) {
                this.capacity = capacity;
                queue = new Object[capacity];
                front = rear = 0;
        }

        /** Put item in queue; waits() indefinitely if queue is full. */
        public synchronized boolean enQueue(Object item) throws InterruptedException {
                return enQueue(item, -1);
        }

        /** Put item in queue; if full wait maxtime. */
        public synchronized boolean enQueue(Object item, long maxWaitTime) throws InterruptedException {

                // Wait (optional maxtime) as long as the queue is full
                while (isFull()) {
                        if (maxWaitTime > 0) {
                                // Wait at most maximum time
                                wait(maxWaitTime);

                                // Timed out or woken; if still full we
                                // had bad luck and return failure.
                                if (isFull()) {
                                        return false;
                                }
                        }
                        else {
                                wait();
                        }
                }

                // Put item in queue
                queue[rear] = item;
                rear = next(rear);

                // Wake up waiters; NOTE: first waiter will eat item
                notifyAll();
                return true;
        }

        /** Get head; if empty wait until something in queue. */
        public synchronized Object deQueue() throws InterruptedException {
                return deQueue(-1);
        }

        /** Get head; if empty wait for specified time at max. */
        public synchronized Object deQueue(long maxWaitTime) throws InterruptedException {
                while (isEmpty()) {
                        if (maxWaitTime > 0) {
                                wait(maxWaitTime);

                                // Timed out or woken; if still empty we
                                // had bad luck and return failure.
                                if (isEmpty()) {
                                        return null;
                                }
                        }
                        else {
                                // Wait indefinitely for something in queue.
                                wait();
                        }
                }

                // Dequeue item
                Object temp = queue[front];
                queue[front] = null;
                front = next(front);

                // Notify possible wait()-ing enQueue()-ers
                notifyAll();

                // Return dequeued item
                return temp;
        }

        public synchronized int getSize() {
                return (rear >= front) ? (rear - front) : (capacity - front + rear);
        }

        /** Is the queue empty ? */
        public synchronized boolean isEmpty() {
                return front == rear;
        }

        /** Is the queue full ? */
        public synchronized boolean isFull() {
                return (next(rear) == front);
        }

        /** Circular counter. */
        private int next(int index) {
                return (index + 1 < capacity ? index + 1 : 0);
        }

        public static void p(String s) {
                System.out.println(s);
        }

        public static void main(String[] args) {
                BlockingQueue q = new BlockingQueue(8);
                try {
                        q.enQueue("a");
                        p("(1) size = " + q.getSize());
                        q.enQueue("a");
                        p("(2) size = " + q.getSize());
                        q.deQueue();
                        p("(1) size = " + q.getSize());
                        q.deQueue();
                        p("(0) size = " + q.getSize());

                        q.enQueue("a");
                        q.enQueue("a");
                        q.enQueue("a");
                        p("(3) size = " + q.getSize());
                        q.deQueue();
                        p("(2) size = " + q.getSize());
                        q.enQueue("a");
                        q.enQueue("a");
                        q.enQueue("a");
                        p("(5) size = " + q.getSize());
                        q.enQueue("a");
                        q.enQueue("a");
                        p("(7) size = " + q.getSize());
                        q.deQueue();
                        q.deQueue();
                        q.deQueue();
                        p("(4) size = " + q.getSize());
                        q.deQueue();
                        q.deQueue();
                        q.deQueue();
                        ;
                        q.deQueue();
                        p("(0) size = " + q.getSize());

                        q.enQueue("a");
                        q.enQueue("a");
                        q.enQueue("a");
                        q.enQueue("a");
                        q.enQueue("a");
                        p("(5) size = " + q.getSize());

                        q.deQueue();
                        q.deQueue();
                        q.deQueue();
                        ;
                        q.deQueue();
                        p("(1) size = " + q.getSize());
                }
                catch (InterruptedException ie) {
                }
        }
}

 /*
 * $Log: BlockingQueue.java,v $
 * Revision 1.3  2003/08/15 08:37:40  justb
 * fix/add Copyright+LGPL file headers and footers
 *
 *
 */
