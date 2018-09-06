//*************************************************************************//
//*** Producer Consumer pattern:                                        ***//
//*** This design pattern allows for objects or information to be       ***//
//*** produced or consumed asynchronously in a coordinated manner.      ***//
//*************************************************************************//

import java.util.ArrayList;

//***ProducerConsumerPattern:  Role = 1(Producer class - supply objects to be consumed by the Role 3, the Consumer class. 
//								** Contains Role 1a.
//								** Contains Role 1b.
//								** Contains Role 1c.);  
//	ID = 1.  
//***ProducerConsumerPattern:  Role = 1a(local instance of Role 2, the Queue.); 
//	ID = 1.  
//***ProducerConsumerPattern:  Role = 1b(local instance of produced object.); 
//ID = 1. 
//***ProducerConsumerPattern:  Role = 1c(Call to push method of Role 1a, the local instance of the Queue.  Pushes Role 1b, the produced object); 
//ID = 1.
//Role 1) Producer class – Instances of this class supply the objects to be consumed by the consumer class.  
//There will be cases where there are no instances of the consumer class to consume the instance of the 
//producer so, the producer objects are always placed in a queue.
//Producer class that produces the troubletickets.
public class Client implements Runnable {
	private Queue myQueue;
	//...
     public Client(Queue myQueue) {
      this.myQueue = myQueue;
        //...
     }
     //...
     public void run() {
    	 TroubleTicket tkt = null;
    	 //...
    	 myQueue.push(tkt);
     }
}

//***ProducerConsumerPattern:  Role = 2(Queue class - buffer between producer and consumer classes. 
//								** Contains Role 2a.
//								** Contains Role 2b.
//								** Contains Role 2c.);  
//ID = 1.  
//***ProducerConsumerPattern:  Role = 2a(Array list to house the produced objects.); 
//ID = 1.  
//***ProducerConsumerPattern:  Role = 2b(Synchronized method to push the produced objects into queue.
//								** Contains Role 2ba.
//								** Contains Role 2bb.
//								** Contains Role 2bc.); 
//ID = 1.    
//***ProducerConsumerPattern:  Role = 2ba(One of the parameters of Role 2b must have produced object.); 
//ID = 1.         
//***ProducerConsumerPattern:  Role = 2bb(Adding the produced object, Role 2ba to Role 2a, the arraylist.); 
//ID = 1.      
//***ProducerConsumerPattern:  Role = 2bc(Nofification that the thread has completed.); 
//ID = 1.  
//***ProducerConsumerPattern:  Role = 2c(Synchronized method to pull the produced objects from queue to be consumed.
//								** Contains Role 2ca.
//								** Contains Role 2cb.
//								** Contains Role 2cc.
//								** Contains Role 2cd.); 
//ID = 1.   
//***ProducerConsumerPattern:  Role = 2ca(Loop to check if queue is empty by checking size of Role 2a.
//							** Contains Role 2caa.);    
//***ProducerConsumerPattern:  Role = 2caa(Wait statement.); 
//ID = 1.    
//***ProducerConsumerPattern:  Role = 2cb(Creating instance of produced object and assigning it the 1st value in the arraylist Role 2a.); 
//ID = 1.     
//***ProducerConsumerPattern:  Role = 2cc(Remove the assigned value in Role 2cb from the arraylist Role 2a.); 
//ID = 1.     
//***ProducerConsumerPattern:  Role = 2cd(Returning the produced object - to be consumed by Role 3.); 
//ID = 1.      
//Role 2) Queue class – Instances of this class are the buffer between the producer and consumer classes.  
//The producer objects are placed in a queue object and remain there until a consumer object pulls them out.
//The Queue class buffering the consumer and producer class instances.
private class Queue {
     private ArrayList data = new ArrayList();
     //Putting objects in the queue (will be used the producer). 
     synchronized public void push (TroubleTicket tkt) {
          data.add(tkt);
          notify();
     }
     //Pulling objects from the queue (will be used by the consumer).
     synchronized public TroubleTicket pull() {
          while (data.size() == 0) {
               try {
                    wait ();
               } catch (InterruptedException e) {
               }
          }
          TroubleTicket tkt = (TroubleTicket)data.get(0);
          data.remove(0);
          return tkt;
     }
     
     public int size() {
          return data.size();
     }
}

//***ProducerConsumerPattern:  Role = 3(Consumer class - use objects to be produced by the Role 1, the Producer class. 
//							** Contains Role 3a.
//							** Contains Role 3b.
//							** Contains Role 3c.);  
//ID = 1.  
//***ProducerConsumerPattern:  Role = 3a(local instance of Role 2, the Queue.); 
//ID = 1.  
//***ProducerConsumerPattern:  Role = 3b(local instance of consumed object.); 
//ID = 1. 
//***ProducerConsumerPattern:  Role = 3c(Call to pull method of Role 3a, the local instance of the Queue.  Pulls Role 3b, the object to be consumed.); 
//ID = 1.
//Role 3) Consumer class – Instances of this class use objects produced by the producer objects.  
//As described above they pull these objects from the queue.  If the queue is empty the consumer 
//object must wait (i.e. it will not return) until the producer object puts an object in the queue.
//Consumer class that consumes the troubletickets.
public class Dispatcher implements Runnable {
	private Queue myQueue;
	//...
	 public Dispatcher (Queue myQueue) {
	      this.myQueue = myQueue;
	 }
	 //...
	 public void run() {
		 TroubleTicket tkt = myQueue.pull();
		 //...
	 }
}

