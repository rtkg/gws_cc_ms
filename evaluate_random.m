clear all; close all; clc;
addpath(genpath('../grasp_success'));
load('YBekiroglu_20150717');

%%%%%%%%%%%%%%%%%%%%% GWS computation options %%%%%%%%%%%%%%%%%%%%%%%
options.disc=12; %friction cone discretization
options.torque_scale=1;
options.augment_WC='none'; %options: 'none','fl','hf', 'sf' -> additional patch wrenches

nO=length(YBekiroglu_20150717);
nG=500; %number of grasps per object
random_results(1).options=options;
random_results(1).G=[];
random_results(1).GW=[];
random_results(1).T=[];
random_results(1).q_m=[];
random_results(1).tq_m=[];
random_results(1).q_u=[];
random_results(1).tq_u=[];
random_results(1).fc_m=[];
random_results(1).GWS_m=[];
random_results(1).fc_u=[];
random_results(1).GWS_u=[];

for i=1:nO
	obj=YBekiroglu_20150717(i).obj;
	vn = vertexNormal(triangulation(obj.faces,obj.pts))*(-1); %get the inward-pointing vertex normals
	random_results(i).obj=obj;
	random_results(i).vn=vn;
	
	%%%%%%%%%%% Debug object visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% 	Ptc=patch('Faces',obj.faces,'Vertices',obj.pts);
	% 	Ptc.FaceColor=[1 0 0]; Ptc.FaceAlpha=0.3;  axis equal; grid on; hold on; rotate3d on;
	% 	for j=1:size(vn,1)
	% 		p=obj.pts(j,:)';
	% 		n=vn(j,:)'*10;
	% 		plot3([p(1) p(1)+n(1)],[p(2) p(2)+n(2)],[p(3) p(3)+n(3)],'b');
	% 	end
	%%%%%%%%%%% Debug object visualization end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	grasp_count=0;
	while (grasp_count < nG)
		
		G=randi([1 size(obj.pts,1)],1,3); %generate random grasp on the object
		T=randn(1,6); T=T./norm(T)*rand(1,1); %random task wrench with length between 0 and 1
		
		for k=1:size(G,2)
			% generate 1-element dummy patch to obtain a boring hf-contact
			id=G(k);
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
			
			%%%%%%%%%%% Debug contact force visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% 			for j=1:size(GW(k).W,1)
			%
			% 				f=GW(k).W(j,1:3);
			% 				plot3([P.p(1) P.p(1)+f(1)],[P.p(2) P.p(2)+f(2)],[P.p(3) P.p(3)+f(3)],'g'); hold on;
			% 			end
			% 			grid on; axis equal;
			%%%%%%%%%%% Debug contact force visualization end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		end
		
		options.GWS='minkowski';
		[q_m tq_m]=graspQuality(GW,T,options);
		%Make sure the grasp can accomplish the task
		if q_m<1
			continue;
		end
		[fc_m, GWS_m]=graspWrenchSpace(GW,options);
		
		options.GWS='union';
		[q_u tq_u]=graspQuality(GW,T,options);
		[fc_u, GWS_u]=graspWrenchSpace(GW,options);
		
		random_results(i).G{end+1}=G;
		random_results(i).T{end+1}=T;
		random_results(i).GW{end+1}=GW;
		random_results(i).q_m(end+1)=q_m;
		random_results(i).tq_m(end+1)=tq_m;
		random_results(i).q_u(end+1)=q_u;
		random_results(i).tq_u(end+1)=tq_u;
		random_results(i).fc_m(end+1)=fc_m;
		random_results(i).GWS_m{end+1}=GWS_m;
		random_results(i).fc_u(end+1)=fc_u;
		random_results(i).GWS_u{end+1}=GWS_u;
		grasp_count=grasp_count+1;
		disp(['Evaluated object ', num2str(i), ' of ',num2str(nO), '; grasp ', num2str(grasp_count), ' of ', num2str(nG), '.']);
	end
end

save('./results/random_results.mat','random_results');