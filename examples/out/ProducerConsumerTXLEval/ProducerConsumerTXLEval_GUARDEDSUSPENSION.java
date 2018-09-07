import java.util.Random;

import java.util.ArrayList;

public class Producer implements Runnable {
    private final int life_;
    private final BufferQueue queue_;

    public Producer (final BufferQueue q) {
        life_ = new Random ().nextInt (500); queue_ = q;}

    @Override
    public void run () {
        for (int x = 0;
        x < life_; x ++) {
            final int value = new Random ().nextInt (2);
            queue_.push (value);}
    }

}

public class BufferQueue {
    private final ArrayList < Integer > data = new ArrayList < Integer > ();
    public int getSize () {
        return data.size ();
    }

    synchronized public Integer pull () {
        if (data.size () == 0) try {
            wait (1000); if (data.size () == 0) return null;

        } catch (final Exception e) {
        }

        final int i = data.get (0);
        data.remove (0); return i;
    }

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    synchronized public void push (final Integer value) {
        data.add (value);
        /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"
        */
        notify ();}

}

public class Consumer implements Runnable {
    private final BufferQueue queue_;

    public Consumer (final BufferQueue q) {
        queue_ = q;}

    @Override
    public void run () {
        int total = 0;
        Integer i = queue_.pull ();
        while (i != null) {
            total += i; i = queue_.pull ();} System.out.println (total);}

}

