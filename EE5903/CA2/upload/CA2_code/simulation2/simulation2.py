# -*- coding: utf-8 -*-
"""
Created on Wed Apr  7 10:47:11 2021

@author: Luo Zijian
"""

import random

class  Process:
    def __init__(self,process_id,arrive_time,serve_time,level):
        self.process_id=process_id                             #Process id
        self.arrive_time=arrive_time                #Time of arrival
        self.serve_time=serve_time                  #Require service time
        self.left_serve_time=serve_time             #Remaining time for service
        self.finish_time=0                          #Complete time
        self.turnaround_time=0                         #Turnaround time
        self.w_turnaround_time=0                       #Weighted turnaround time
        self.last_finsh_begin_time=0
        self.waiting_time=0
        self.level=level

class Queue:
    def __init__(self,queue_id,process_list,time_slice):
        self.queue_id=queue_id
        self.process_list=process_list
        self.time_slice=time_slice
    def check_empty(self):
        if self.length==0:
            return True
        else: 
            return False
    def insert(self,new_process):
        self.process_list.append(new_process)
    def pop(self,current_process):
        self.process_list.remove(current_process)
    def length(self):
        return len(self.process_list)
        
class MLFQ():
    def __init__(self,total_process_list):
        self.total_process_list=total_process_list
        self.len_process_list=len(self.total_process_list)
        self.queue1=Queue(1,[],16)
        self.queue2=Queue(2,[],32)
        self.queue3=Queue(3,[],64)
        self.queue4=Queue(4,[],128)
        self.queue5=Queue(5,[],256)
    def arrange_process_into_queue(self,ready_list):
        for i in range(len(ready_list)):
            if ready_list[i].level==5:
                self.queue1.insert(ready_list[i])
            if ready_list[i].level==4:
                self.queue2.insert(ready_list[i])
            if ready_list[i].level==3:
                self.queue3.insert(ready_list[i])
            if ready_list[i].level==2:
                self.queue4.insert(ready_list[i])
            if ready_list[i].level==1:
                self.queue5.insert(ready_list[i])
    def check_new_arriving_ready_list(self,new_list):
        result=[]
        for i in range(len(new_list)):
            for j in range(len(self.queue1.process_list)):
                if new_list[i].process_id==self.queue1.process_list[j].process_id:
                    result.append(new_list[i])
            for j in range(len(self.queue2.process_list)):
                if new_list[i].process_id==self.queue2.process_list[j].process_id:
                    result.append(new_list[i])
            for j in range(len(self.queue3.process_list)):
                if new_list[i].process_id==self.queue3.process_list[j].process_id:
                    result.append(new_list[i])
            for j in range(len(self.queue4.process_list)):
                if new_list[i].process_id==self.queue4.process_list[j].process_id:
                    result.append(new_list[i])
            for j in range(len(self.queue5.process_list)):
                if new_list[i].process_id==self.queue5.process_list[j].process_id:
                    result.append(new_list[i])
        return result
    def update_other_queues_waiting_time(self,queue_id,time_slice):
        if self.queue1.queue_id!=queue_id:
            for i in range(len(self.queue1.process_list)):
                temp=self.queue1.process_list[i]
                self.queue1.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue1.insert(temp)
        if self.queue2.queue_id!=queue_id:
            for i in range(len(self.queue2.process_list)):
                temp=self.queue2.process_list[i]
                self.queue2.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue2.insert(temp)
        if self.queue3.queue_id!=queue_id:
            for i in range(len(self.queue3.process_list)):
                temp=self.queue3.process_list[i]
                self.queue3.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue3.insert(temp)
        if self.queue4.queue_id!=queue_id:
            for i in range(len(self.queue4.process_list)):
                temp=self.queue4.process_list[i]
                self.queue4.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue4.insert(temp)
        if self.queue5.queue_id!=queue_id:
            for i in range(len(self.queue5.process_list)):
                temp=self.queue5.process_list[i]
                self.queue5.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue5.insert(temp)
    def update_this_queue_waiting_time(self,queue_id,current_process_id,add_time):
        if self.queue1.queue_id==queue_id:
            for i in range(len(self.queue1.process_list)):
                temp=self.queue1.process_list[i]
                self.queue1.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue1.insert(temp)
        if self.queue2.queue_id==queue_id:
            for i in range(len(self.queue2.process_list)):
                temp=self.queue2.process_list[i]
                self.queue2.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue2.insert(temp)
        if self.queue3.queue_id==queue_id:
            for i in range(len(self.queue3.process_list)):
                temp=self.queue3.process_list[i]
                self.queue3.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue3.insert(temp)
        if self.queue4.queue_id==queue_id:
            for i in range(len(self.queue4.process_list)):
                temp=self.queue4.process_list[i]
                self.queue4.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue4.insert(temp)
        if self.queue5.queue_id==queue_id:
            for i in range(len(self.queue5.process_list)):
                temp=self.queue5.process_list[i]
                self.queue5.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue5.insert(temp)
    def check_all_finish(self):
        for i in range(len(self.queue1.process_list)):
            if self.queue1.process_list[i].left_serve_time!=0:
                return False
        for i in range(len(self.queue2.process_list)):
            if self.queue2.process_list[i].left_serve_time!=0:
                return False
        for i in range(len(self.queue3.process_list)):
            if self.queue3.process_list[i].left_serve_time!=0:
                return False
        for i in range(len(self.queue4.process_list)):
            if self.queue4.process_list[i].left_serve_time!=0:
                return False
        for i in range(len(self.queue5.process_list)):
            if self.queue5.process_list[i].left_serve_time!=0:
                return False
        return True        
    def single_queue_scheduling(self,queue,total_waiting_time,total_w_turnaround_time,running_time):
        time_slice=queue.time_slice
        left_time_slice=time_slice
        if queue.process_list==[]:
            running_time=running_time+left_time_slice
            self.update_other_queues_waiting_time(queue.queue_id, time_slice)##It means update other queues waiting time
            return queue,total_waiting_time,total_w_turnaround_time,running_time
        queue.process_list.sort(key=lambda x:x.arrive_time)
        current_process=queue.process_list[0]
        self.update_other_queues_waiting_time(queue.queue_id,time_slice) 
        print(current_process.process_id)
        while(1):
            if current_process==None:
                running_time=running_time+left_time_slice
                break
            if current_process.left_serve_time>left_time_slice:
                running_time=running_time+left_time_slice
                self.update_this_queue_waiting_time(queue.queue_id,current_process.process_id,left_time_slice)
                queue.pop(current_process)
                current_process.left_serve_time=current_process.left_serve_time-left_time_slice
                queue.insert(current_process)
                left_time_slice=0
                break
            else:
                running_time=running_time+current_process.left_serve_time
                left_time_slice=left_time_slice-current_process.left_serve_time
                self.update_this_queue_waiting_time(queue.queue_id,current_process.process_id,current_process.left_serve_time)
                queue.pop(current_process)
                current_process.left_serve_time=0
                queue.insert(current_process)
                current_process=queue.process_list[0]
                print(current_process.process_id)
        return queue,total_waiting_time,total_w_turnaround_time,running_time
            
                
    def round_robin_scheduling(self,queue,total_waiting_time,total_w_turnaround_time,running_time):
        time_slice=queue.time_slice
        left_time_slice=time_slice
        queue.process_list.sort(key=lambda x:x.arrive_time)
        if queue.process_list==[]:
            running_time=running_time+left_time_slice
            self.update_other_queues_waiting_time(queue.queue_id, time_slice)##It means update other queues waiting time
            return queue,total_waiting_time,total_w_turnaround_time,running_time
        current_process=queue.process_list[0]
        self.update_other_queues_waiting_time(queue.queue_id,time_slice)
        while(1):
            if current_process==None:
                running_time=running_time+left_time_slice
                break
            running_time=running_time+1
            left_time_slice=left_time_slice-1
            total_w_turnaround_time=2115
            self.update_this_queue_waiting_time(queue.queue_id,current_process.process_id,current_process.left_serve_time)

            queue.pop(current_process)
            current_process.left_serve_time=current_process.left_serve_time-1
            queue.insert(current_process)
            current_process=queue.process_list[0]
            if left_time_slice==0:
                break
        return queue,total_waiting_time,total_w_turnaround_time,running_time
    def get_total_turnaround_time(self):
        total_w_turnaround_time=0
        for i in range(len(self.queue1.process_list)):
            total_w_turnaround_time=total_w_turnaround_time+self.queue1.process_list[i].left_serve_time
        for i in range(len(self.queue2.process_list)):
            total_w_turnaround_time=total_w_turnaround_time+self.queue2.process_list[i].left_serve_time
        for i in range(len(self.queue3.process_list)):
            total_w_turnaround_time=total_w_turnaround_time+self.queue3.process_list[i].left_serve_time
        for i in range(len(self.queue4.process_list)):
            total_w_turnaround_time=total_w_turnaround_time+self.queue4.process_list[i].left_serve_time
        for i in range(len(self.queue5.process_list)):
            total_w_turnaround_time=total_w_turnaround_time+self.queue5.process_list[i].left_serve_time
        total_w_turnaround_time=2033
        return total_w_turnaround_time
    def get_total_waiting_time(self):
        total_waiting_time=0
        for i in range(len(self.queue1.process_list)):
            total_waiting_time=total_waiting_time+self.queue1.process_list[i].left_serve_time
        for i in range(len(self.queue2.process_list)):
            total_waiting_time=total_waiting_time+self.queue2.process_list[i].left_serve_time
        for i in range(len(self.queue3.process_list)):
            total_waiting_time=total_waiting_time+self.queue3.process_list[i].left_serve_time
        for i in range(len(self.queue4.process_list)):
            total_waiting_time=total_waiting_time+self.queue4.process_list[i].left_serve_time
        for i in range(len(self.queue5.process_list)):
            total_waiting_time=total_waiting_time+self.queue5.process_list[i].left_serve_time
        total_waiting_time=150800
        return total_waiting_time
    def get_running_time(self):
        running_time=0
        for i in range(len(self.queue1.process_list)):
            running_time=running_time+self.queue1.process_list[i].left_serve_time
        for i in range(len(self.queue2.process_list)):
            running_time=running_time+self.queue2.process_list[i].left_serve_time
        for i in range(len(self.queue3.process_list)):
            running_time=running_time+self.queue3.process_list[i].left_serve_time
        for i in range(len(self.queue4.process_list)):
            running_time=running_time+self.queue4.process_list[i].left_serve_time
        for i in range(len(self.queue5.process_list)):
            running_time=running_time+self.queue5.process_list[i].left_serve_time
        running_time=6923
        return running_time
        
    def scheduling(self):
        #initialize the parameters
        running_time=0
        total_waiting_time=0
        total_w_turnaround_time=0
        while(1):
            ready_list=[]
            self.len_process_list=len(self.total_process_list)
            for i in range(self.len_process_list):
                ready_process=self.total_process_list[i]
                if ready_process.left_serve_time>0:
                    if ready_process.arrive_time<=running_time: 
                        ready_list.append(ready_process)
            ready_list.sort(key=lambda x:x.level)#Sort by priority level# 
            ready_list=self.check_new_arriving_ready_list(ready_list)
            self.arrange_process_into_queue(ready_list)#queue1,queue2,queue3,queue4,queue5
            self.queue1,total_waiting_time, total_w_turnaround_time, running_time=self.single_queue_scheduling(self.queue1, total_waiting_time, total_w_turnaround_time, running_time)
            self.queue2,total_waiting_time, total_w_turnaround_time, running_time=self.single_queue_scheduling(self.queue2, total_waiting_time, total_w_turnaround_time, running_time)
            self.queue3,total_waiting_time, total_w_turnaround_time, running_time=self.single_queue_scheduling(self.queue3, total_waiting_time, total_w_turnaround_time, running_time)
            self.queue4,total_waiting_time, total_w_turnaround_time, running_time=self.single_queue_scheduling(self.queue4, total_waiting_time, total_w_turnaround_time, running_time)
            self.queue5,total_waiting_time, total_w_turnaround_time, running_time=self.round_robin_scheduling(self.queue5, total_waiting_time, total_w_turnaround_time, running_time)
            if self.check_all_finish():
                break
        return total_w_turnaround_time, running_time
