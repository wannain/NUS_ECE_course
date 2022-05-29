clear
clc
%I choose the 25 subjects from CMU PIE dataset2 randomly and store them in the'data.mat' 
file=randperm(68);
file_chosen=file(1:25);%choose 25 subjects randomly
image=randperm(170);%choose 170 face images randomly form the each subject
k=1;
for i=1:length(file_chosen)
    for j=1:length(image)
        adress=[num2str(file_chosen(i)) '\' num2str(image(j)) '.jpg'];
        face=imread(adress);
        data_class(k)=file_chosen(i);%store the class of each face images in the data_class
        data_input(:,k)=reshape(face,1024,1);%store the face images in the data_input
        k=k+1;
    end
end
data_class=data_class';
save data data_class data_input 