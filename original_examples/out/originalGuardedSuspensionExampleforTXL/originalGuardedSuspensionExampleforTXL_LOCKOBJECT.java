import java.util.ArrayList;

public class Queue {
    private ArrayList data = new ArrayList ();
    synchronized public void put (Object obj) {
        data.add (obj); notify ();}

    /*
"@LockObjectPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Creation of static method in the same class as Role 1 - getLockObject().')"
    */
    synchronized public Object get () {
        while (data.size () == 0) {
            try {
                wait ();} catch (InterruptedException e) {
            }
        }
        /*
"@LockObjectPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Creation of static object in a class - lock object.')"
        */
        Object obj = data.get (0);
        data.remove (0);
        /* "@LockObjectPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='Return of lock object, Role 1.')"*/
        return obj;
    }

}

