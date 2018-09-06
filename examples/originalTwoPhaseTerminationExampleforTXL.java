//*******************************************************************************************//
//*** Two Phase Termination pattern:                                                      ***//
//*** This concurrency design pattern basically provides functionality to shutdown a      ***//  
//*** thread or process in an orderly manner (i.e. allowing for cleanup, etc…, etc…) by   ***//
//*** checking the value of a latch at specific points in the execution of the thread or  ***//
//*** process.  The latch is basically a flag of some sort.                               ***//
//*** NB:  For the purposes of our experiment we will focus on orderly thread shutdown.   ***//
//*******************************************************************************************//

//Session class - performs server’s stock info transmission and thread termination.
public class Session implements Runnable {
	  
	//***TwoPhaseTerminationPattern:  Role = 1(Thread(s) declaration - thread(s) that will be checked for an interrupt in Role 2.); 
    //	ID = 1.     
     private Thread myThread; //Thread to communicate with specific client.
     private Portfolio portfolio; //Object containing stock information.
     private Socket mySocket;
     //...
     public Session (Socket s) {
          myThread = new Thread (this);
          mySocket = s;
          //...
     }
  
     //***TwoPhaseTerminationPattern:  Role = 2(Method running the process. 
     //								** Contains Role 2a.
     //								** Contains Role 2b.);  
     //	ID = 1.  
     //***TwoPhaseTerminationPattern:  Role = 2a(In a loop checking the latch - thread in Role 1 being checked for Role 2aa.); 
     //	ID = 1.     
     //***TwoPhaseTerminationPattern:  Role = 2aa(Thread in Role 1 being checked if it has been interrupted.); 
     //	ID = 1.     
     //	***TwoPhaseTerminationPattern:  Role = 2b(After the loop, a call to Role 4 that shuts down the thread.); 
     //	ID = 1.
     public void run () {
         initialize ();
         while (!myThread.interrupted()) { //checking the value of the latch
             portfolio.sendTransactionsToClient(mySocket);//constant updates to client
          }//while
         shutdown();
     }//run
  
     //***TwoPhaseTerminationPattern:  Role = 3(Method that will contain functionality to set the latch - interrupt the thread in Role 1. 
     //								** Contains Role 3a.); 
     //	ID = 1.     
     //***TwoPhaseTerminationPattern:  Role = 3a(Actually setting the latch to true - interrupting the thread in Role 1.); 
     //	ID = 1. 
     //*** request that this session terminate
     public void interrupt(){ //this method sets the latch to true
          myThread.interrupt(); //setting the latch to true
     }
     
     //*** initialize the object
     private void initialize() {        
    	 //... 
     }
  
     //***TwoPhaseTerminationPattern:  Role = 4(Method that will contain functionality to stop the thread in Role 1. 
     //								** Contains Role 4a.); 
     //	ID = 1.     
     //***TwoPhaseTerminationPattern:  Role = 4a(Actually stopping of the thread in Role 1.); 
     //	ID = 1.     
     //*** perform cleanup for this object
     private void shutdown() {         
    	 //... 
    	 myThread.stop();
    	 //...
     }
}