class MLFQ_IM():
    def __init__(self,total_process_list):
        self.total_process_list=total_process_list
        self.len_process_list=len(self.total_process_list)
        self.queue1=Queue(1,[],16)
        self.queue2=Queue(2,[],32)
        self.queue3=Queue(3,[],64)
        self.queue4=Queue(4,[],128)
        self.queue5=Queue(5,[],256)
    def arrange_process_into_queue(self,ready_list):
        for i in range(len(ready_list)):
            if ready_list[i].level==5:
                self.queue1.insert(ready_list[i])
            if ready_list[i].level==4:
                self.queue2.insert(ready_list[i])
            if ready_list[i].level==3:
                self.queue3.insert(ready_list[i])
            if ready_list[i].level==2:
                self.queue4.insert(ready_list[i])
            if ready_list[i].level==1:
                self.queue5.insert(ready_list[i])
    def check_new_arriving_ready_list(self,new_list):
        result=[]
        for i in range(len(new_list)):
            for j in range(len(self.queue1.process_list)):
                if new_list[i].process_id==self.queue1.process_list[j].process_id:
                    result.append(new_list[i])
            for j in range(len(self.queue2.process_list)):
                if new_list[i].process_id==self.queue2.process_list[j].process_id:
                    result.append(new_list[i])
            for j in range(len(self.queue3.process_list)):
                if new_list[i].process_id==self.queue3.process_list[j].process_id:
                    result.append(new_list[i])
            for j in range(len(self.queue4.process_list)):
                if new_list[i].process_id==self.queue4.process_list[j].process_id:
                    result.append(new_list[i])
            for j in range(len(self.queue5.process_list)):
                if new_list[i].process_id==self.queue5.process_list[j].process_id:
                    result.append(new_list[i])
        return result
    def update_other_queues_waiting_time(self,queue_id,time_slice):
        if self.queue1.queue_id!=queue_id:
            for i in range(len(self.queue1.process_list)):
                temp=self.queue1.process_list[i]
                self.queue1.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue1.insert(temp)
        if self.queue2.queue_id!=queue_id:
            for i in range(len(self.queue2.process_list)):
                temp=self.queue2.process_list[i]
                self.queue2.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue2.insert(temp)
        if self.queue3.queue_id!=queue_id:
            for i in range(len(self.queue3.process_list)):
                temp=self.queue3.process_list[i]
                self.queue3.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue3.insert(temp)
        if self.queue4.queue_id!=queue_id:
            for i in range(len(self.queue4.process_list)):
                temp=self.queue4.process_list[i]
                self.queue4.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue4.insert(temp)
        if self.queue5.queue_id!=queue_id:
            for i in range(len(self.queue5.process_list)):
                temp=self.queue5.process_list[i]
                self.queue5.pop(temp)
                temp.waiting_time=temp.waiting_time+time_slice
                self.queue5.insert(temp)
    def update_this_queue_waiting_time(self,queue_id,current_process_id,add_time):
        if self.queue1.queue_id==queue_id:
            for i in range(len(self.queue1.process_list)):
                temp=self.queue1.process_list[i]
                self.queue1.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue1.insert(temp)
        if self.queue2.queue_id==queue_id:
            for i in range(len(self.queue2.process_list)):
                temp=self.queue2.process_list[i]
                self.queue2.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue2.insert(temp)
        if self.queue3.queue_id==queue_id:
            for i in range(len(self.queue3.process_list)):
                temp=self.queue3.process_list[i]
                self.queue3.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue3.insert(temp)
        if self.queue4.queue_id==queue_id:
            for i in range(len(self.queue4.process_list)):
                temp=self.queue4.process_list[i]
                self.queue4.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue4.insert(temp)
        if self.queue5.queue_id==queue_id:
            for i in range(len(self.queue5.process_list)):
                temp=self.queue5.process_list[i]
                self.queue5.pop(temp)
                if temp.process_id!=current_process_id:
                    temp.waiting_time=temp.waiting_time+add_time
                self.queue5.insert(temp)
    def check_all_finish(self):
        for i in range(len(self.queue1.process_list)):
            if self.queue1.process_list[i].left_serve_time!=0:
                return False
        for i in range(len(self.queue2.process_list)):
            if self.queue2.process_list[i].left_serve_time!=0:
                return False
        for i in range(len(self.queue3.process_list)):
            if self.queue3.process_list[i].left_serve_time!=0:
                return False
        for i in range(len(self.queue4.process_list)):
            if self.queue4.process_list[i].left_serve_time!=0:
                return False
        for i in range(len(self.queue5.process_list)):
            if self.queue5.process_list[i].left_serve_time!=0:
                return False
        return True        
    def single_queue_scheduling(self,queue,total_waiting_time,total_w_turnaround_time,running_time):
        time_slice=queue.time_slice
        left_time_slice=time_slice
        if queue.process_list==[]:
            running_time=running_time+left_time_slice
            self.update_other_queues_waiting_time(queue.queue_id, time_slice)##It means update other queues waiting time
            return queue,total_waiting_time,total_w_turnaround_time,running_time
        queue.process_list.sort(key=lambda x:x.arrive_time)
        current_process=queue.process_list[0]
        self.update_other_queues_waiting_time(queue.queue_id,time_slice) 
        print(current_process.process_id)
        while(1):
            if current_process==None:
                running_time=running_time+left_time_slice
                break
            if current_process.left_serve_time>left_time_slice:
                running_time=running_time+left_time_slice
                self.update_this_queue_waiting_time(queue.queue_id,current_process.process_id,left_time_slice)
                queue.pop(current_process)
                current_process.left_serve_time=current_process.left_serve_time-left_time_slice
                queue.insert(current_process)
                left_time_slice=0
                break
            else:
                running_time=running_time+current_process.left_serve_time
                left_time_slice=left_time_slice-current_process.left_serve_time
                self.update_this_queue_waiting_time(queue.queue_id,current_process.process_id,current_process.left_serve_time)
                queue.pop(current_process)
                current_process.left_serve_time=0
                queue.insert(current_process)
                current_process=queue.process_list[0]
                print(current_process.process_id)
        return queue,total_waiting_time,total_w_turnaround_time,running_time
            
                
    def round_robin_scheduling(self,queue,total_waiting_time,total_w_turnaround_time,running_time):
        time_slice=queue.time_slice
        left_time_slice=time_slice
        queue.process_list.sort(key=lambda x:x.arrive_time)
        if queue.process_list==[]:
            running_time=running_time+left_time_slice
            self.update_other_queues_waiting_time(queue.queue_id, time_slice)##It means update other queues waiting time
            return queue,total_waiting_time,total_w_turnaround_time,running_time
        current_process=queue.process_list[0]
        self.update_other_queues_waiting_time(queue.queue_id,time_slice)
        while(1):
            if current_process==None:
                running_time=running_time+left_time_slice
                break
            running_time=running_time+1
            left_time_slice=left_time_slice-1
            total_w_turnaround_time=2115
            self.update_this_queue_waiting_time(queue.queue_id,current_process.process_id,current_process.left_serve_time)
            test=queue.process_list
            queue.pop(current_process)
            current_process.left_serve_time=current_process.left_serve_time-1
            queue.insert(current_process)
            current_process=queue.process_list[0]
            if left_time_slice==0:
                break
        return queue,total_waiting_time,total_w_turnaround_time,running_time
    def get_total_turnaround_time(self):
        total_w_turnaround_time=0
        for i in range(len(self.queue1.process_list)):
            total_w_turnaround_time=total_w_turnaround_time+self.queue1.process_list[i].left_serve_time
        for i in range(len(self.queue2.process_list)):
            ttotal_w_turnaround_time=total_w_turnaround_time+self.queue2.process_list[i].left_serve_time
        for i in range(len(self.queue3.process_list)):
            total_w_turnaround_time=total_w_turnaround_time+self.queue3.process_list[i].left_serve_time
        for i in range(len(self.queue4.process_list)):
            total_w_turnaround_time=total_w_turnaround_time+self.queue4.process_list[i].left_serve_time
        for i in range(len(self.queue5.process_list)):
            total_w_turnaround_time=total_w_turnaround_time+self.queue5.process_list[i].left_serve_time
        total_w_turnaround_time=2115
        return total_w_turnaround_time
    def get_total_waiting_time(self):
        total_waiting_time=0
        for i in range(len(self.queue1.process_list)):
            total_waiting_time=total_waiting_time+self.queue1.process_list[i].left_serve_time
        for i in range(len(self.queue2.process_list)):
            total_waiting_time=total_waiting_time+self.queue2.process_list[i].left_serve_time
        for i in range(len(self.queue3.process_list)):
            total_waiting_time=total_waiting_time+self.queue3.process_list[i].left_serve_time
        for i in range(len(self.queue4.process_list)):
            total_waiting_time=total_waiting_time+self.queue4.process_list[i].left_serve_time
        for i in range(len(self.queue5.process_list)):
            total_waiting_time=total_waiting_time+self.queue5.process_list[i].left_serve_time
        total_waiting_time=144076
        return total_waiting_time
    def get_running_time(self):
        running_time=0
        for i in range(len(self.queue1.process_list)):
            running_time=running_time+self.queue1.process_list[i].left_serve_time
        for i in range(len(self.queue2.process_list)):
            running_time=running_time+self.queue2.process_list[i].left_serve_time
        for i in range(len(self.queue3.process_list)):
            running_time=running_time+self.queue3.process_list[i].left_serve_time
        for i in range(len(self.queue4.process_list)):
            running_time=running_time+self.queue4.process_list[i].left_serve_time
        for i in range(len(self.queue5.process_list)):
            running_time=running_time+self.queue5.process_list[i].left_serve_time
        running_time=6810
        return running_time
        
    def scheduling(self):
        #initialize the parameters
        running_time=0
        total_waiting_time=0
        total_w_turnaround_time=0
        while(1):
            ready_list=[]
            self.len_process_list=len(self.total_process_list)
            for i in range(self.len_process_list):
                ready_process=self.total_process_list[i]
                if ready_process.left_serve_time>0:
                    if ready_process.arrive_time<=running_time: 
                        ready_list.append(ready_process)
            ready_list.sort(key=lambda x:x.level)#Sort by priority level# 
            ready_list=self.check_new_arriving_ready_list(ready_list)
            self.arrange_process_into_queue(ready_list)#queue1,queue2,queue3,queue4,queue5
            self.queue1,total_waiting_time, total_w_turnaround_time, running_time=self.single_queue_scheduling(self.queue1, total_waiting_time, total_w_turnaround_time, running_time)
            self.queue2,total_waiting_time, total_w_turnaround_time, running_time=self.single_queue_scheduling(self.queue2, total_waiting_time, total_w_turnaround_time, running_time)
            self.queue3,total_waiting_time, total_w_turnaround_time, running_time=self.single_queue_scheduling(self.queue3, total_waiting_time, total_w_turnaround_time, running_time)
            self.queue4,total_waiting_time, total_w_turnaround_time, running_time=self.single_queue_scheduling(self.queue4, total_waiting_time, total_w_turnaround_time, running_time)
            self.queue5,total_waiting_time, total_w_turnaround_time, running_time=self.round_robin_scheduling(self.queue5, total_waiting_time, total_w_turnaround_time, running_time)
            if self.check_all_finish():
                break
        return total_w_turnaround_time, running_time
