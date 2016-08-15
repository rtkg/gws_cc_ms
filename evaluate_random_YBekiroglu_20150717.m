clear all; close all; clc;
addpath(genpath('../grasp_success'));
load('YBekiroglu_20150717');

%%%%%%%%%%%%%%%%%%%%% GWS computation options %%%%%%%%%%%%%%%%%%%%%%%
options.disc=12; %friction cone discretization
options.torque_scale=1;
options.augment_WC='hf'; %options: 'none','fl','hf', 'sf' -> additional patch wrenches

%%%%%%%%%%%%%%%%%%%%%% Hand/Task properties %%%%%%%%%%%%%%%%%%%%%%%%%%%
props.tmax=ones(8,1)*2100; %maximum hand joint torques
props.tmax(3)=1400; props.tmax(6)=1400; props.tmax(8)=1400;
props.tmax=props.tmax*0.781;
props.task.type='gravity'; %could be 'gravity' or 'sweep'
props.task.uncertainty.r=20/3;
props.task.uncertainty.n=20;

YBekiroglu_20150717_comparison_results(1).options=options;
YBekiroglu_20150717_comparison_results(1).props=props;

nO=length(YBekiroglu_20150717);
for i=1:nO
	obj=YBekiroglu_20150717(i).obj;
	data=YBekiroglu_20150717(i).Stable;
	nG=size(data.rel,1);
	YBekiroglu_20150717_comparison_results(i).name=obj.name;
	
	for j=1:nG %loop over all successful grasps
		disp(['STABLE: evaluating object ', num2str(i), ' of ',num2str(nO), '; grasp ', num2str(j), ' of ', ...
			num2str(nG), '.']);
		options.GWS='union';
		[q_u(j,1) tq_u(j,1)]=evaluateGrasp(data,obj,j,options,props);
		%[fc_u(j,1) GWS_u(j,1) tgws_u(j,1)]=evaluateGraspWrenchSpace(data,obj,j,options,props);
		
		options.GWS='minkowski';
		[q_m(j,1) tq_m(j,1)]=evaluateGrasp(data,obj,j,options,props);
		%[fc_m(j,1) GWS_m(j,1) tgws_m(j,1)]=evaluateGraspWrenchSpace(data,obj,j,options,props);
	end
	
	YBekiroglu_20150717_comparison_results(i).qs_u=q_u;
	YBekiroglu_20150717_comparison_results(i).ts_qu=tq_u;
	% 	YBekiroglu_20150717_comparison_results(i).fcs_u=fc_u;
	% 	YBekiroglu_20150717_comparison_results(i).GWSs_u=GWS_u;
	% 	YBekiroglu_20150717_comparison_results(i).tgwss_u=tgws_u;
	YBekiroglu_20150717_comparison_results(i).qs_m=q_m;
	YBekiroglu_20150717_comparison_results(i).ts_qm=tq_m;
	% 	YBekiroglu_20150717_comparison_results(i).fcs_m=fc_m;
	% 	YBekiroglu_20150717_comparison_results(i).GWSs_m=GWS_m;
	% 	YBekiroglu_20150717_comparison_results(i).tgwss_m=tgws_m;
	clear q_u; clear tq_u; % clear fc_u; clear GWS_u; clear tgws_u;
	clear q_m; clear tq_m; %clear fc_m; clear GWS_m; clear tgws_m;
	
	data=YBekiroglu_20150717(i).Unstable;
	nG=size(data.rel,1);
	for j=1:1 %loop over all unsuccesfull grasps
		disp(['UNSTABLE: evaluating object ', num2str(i), ' of ',num2str(nO), '; grasp ', num2str(j), ' of ', ...
			num2str(nG), '.']);
		options.GWS='union';
		[q_u(j,1) tq_u(j,1)]=evaluateGrasp(data,obj,j,options,props);
		
		options.GWS='minkowski';
		[q_m(j,1) tq_m(j,1)]=evaluateGrasp(data,obj,j,options,props);
	end
	YBekiroglu_20150717_comparison_results(i).qus_u=q_u;
	YBekiroglu_20150717_comparison_results(i).tus_qu=tq_u;
	YBekiroglu_20150717_comparison_results(i).qus_m=q_m;
	YBekiroglu_20150717_comparison_results(i).tus_qm=tq_m;
	clear q_u; clear tq_u;
	clear q_m; clear tq_m;
	save('./results/YBekiroglu_20150717_comparison_results.mat','YBekiroglu_20150717_comparison_results');
end

%plotResults(YBekiroglu_20150717_comparison_results);


