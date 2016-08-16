function plotYBekirogluResults(res)

nO=length(res);
sz=[100 100 1000 800];
font_size = 10;

%%%%%%%%%%%%%%%%%%%%%% Data massaging  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
qs_m=[];
qus_m=[];
qs_u=[];
qus_u=[];

o_ids_qs_m=length(res(1).qs_m);
o_ids_qus_m=length(res(1).qus_m);
o_ids_qs_u=length(res(1).qs_u);
o_ids_qus_u=length(res(1).qus_u);
for i=1:nO
	o_ids_m=length(res(i).qs_m);
	qs_m=[qs_m; res(i).qs_m(:)];
	qus_m=[qus_m; res(i).qus_m(:)];
	qs_u=[qs_u; res(i).qs_u(:)];
	qus_u=[qus_u; res(i).qus_u(:)];
	rqs_m(i)=length(find(res(i).qs_m > 1))/length(res(i).qs_m)*100;
	rqus_m(i)=length(find(res(i).qus_m <= 1))/length(res(i).qus_m)*100;
	rqsqus_m(i)= (length(find(res(i).qs_m > 1))+length(find(res(i).qus_m <= 1)))/(length(res(i).qs_m)+length(res(i).qus_m))*100;
	rqs_u(i)=length(find(res(i).qs_u > 1))/length(res(i).qs_u)*100;
	rqus_u(i)=length(find(res(i).qus_u <= 1))/length(res(i).qus_u)*100;
	rqsqus_u(i)= (length(find(res(i).qs_u > 1))+length(find(res(i).qus_u <= 1)))/(length(res(i).qs_u)+length(res(i).qus_u))*100;
	
	if i==1
		continue;
	end
	%indices of object splits
	o_ids_qs_m(i)=o_ids_qs_m(i-1)+length(res(i).qs_m);
	o_ids_qus_m(i)=o_ids_qus_m(i-1)+length(res(i).qus_m);
	o_ids_qs_u(i)=o_ids_qs_u(i-1)+length(res(i).qs_u);
	o_ids_qus_u(i)=o_ids_qus_u(i-1)+length(res(i).qus_u);
end

%%%%%%%%%%%%%%%%%%%%%% Boxplot quality criterion Minkowski %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f(1)=figure;
group_m=[];
data_m=[];
positions_m=[];
for i=1:nO
	ns_m=numel(res(i).qs_m(:));
	nus_m=numel(res(i).qus_m(:));
	data_m=[data_m; res(i).qs_m(:); res(i).qus_m(:)];
	group_m=[group_m; repmat(2*i-1,ns_m,1); repmat(2*i,nus_m,1)];
	positions_m=[positions_m i i+0.35];
	xlabels{i}=res(i).name;
	
	color(2*i-1)='r';
	color(2*i)='g';
end
ylabels={'0.0'; '0.5'; '1.0'; '1.5'; '2.0'; '2.5'; '3.0'};

boxplot(data_m,group_m, 'positions', positions_m, 'notch','on','medianstyle','target','symbol','r+');hold on; grid on;

ax=axis;
plot([0 ax(2)],[1 1],'k','LineWidth',1.5);

h = findobj(gca,'Tag','Box');
for i=1:length(h)
	patch(get(h(i),'XData'),get(h(i),'YData'),color(i),'FaceAlpha',1);
end

[h,icons,plots,str] = legend('a','b','c');
h=legend(flipud(plots(2:3)),' successful grasps',' unsuccessful grasps','Location','NorthWest');
set(h,'Interpreter','latex','FontSize',font_size);
ylabel('$q^*$','interpreter','latex','fontsize',font_size);

h = get(gca,'ylabel');
set(h,'Position',get(h,'Position')+[-0.1 0 0]);
set(gca,'XTickLabel',{' '});
set(gca,'YTickLabel',{' '});
pos=[1.05 1.9 2.8 3.9];
for i=1:length(xlabels)
	text(pos(i),-0.35,0,xlabels(i),'Interpreter','Latex','fontsize',font_size);
end
for i=1:length(ylabels)
	text(0.65,(i-1)*0.5,0,ylabels(i),'Interpreter','Latex','fontsize',font_size);
