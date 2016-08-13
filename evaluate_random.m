clear all; close all; clc;
addpath(genpath('../grasp_success'));
load('YBekiroglu_20150717');

%%%%%%%%%%%%%%%%%%%%% GWS computation options %%%%%%%%%%%%%%%%%%%%%%%
options.disc=12; %friction cone discretization
options.torque_scale=1;
options.augment_WC='none'; %options: 'none','fl','hf', 'sf' -> additional patch wrenches

%%%%%%%%%%%%%%%%%%%%%% Hand/Task properties %%%%%%%%%%%%%%%%%%%%%%%%%%%
props.tmax=ones(8,1)*2100; %maximum hand joint torques
props.tmax(3)=1400; props.tmax(6)=1400; props.tmax(8)=1400;
props.tmax=props.tmax*0.781;
props.task.type='gravity'; %could be 'gravity' or 'sweep'
props.task.uncertainty.r=20/3;

nO=length(YBekiroglu_20150717);
nG=500; %number of grasps per object
for i=2:nO
	obj=YBekiroglu_20150717(i).obj;
	vn = vertexNormal(triangulation(obj.faces,obj.pts))*(-1); %get the inward-pointing vertex normals
	
	%%%%%%%%%%% Debug object visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Ptc=patch('Faces',obj.faces,'Vertices',obj.pts);
	Ptc.FaceColor=[1 0 0]; Ptc.FaceAlpha=0.3;  axis equal; grid on; hold on;
	for j=1:size(vn,1)
		p=obj.pts(j,:)';
		n=vn(j,:)'*10;
		plot3([p(1) p(1)+n(1)],[p(2) p(2)+n(2)],[p(3) p(3)+n(3)],'b');
	end
	%%%%%%%%%%% Debug object visualization end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	G=randi([1 size(obj.pts,1)],nG,3); %generate nG random grasps on the object
	T=randn(1,6); T=T./norm(T)*rand(1,1); %random task wrench with length between 0 and 1
	
	l=12%add index loop!!!!!!!!
	
	for k=1:size(G,2)
	% generate 1-element dummy patch
	id=G(l,k);
	P.d=1;
	P.p=obj.pts(id,:)';
	P.n=vn(id,:)';
	%rotation from contact frame to object frame
	[Q,~] = qr(P.n);
	A=Q(:,2:3);
	R=[A(:,1) cross(-A(:,1),P.n) P.n];
	
	P.C=[R P.p; zeros(1,3) 1];
	N=1;

	GW(k).W=getContactWrenches(P,N,obj,options);

	end
	
	%%%%%%%%%%% Debug contact force visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	for j=1:size(W,1)
% 		p=P.p;
% 		f=W(j,1:3);
% 		plot3([p(1) p(1)+f(1)],[p(2) p(2)+f(2)],[p(3) p(3)+f(3)],'g'); hold on; 
% 	end	
% 	grid on; axis equal;
	%%%%%%%%%%% Debug contact force visualization end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	[q tq]=graspQuality(GW,T);
	q
	keyboard
end

%save('./data/YBekiroglu_20150717_results.mat','YBekiroglu_20150717_results');