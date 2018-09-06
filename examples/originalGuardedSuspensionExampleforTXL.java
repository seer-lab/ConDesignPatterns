//*****************************************************************************************//
//*** Guarded Suspension pattern:                                                      ***//
//*** If a condition that prevents a method from executing exists, this design pattern ***//
//*** allows for the suspension of that method until that condition no longer exists . ***//
//****************************************************************************************//
import java.util.ArrayList;

public class Queue {
    private ArrayList data = new ArrayList();

	//***GuardendSuspensionPattern:  Role = 1(Ensuring a method in the class is synchronized - guarded.
    //								** Contains Role 1a.); 
    //	ID = 1.
    //***GuardendSuspensionPattern:  Role = 1a(Ensure there is a nofify() or notifyAll() statement.); 
    //	ID = 1.
    /**
     * Put an object on the end of the queue
     * @param obj the object to put at end of queue
     */
    synchronized public void put(Object obj) {
        data.add(obj);
        notify();
    } // put(Object)

    //***GuardendSuspensionPattern:  Role = 2(Ensuring a method in the class is synchronized - guarded.
    //								** Contains Role 2a.); 
    //	ID = 1.
    //***GuardendSuspensionPattern:  Role = 2a(Ensuring there is a while statement.
    //								** Contains Role 2aa.); 
    //	ID = 1.
    //***GuardendSuspensionPattern:  Role = 2aa(Ensuring there is a wait() statement.); 
    //	ID = 1.
    /**
     * Get an object from the front of the queue
     * If queue is empty, waits until it is not empty.
     */
    synchronized public Object get() {
        while (data.size() == 0){
            try {
                wait();
            } catch (InterruptedException e) {
            } // try
        } // while
        Object obj = data.get(0);
        data.remove(0);
        return obj;
    } // get()
} // class Queue
