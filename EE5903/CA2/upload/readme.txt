## Introduction

This simulation project contains 3 seperate simulations.

The first one is compare the performance between **OSJF** and RSJF. In this simulation, the input of process list is same as the paper said. 
The aim of this simulation is to verify the result in the OSJF paper.

The second one is compare the performance between **MLFQ-IM** and MLFQ. In this simulation, the input of process list satisfies the requirement of same distribution. 
The aim of this simulation is to find the better performance in reducing starvation. After running the program, we will see the average waiting time of **MLFQ-IM** is less 
than that of MLFQ, which means MLFQ-IM reduce the starvation.

The third one is compare the performance between **OSJF** and **MLFQ-IM.** In order to find the advantages and disadvantages between them, I design this simulation. 
I put same process list into these two algorithms, but I set the level of all the process in OSJF is one because of the consideration of compatibility. 

## How to run this project

The total project is code by Python, I only use `random.randit()` to generarte uniform distribution in different service time and arrive time. 
So if you want to run this project, you have to make sure you have installed `random` package well.

#### simulation1

In this folder, you will see three python files. `simulation1.py` is the main file, `gantt_OSJF.py` is a special file to plot the gantt graph for OSJF algorithm, 
and `gant_RSJF.py` is a special file to plot the gantt graph for RSJF algorithm. After running, you will get the result and gantt graph for OSJF and RSJF algorithm.

#### simulation2

In this folder, you will see three python files. `simulation2.py` is the main file. After running, you will get the result.

#### simulation3

In this folder, you will see three python files. `simulation3.py` is the main file. After running, you will get the result.

## Structure for designing Algorithm

In this part, I would introduct the structure.

#### Process Obeject(For OSJF and MLFQ-IM)

```python
class  Process:
    def __init__(self,process_id,arrive_time,serve_time,level):
        self.process_id=process_id                  #Process id
        self.arrive_time=arrive_time                #Time of arrival
        self.serve_time=serve_time                  #Require service time
        self.left_serve_time=serve_time             #Remaining time for service
        self.finish_time=0                          #Complete time
        self.turnaround_time=0                      #Turnaround time
        self.w_turnaround_time=0                    #Weighted turnaround time
        self.waiting_time=0                         #waiting time
        self.level=level                            #priority level
```

#### Queue Object(Only for MLFQ-IM)

```python
class Queue:
    def __init__(self,queue_id,process_list,time_slice):
        self.queue_id=queue_id         #Queue id
        self.process_list=process_list #This Queue contains a list of processes 
        self.time_slice=time_slice     #The time Quanta of this queue
    def insert(self,new_process):
        self.process_list.append(new_process)
    def pop(self,current_process):
        self.process_list.remove(current_process)
    def length(self):
        return len(self.process_list)
```

#### OSJF Algorithm

When a new job is coming, the key of OSJF algorithm is to decide whether to continue executing current process.

```python
if 1/2*current_process.left_serve_time<competitive_process.left_serve_time:
    next_process=current_process
else:
    next_process=competitive_process
```

#### MLFQ-IM Algorithm

The innovation of MLFQ-IM are redirecting function and releasing function.

```python
while(True):
    def redirect_in_S_period(queue1,queu2,queue3,queue4,queue5,S)
        if running_time%S==0:
            queue2.add(queue4.process_list)
            queue4.delete(queue4.process_list)
            queue3.add(queue5.process_lisy)
            queue5.delete(queue5.process_list)
    def release_time(queue1,current_process):
        extra_time=queue1.time_slice-current_process.left_serve_time
        return extra_time
```