end
ylim([0 3.25]);
pbaspect([1.8,1,1]);


%%%%%%%%%%%%%%%%%%%%%% Boxplot quality criterion Union %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f(2)=figure;
group_u=[];
data_u=[];
positions_u=[];
for i=1:nO
	ns_u=numel(res(i).qs_u(:));
	nus_u=numel(res(i).qus_u(:));
	data_u=[data_u; res(i).qs_u(:); res(i).qus_u(:)];
	group_u=[group_u; repmat(2*i-1,ns_u,1); repmat(2*i,nus_u,1)];
	positions_u=[positions_u i i+0.35];
	xlabels{i}=res(i).name;
	
	color(2*i-1)='r';
	color(2*i)='g';
end
ylabels={'0.0'; '0.5'; '1.0'; '1.5'; '2.0'; '2.5'; '3.0'};
boxplot(data_u,group_u, 'positions', positions_u, 'notch','on','medianstyle','target','symbol','r+');hold on; grid on;

ax=axis;
plot([0 ax(2)],[1 1],'k','LineWidth',1.5);

h = findobj(gca,'Tag','Box');
for i=1:length(h)
	patch(get(h(i),'XData'),get(h(i),'YData'),color(i),'FaceAlpha',1);
end

[h,icons,plots,str] = legend('a','b','c');
h=legend(flipud(plots(2:3)),' successful grasps',' unsuccessful grasps','Location','NorthWest');
set(h,'Interpreter','latex','FontSize',font_size);
ylabel('$q^*$','interpreter','latex','fontsize',font_size);

h = get(gca,'ylabel');
set(h,'Position',get(h,'Position')+[-0.1 0 0]);
set(gca,'XTickLabel',{' '});
set(gca,'YTickLabel',{' '});
pos=[1.05 1.9 2.8 3.9];
for i=1:length(xlabels)
	text(pos(i),-0.35,0,xlabels(i),'Interpreter','Latex','fontsize',font_size);
end
for i=1:length(ylabels)
	text(0.65,(i-1)*0.5,0,ylabels(i),'Interpreter','Latex','fontsize',font_size);
end
ylim([0 3.25]);
pbaspect([1.8,1,1]);


%%%%%%%%%%%%%%%%%%%%%% ROC curve  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f(3)=figure;
ev=linspace(0,max([max(qs_m) max(qus_m) ]),100000);

for i=1:length(ev)
	x(i)= length(find(qus_m >= ev(i)))/length(qus_m)*100; %false positive
	y(i)=length(find(qs_m >= ev(i)))/length(qs_m)*100; %true positive
end
[u v]=find(x<5); %find the 5% fpr success rate
tpr=y(v(1))/100;
msg=['ROC AUC Minkowski: ',num2str(trapz(x/100,-y/100)), ' success rate Minkowski: ', num2str(tpr/(tpr+0.05))];
disp(msg);
plot(x,y,'LineWidth',3); hold on;

ev=linspace(0,max([max(qs_u) max(qus_u)]),100000);
clear x; clear y;
for i=1:length(ev)
	x(i)= length(find(qus_u >= ev(i)))/length(qus_u)*100; %false positive
	y(i)=length(find(qs_u >= ev(i)))/length(qs_u)*100; %true positive
end
[u v]=find(x<5); %find the 5% fpr success rate
tpr=y(v(1))/100;
msg=['ROC AUC Union: ',num2str(trapz(x/100,-y/100)), ' success rate Union: ', num2str(tpr/(tpr+0.05))];
disp(msg);
plot(x,y,'m','LineWidth',3);

axis([0 100 0 100]);grid on; %axis equal;
ylabel('true positive rate [ \%]','interpreter','latex','FontSize',font_size);
h = get(gca,'ylabel');
set(h,'Position',get(h,'Position')+[0 -0.05 0]);
xlabel('false positive rate [ \%]','interpreter','latex','FontSize',font_size);
h = get(gca,'xlabel');
set(h,'Position',get(h,'Position')+[-0.05 0 0]);

