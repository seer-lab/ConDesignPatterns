import java.util.ArrayList;

public class Queue {
    private ArrayList data = new ArrayList ();
    synchronized public void put (Object obj) {
        data.add (obj);
        notify ();
    }

    synchronized public Object get () {
        while (data.size () == 0) {
            try {
                wait ();
            } catch (InterruptedException e) {
            }
        }
        Object obj = data.get (0);
        data.remove (0);
        return obj;
    }

}

