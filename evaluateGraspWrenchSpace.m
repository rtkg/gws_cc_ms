function [fc GWS tgws]=evaluateGraspWrenchSpace(data,obj,id,options,props)
%Computes the Grasp Wrench Space of the given grasp 
%ATTENZIONE: Only considers distal finger pads for now!!!!!!!!!!!!!!!!!!!!!
%
%data    ... data struct from the YBekiroglu data set
%obj     ... object struct with members name (string), pts (n x 3), faces (m x 4), mu (scalar friction coefficient), m (mass [kg]), com (center of mass 1 x 3) 
%id      ... grasp id indexing the given data set
%options ... options struct with members disc (friction cone discretization), torque_scale (factor by which the wrench torque vector part is scaled), augment_WC (string indicating the wrench cone augmentation within the contact patch), GWS (either 'minkowski' or 'union', determines the computation method)  
%props   ... property struct with members tmax (max torques k x 1), task
%-----------------------------------
%GWS     ... Grasp Wrench Space
%fc      ... force closure flag
%tq      ... computation time [s]


tactile=data.rawtactile(id,:);
joints=data.joint(id,:);
H_O_q=data.rel(id,:);
O_W_q=data.object(id,:);

H_O_T=quaternion2matrix(H_O_q(4:7)); H_O_T(1:3,4)=H_O_q(1:3); %hand expressed in the object frame
O_H_T=invertTransformation(H_O_T); %object expressed in the hand frame
O_W_T=quaternion2matrix(O_W_q(4:7)); O_W_T(1:3,4)=O_W_q(1:3); %object expressed in the world frame
H_W_T=O_W_T*H_O_T; %hand expressed in world frame

D=getTactileData(joints,H_O_q,tactile);%Extract tactile data
D_.d0=projectTactileData(D.d0);%project onto a local plane 
D_.d1=projectTactileData(D.d1);
D_.d2=projectTactileData(D.d2);

jts=convertSDHJoints(joints);
SP = model_SDH();
SV = System_Variables(SP);
SV.L(1).R=H_O_T(1:3,1:3);
SV.L(1).p=H_O_T(1:3,4);
SV.q=jts;
SV = calc_pos(SP,SV);
N0=maxNormalForce(props.tmax,D_.d0,SP,SV);
N1=maxNormalForce(props.tmax,D_.d1,SP,SV);
N2=maxNormalForce(props.tmax,D_.d2,SP,SV);

GW(1).W=getContactWrenches(D_.d0,N0,obj,options); %wrench cone exertable by one contact
GW(2).W=getContactWrenches(D_.d1,N1,obj,options);
GW(3).W=getContactWrenches(D_.d2,N2,obj,options);

switch props.task.type
  case 'gravity'
    T=gravityTask(O_H_T, H_W_T,obj,options,props);
  case 'sweep'
    T=sweepTask(O_H_T, H_W_T,obj,options,props);
  otherwise
    error('Invalid task type.');
end

tic
[fc, GWS]=graspWrenchSpace(GW,options);
tgws=toc;