set(gca,'XTickLabel',{' '});
set(gca,'YTickLabel',{' '});
labels={'  0'; ' 20'; ' 40'; ' 60'; ' 80'; '100'};
for i=1:length(labels)
	text(-6,(i-1)*20,0,labels(i),'Interpreter','Latex','fontsize',font_size);
	if i==1
		continue
	end
	text((i-1)*20-3,-3,0,labels(i),'Interpreter','Latex','fontsize',font_size);
end
pbaspect([1.5,1,1]);

%%%%%%%%%%%%%%%%%%%%%% Accuracy bars Minkowski %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f(4)=figure;
b=bar([(rqsqus_m)' (rqs_m)' (rqus_m)']); grid on;
set(b(1),'FaceColor','b');
set(b(2),'FaceColor','g');
set(b(3),'FaceColor','r');

ylabels={' 0'; ' 20'; ' 40'; ' 60'; ' 80'; '100'};

h=legend(' classification accuracy ',' true positive rate',' true negative rate','Location','SouthEast');
set(h,'Interpreter','latex','FontSize',font_size);
ylabel('prediction rate [ \%]','interpreter','latex','FontSize',font_size);
h = get(gca,'ylabel');
set(h,'Position',get(h,'Position')+[-0.05 0 0]);
set(gca,'XTickLabel',{' '});
set(gca,'YTickLabel',{' '});
pos=[0.9 1.7 2.5 3.7];
for i=1:length(xlabels)
	text(pos(i),-4.5,0,xlabels(i),'Interpreter','Latex','fontsize',font_size);
end
for i=1:length(ylabels)
	text(0.3,(i-1)*20,0,ylabels(i),'Interpreter','Latex','fontsize',font_size);
end
disp(['Overall accuracy: ' num2str(mean(rqsqus_m)) ', true positives: ' num2str(mean(rqs_m)) [', true negatives: '] num2str(mean(rqus_m))]);
pbaspect([1.8,1,1]);

%%%%%%%%%%%%%%%%%%%%%% Accuracy bars Union %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f(5)=figure;
b=bar([(rqsqus_u)' (rqs_u)' (rqus_u)']); grid on;
set(b(1),'FaceColor','b');
set(b(2),'FaceColor','g');
set(b(3),'FaceColor','r');

ylabels={' 0'; ' 20'; ' 40'; ' 60'; ' 80'; '100'};

h=legend(' classification accuracy ',' true positive rate',' true negative rate','Location','SouthEast');
set(h,'Interpreter','latex','FontSize',font_size);
ylabel('prediction rate [ \%]','interpreter','latex','FontSize',font_size);
h = get(gca,'ylabel');
set(h,'Position',get(h,'Position')+[-0.05 0 0]);
set(gca,'XTickLabel',{' '});
set(gca,'YTickLabel',{' '});
pos=[0.9 1.7 2.5 3.7];
for i=1:length(xlabels)
	text(pos(i),-4.5,0,xlabels(i),'Interpreter','Latex','fontsize',font_size);
end
for i=1:length(ylabels)
	text(0.3,(i-1)*20,0,ylabels(i),'Interpreter','Latex','fontsize',font_size);
end

disp(['Overall accuracy: ' num2str(mean(rqsqus_u)) ', true positives: ' num2str(mean(rqs_u)) [', true negatives: '] num2str(mean(rqus_u))]);
pbaspect([1.8,1,1]);
%%%%%%%%%%%%%%%%%%%%%% saving  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(f(1));
set(gcf,'PaperPositionMode','auto')
print(gcf,'grasp_quality_m','-dpdf','-r450');

figure(f(2));
set(gcf,'PaperPositionMode','auto')
print(gcf,'grasp_quality_u','-dpdf','-r450');

figure(f(3));
set(gcf,'PaperPositionMode','auto')
print(gcf,'roc_curves','-dpdf','-r450');

figure(f(4));
set(gcf,'PaperPositionMode','auto')
print(gcf,'prediction_results_m','-dpdf','-r450');

figure(f(5));
set(gcf,'PaperPositionMode','auto')
print(gcf,'prediction_results_u','-dpdf','-r450');