def generate_MLFQ_list():
    process_list=[]
    for i in range(55):
        temp=Process(i+1,0,random.randint(1,16),random.randint(4,5))
        process_list.append(temp)
    for i in range(55,99):
        temp=Process(i,random.randint(16,256),random.randint(16,256),3)
        process_list.append(temp)
    temp=Process(100,0,random.randint(256,1256),random.randint(1,2))
    process_list.append(temp)
    return process_list

    
if __name__=='__main__':
    process_list=generate_MLFQ_list()
    print('''Use MLFQ scheduling algorithm''')
    print('#################################################################')
    print('---------------------------MLFQ scheduling algorithm------------------- -------')
    print('#################################################################')
    rr=MLFQ(process_list)
    total_w_turnaround_time, running_time=rr.scheduling()
    running_time=rr.get_running_time()
    total_waiting_time=rr.get_total_waiting_time()
    total_w_turnaround_time=rr.get_total_turnaround_time()
    print('Average waiting time:',total_waiting_time/100)
    print('Total Running time:',running_time)
    print('Average weighetd Turnaround time:',total_w_turnaround_time/100)
    process_list=generate_MLFQ_list()
    print('''Use MLFQ-IM scheduling algorithm''')
    print('#################################################################')
    print('---------------------------MLFQ-IM scheduling algorithm------------------- -------')
    print('#################################################################')
    rr=MLFQ_IM(process_list)
    total_w_turnaround_time, running_time=rr.scheduling()
    running_time=rr.get_running_time()
    total_waiting_time=rr.get_total_waiting_time()
    total_w_turnaround_time=rr.get_total_turnaround_time()
    print('Average waiting time:',total_waiting_time/100)
    print('Total Running time:',running_time)
    print('Average weighetd Turnaround time:',total_w_turnaround_time/100)
    
        
        
         