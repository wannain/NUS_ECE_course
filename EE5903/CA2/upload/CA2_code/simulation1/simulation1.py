# -*- coding: utf-8 -*-
"""
Created on Wed Apr  7 10:20:03 2021

@author: Luo Zijian
"""


class  Process:
    def __init__(self,process_id,arrive_time,serve_time):
        self.process_id=process_id                             #Process id
        self.arrive_time=arrive_time                #Time of arrival
        self.serve_time=serve_time                  #Require service time
        self.left_serve_time=serve_time             #Remaining time for service
        self.finish_time=0                          #Complete time
        self.turnaround_time=0                         #Turnaround time
        self.w_turnaround_time=0                       #With right turnaround time
        self.last_finsh_begin_time=0
        self.waiting_time=0
        
class OSJF():
    def __init__(self,process_list):
        self.process_list=process_list
        self.len_process_list=len(self.process_list)
    def update_waiting_time(self,current_process):
        for i in range(len(self.process_list)):
            if self.process_list[i].arrive_time<=running_time1:
                if self.process_list[i].process_id!=current_process.process_id:
                    self.process_list[i].waiting_time+=1
    def all_process_is_done(self):
        if self.process_list==[]:
            return True
        for i in range(self.len_process_list):
            check_process=self.process_list[i]
            if check_process.left_serve_time>0:
                return False
    def remove_finished_process(self,total_waiting_time1):
        for i in range(self.len_process_list):
            check_process=self.process_list[i]
            if check_process.left_serve_time==0:
                self.process_list.remove(check_process)
                total_waiting_time1=total_waiting_time1+int(check_process.waiting_time)
        return total_waiting_time1
    def scheduling(self):
        global running_time1
        running_time1=0
        global total_waiting_time1
        total_waiting_time1=0
        while(True):
            #Ready Process
            ready_list=[]
            self.len_process_list=len(self.process_list)
            for i in range(self.len_process_list):
                ready_process=self.process_list[i]
                if ready_process.left_serve_time>0:
                    if ready_process.arrive_time<=running_time1: 
                        ready_list.append(ready_process)
            ready_list.sort(key=lambda x:x.arrive_time)#Sort by .arrive_time#   
            len_ready_list=len(ready_list)
                #Judge whether the current process has been completed
            if ready_list==[]:##
                running_time1=running_time1+1
                pass
            current_process=ready_list[0]
            if len_ready_list>1:
                for i in range(1,len_ready_list):
                    competive_process=ready_list[i]
                    if 1/2*current_process.left_serve_time>competive_process.left_serve_time:
                        print('In time:',running_time1,'This proces:',current_process.process_id,'would be replaced by process_id:',competive_process.process_id)
                        current_process=competive_process
                    else:
                        print('In time:',running_time1,'This proces:',current_process.process_id,'would not be interupted by process_id:',competive_process.process_id)
            else:
                print('In time:',running_time1,'This proces:',current_process.process_id,'would be executed')
            ##Processing this current process
            self.update_waiting_time(current_process)
            self.process_list.remove(current_process)
            current_process.left_serve_time-=1
            running_time1=running_time1+1
            self.process_list.append(current_process)
            total_waiting_time1=self.remove_finished_process(total_waiting_time1)
            if self.all_process_is_done():
                return total_waiting_time1

class RSJF():
    def __init__(self,process_list):
        self.process_list=process_list
        self.len_process_list=len(self.process_list)
    def update_waiting_time(self,current_process):
        for i in range(len(self.process_list)):
            if self.process_list[i].arrive_time<=running_time2:
                if self.process_list[i].process_id!=current_process.process_id:
                    self.process_list[i].waiting_time+=1
    def all_process_is_done(self):
        if self.process_list==[]:
            return True
        for i in range(self.len_process_list):
            check_process=self.process_list[i]
            if check_process.left_serve_time>0:
                return False
    def remove_finished_process(self,total_waiting_time2):
        for i in range(self.len_process_list):
            check_process=self.process_list[i]
            if check_process.left_serve_time==0:
                self.process_list.remove(check_process)
                total_waiting_time2=total_waiting_time2+int(check_process.waiting_time)
        return total_waiting_time2
    def scheduling(self):
        global running_time2
        running_time2=0
        global total_waiting_time2
        total_waiting_time2=0
        while(True):
            #Ready Process
            ready_list=[]
            self.len_process_list=len(self.process_list)
            for i in range(self.len_process_list):
                ready_process=self.process_list[i]
                if ready_process.left_serve_time>0:
                    if ready_process.arrive_time<=running_time2: 
                        ready_list.append(ready_process)
            ready_list.sort(key=lambda x:x.left_serve_time)#Sort by .arrive_time#   
            len_ready_list=len(ready_list)
                #Judge whether the current process has been completed
            if ready_list==[]:##
                running_time2=running_time2+1
                pass
            current_process=ready_list[0]
            if len_ready_list>1:
                for i in range(1,len_ready_list):
                    competive_process=ready_list[i]
                    if current_process.left_serve_time>competive_process.left_serve_time:
                        print('In time:',running_time2,'This proces:',current_process.process_id,'would be replaced by process_id:',competive_process.process_id)
                        current_process=competive_process
                    else:
                        print('In time:',running_time2,'This proces:',current_process.process_id,'would not be interupted by process_id:',competive_process.process_id)
            else:
                print('In time:',running_time2,'This proces:',current_process.process_id,'would be executed')
            ##Processing this current process
            self.update_waiting_time(current_process)
            self.process_list.remove(current_process)
            current_process.left_serve_time-=1
            running_time2=running_time2+1
            self.process_list.append(current_process)
            total_waiting_time2=self.remove_finished_process(total_waiting_time2)
            if self.all_process_is_done():
                return total_waiting_time2

def generate_OSJF_list():
    process_list=[]
    process1=Process('1',0,4)
    process2=Process('2',2,7)
    process3=Process('3',5,5)
    process4=Process('4',6,8)
    process5=Process('5',8,9)
    process_list.append(process1)
    process_list.append(process2)
    process_list.append(process3)
    process_list.append(process4)
    process_list.append(process5)
    return process_list
if __name__=='__main__':
    global running_time1
    running_time1=0
    global running_time2
    running_time2=0
    global waiting_time1
    waiting_time1=0
    global waiting_time2
    waiting_time2=0
    ##Generate process##
    process_list=generate_OSJF_list()
    ##Use Optimized Short job first scheduling algorithm##
    print('#################################################################')
    print('---------------------------Optimized Short job first scheduling algorithm------------------- -------')
    print('#################################################################')
    OSJF_test=OSJF(process_list)
    total_waiting_time1=OSJF_test.scheduling()
    print('Total running time:',running_time1)
    print('Average_waiting_time:',total_waiting_time1/5)
        ##Use Remaining Short job first scheduling algorithm##
    process_list=generate_OSJF_list()
    print('#################################################################')
    print('---------------------------Remaining Short job first scheduling algorithm------------------- -------')
    print('#################################################################')
    RSJF_test=RSJF(process_list)
    total_waiting_time2=RSJF_test.scheduling()
    print('Total running time:',running_time2)
    print('Average_waiting_time:',total_waiting_time2/5)