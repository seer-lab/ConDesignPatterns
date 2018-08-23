import java.util.ArrayList;

public class Queue {
    private ArrayList data = new ArrayList ();

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"
     * /
    synchronized public void put (Object obj) {
        data.add (obj);
        /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"
         * /
        notify ();}

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Ensuring a method in the class is synchronized - guarded')"
     * /
    synchronized public Object get () {

        /*
   "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='Ensuring there is a while statement.')"
          * /
        while (data.size () == 0) {
        /*
 "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2aa, roleDescription='Ensuring there is a wait() statement.')"
          * /
        {
            try {
                wait ();} catch (InterruptedException e) {
            }
        }} Object obj = data.get (0);
        data.remove (0); return obj;
    }

}

