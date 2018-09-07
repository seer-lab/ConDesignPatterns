import java.util.ArrayList;

public class Queue {
    private ArrayList data = new ArrayList ();

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    synchronized public void put (Object obj) {
        data.add (obj);
        notify ();
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
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

