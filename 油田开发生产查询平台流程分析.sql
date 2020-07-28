



-----------------Part1 跟踪预测部分---------------------------------------



-- ch0. 油气水井日报、作业日报以及井史
$ZHDYDM:CACX;
$RQ:to_char(sysdate-1, 'yyyymmdd');
油井日报:
Select 
REPLACE(JH,'CAKD','XBKD') 井号, 
RQ 日期,
DECODE(DWDM,30205480,'海一',30205483,'海一',
		    30205482,'海一',30205484,'海一',
		    30205485,'海一',30205493,'海二',
		    30205495,'海二',30205496,'海二',
		    30205497,'海二',30205498,'海二',
		    30205506,'海三',30205507,'海三',
		    30205508,'海三',30205509,'海三',
		    30205510,'海三',30205517,'海四',
		    30205519,'海四',30205520,'海四',
		    30205521,'海四',30205522,'海四',
		    30205523,'海四',30205524,'海四','不详') AS 单位,
SCCW 层位,
DECODE(CYFS,'000','油管自喷','1B1','进口电泵','1B2','国产电泵','1E1','螺杆泵') 采油方式,
CASE WHEN scsj=0  THEN null ELSE scsj END 生产时间,
CASE WHEN (pl=0 or (scsj is null or scsj=0)) THEN null ELSE pl END 排量,
CASE WHEN (yz=0 or scsj is null or scsj=0) THEN null ELSE yz END 油嘴,
CASE WHEN (yy=0 or scsj is null or scsj=0) THEN null ELSE yy END  油压,
CASE WHEN (scsj is null or scsj=0) THEN null ELSE ty END  套压,
CASE WHEN (scsj is null or scsj=0) THEN null ELSE hy END  回压,
CASE WHEN (DY=0 or scsj is null or scsj=0) THEN null ELSE DY END 电压,
TO_NUMBER (CASE WHEN (Dl=0 or scsj is null or scsj=0) THEN null ELSE Dl END) 电流,
CASE WHEN (RCYL1=0 or scsj is null or scsj=0) THEN null ELSE RCYL1 END 日产液量,
round(CASE WHEN (RCYL1=0 or scsj is null or scsj=0) THEN null ELSE RCYL1*(1-hs/100) END,1) 日产油量,
CASE WHEN RCQL=0 or scsj is null or scsj=0 THEN null ELSE RCQL END 日产气量,
CASE WHEN QYB=0 or scsj is null or scsj=0 THEN null ELSE qyb END 气油比,
CASE WHEN scsj is null or scsj=0 THEN null ELSE hs END 含水,
CASE WHEN scsj is null or scsj=0 THEN null ELSE hs1 END 含砂,
CASE WHEN scsj is null or scsj=0 THEN null ELSE jkwd END 井口温度,
round(CASE WHEN  scsj is null or scsj=0 THEN null ELSE RCyL1/(floor(scsj)/24+((scsj-floor(scsj))*100/1440)) END,1) 日产液能力,
round(CASE WHEN  scsj is null or scsj=0 THEN null ELSE (RCyL1*(1-hs/100))/(floor(scsj)/24+((scsj-floor(scsj))*100/1440)) END,1) 日产油能力,
round(CASE WHEN  scsj is null or scsj=0 or pl=0  THEN null ELSE (RCyL1/(floor(scsj)/24+((scsj-floor(scsj))*100/1440)))/pl*100 END,1) 泵效,
bz 备注,
TO_NUMBER (CASE WHEN  instr(bz,'频率')>0 THEN  substr(bz,instr(bz,'频率')+2,2) ELSE null END) 频率  
From SJCJ.YS_DBA01 H ,HYYDNEW.YD_DAB121 B 
where  to_char(rq,'yyyymmdd')= {{RQ}}
and H.DYDM = B.DYDM  
AND B.ND =  (case when substr({{RQ}},5,2) - '00' = 1 then to_char(substr({{RQ}},1,4)-1) else substr({{RQ}},1,4) end)
AND B.ZHDYDM ='{{ZHDYDM}}'   
ORDER BY jh; 

$ZHDYDM:CATb;
$RQ:to_char(sysdate-1, 'yyyymmdd');
水井日报:
Select 
REPLACE(JH,'CAKD','XBKD') 井号, 
RQ 日期,
DECODE(DWDM,30205480,'海一',30205483,'海一',30205482,'海一',30205484,'海一',30205485,'海一',30205493,'海二',30205495,'海二',30205496,'海二',30205497,'海二',30205498,'海二',30205506,'海三',30205507,'海三',30205508,'海三',30205509,'海三',30205510,'海三',30205517,'海四',30205519,'海四',30205520,'海四',30205521,'海四',30205522,'海四',30205523,'海四',30205524,'海四','不详') AS 单位,
ZSCW 层位,
CASE WHEN scsJ=0 THEN null ELSE scSJ END 生产时间,
CASE WHEN (scSJ=0 or scSJ is null) THEN null ELSE GXYL END  干线压力,
CASE WHEN (scSJ=0 or scSJ is null) THEN null ELSE YY END 油压,
CASE WHEN (scSJ=0 or scSJ is null) THEN null ELSE TY END 套压,
CASE WHEN (scSJ=0 or scSJ is null) THEN null ELSE RPZSL END  日配注水量,
CASE WHEN (scSJ=0 or scSJ is null) THEN null ELSE RZSL END  日注水量,
CASE WHEN (scSJ=0 or scSJ is null) THEN null ELSE rpzsl-RZSL END  日欠注水量, 
bz 备注 
From sjcj.Ys_DBA02 H,HYYDNEW.YD_DAB121 B  
WHERE  to_char(rq,'yyyymmdd') = {{RQ}}
AND H.DYDM = B.DYDM  
AND B.ND = (case when substr({{RQ}},5,2) - '00' = 1 then to_char(substr({{RQ}},1,4)-1) else substr({{RQ}},1,4) end)
AND B.ZHDYDM ='{{ZHDYDM}}'  
ORDER BY jh;

$RQ:to_char(sysdate-1, 'yyyymmdd');
气井日报:
Select JH as 井号 ,
to_char(rq,'yyyy-mm-dd') as 日期,
DWDM as 单位代码 ,
SCCW as 生产层位,
SCSJ as 生产时间,
QZ as 气嘴,
YY as 油压,
TY as 套压,
HY as 回压,
RCQL as 日产气量,
BZ as 备注  
From SJCJ.YS_DBC01 WHERE to_char(rq,'yyyymmdd')={{RQ}}
order by DWDM,JH; 

$RQ:to_char(sysdate-1, 'yyyymmdd');
作业日报:
Select 
JH AS 井号 ,
RQ AS 日期,
KGRQ AS 开工日期,
SGXH AS 施工序号,
GXMC as 工序名称,
GXQSSJ AS 工序起始时间,
SGNR AS 施工内容 
From SJCJ.YS_DDB01 
WHERE to_char(rq,'yyyymmdd')>= {{RQ}}
order by JH,RQ; 

$JH:'CACB1FB-1';
油井井史:
Select 
REPLACE(JH,'CAKD','XBKD') 井号, 
RQ 日期,
SCCW 层位,
DECODE(CYFS,'000','油管自喷','1B2','进口电泵','1B2','国产电泵','1E1','螺杆泵') 采油方式,
CASE WHEN scsj=0  THEN null ELSE scsj END 生产时间,
CASE WHEN (pl=0 or (scsj is null or scsj=0)) THEN null ELSE pl END 排量,
CASE WHEN (yz=0 or scsj is null or scsj=0) THEN null ELSE yz END 油嘴,
CASE WHEN (yy=0 or scsj is null or scsj=0) THEN null ELSE yy END  油压,
CASE WHEN (scsj is null or scsj=0) THEN null ELSE ty END  套压,
CASE WHEN (scsj is null or scsj=0) THEN null ELSE hy END  回压,
CASE WHEN (DY=0 or scsj is null or scsj=0) THEN null ELSE DY END 电压,
TO_NUMBER (CASE WHEN (Dl=0 or scsj is null or scsj=0) THEN null ELSE Dl END) 电流,
CASE WHEN (RCYL1=0 or scsj is null or scsj=0) THEN null ELSE RCYL1 END 日产液量,
round(CASE WHEN (RCYL1=0 or scsj is null or scsj=0) THEN null ELSE RCYL1*(1-hs/100) END,1) 日产油量,
CASE WHEN RCQL=0 or scsj is null or scsj=0 THEN null ELSE RCQL END 日产气量,
CASE WHEN QYB=0 or scsj is null or scsj=0 THEN null ELSE qyb END 气油比,
CASE WHEN scsj is null or scsj=0 THEN null ELSE hs END 含水,
CASE WHEN scsj is null or scsj=0 THEN null ELSE hs1 END 含砂,
CASE WHEN scsj is null or scsj=0 THEN null ELSE jkwd END 井口温度,
round(CASE WHEN  scsj is null or scsj=0 THEN null ELSE RCyL1/(floor(scsj)/24+((scsj-floor(scsj))*100/1440)) END,1) 日产液能力,
round(CASE WHEN  scsj is null or scsj=0 THEN null ELSE (RCyL1*(1-hs/100))/(floor(scsj)/24+((scsj-floor(scsj))*100/1440)) END,1) 日产油能力,
round(CASE WHEN  scsj is null or scsj=0 or pl=0  THEN null ELSE (RCyL1/(floor(scsj)/24+((scsj-floor(scsj))*100/1440)))/pl*100 END,1) 泵效,
sum(rcyl1) OVER(PARTITION BY REPLACE(JH,'CAKD','XBKD') ORDER BY rq) 累积液,
round(sum(CASE WHEN (RCYL1=0 or scsj is null or scsj=0) THEN null ELSE RCYL1*(1-hs/100) END ) OVER(PARTITION BY REPLACE(JH,'CAKD','XBKD') ORDER BY rq),1) 累积油,
round(sum( floor(scsj)/24+((scsj-floor(scsj))*100/1440)) OVER(PARTITION BY REPLACE(JH,'CAKD','XBKD') ORDER BY rq),1) 累积时间,
bz 备注,
TO_NUMBER (CASE WHEN  instr(bz,'频率')>0 THEN  substr(bz,instr(bz,'频率')+2,2) ELSE null END) 频率  
From SJCJ.YS_DBA01  
where  REPLACE(JH,'CAKD','XBKD') = {{JH}}
ORDER BY RQ DESC;

$JH:'CACB1GA-8';
水井井史:
Select 
JH AS 井号 ,
to_char(rq,'yyyy-mm-dd') AS 日期,
DECODE(DWDM,30205480,'海一',30205483,'海一',
	        30205482,'海一',30205484,'海一',
	        30205485,'海一',30205493,'海二',
	        30205495,'海二',30205496,'海二',
	        30205497,'海二',30205498,'海二',
	        30205506,'海三',30205507,'海三',
	        30205508,'海三',30205509,'海三',
	        30205510,'海三',30205517,'海四',
	        30205519,'海四',30205520,'海四',
	        30205521,'海四',30205522,'海四',
	        30205523,'海四',30205524,'海四','不详') AS 单位,
SCSJ AS 生产时间,
GXYL AS 干压,
YY AS 油压,
TY 套压,
RPZSL AS 日配注量,
RZSL AS 日注水量,
rzsl-rpzsl as 欠注量,
BZ AS 备注 
From sjcj.Ys_DBA02  
WHERE  JH = {{JH}}
order by RQ desc;

$JH:'XBKD34A-2';
气井井史:
Select 
JH as 井号 ,
to_char(rq,'yyyy-mm-dd') as 日期,
DWDM as 单位代码 ,
SCCW as 生产层位,
SCSJ as 生产时间,
QZ as 气嘴,
YY as 油压,
TY as 套压,
HY as 回压,
RCQL as 日产气量,
BZ as 备注  
From SJCJ.YS_DBC01  
WHERE  JH = {{JH}}
order by RQ desc;

$QSSJ:to_char(sysdate-365, 'yyyymmdd');
$JSSJ:to_char(sysdate, 'yyyymmdd');
$ZHDYDM:'CACX';
单元日度:
Select 
a.日期,总井数,开井数,油嘴,油井油压,回压,日液,日油,单井日液,单井日油,含水,
水井总井数,水井开井数,干线压力,水井油压,日配注水量, 日注水量,单井日注,
ROUND(b.日注水量/((a.日液-a.日油)+a.日油*1.07/0.9386),2) AS 注采比 
From  
(Select to_char(rq,'yyyy-mm-dd') as 日期,
	count(jh) 总井数,
	sum(CASE WHEN (scsj is null or scsj=0) THEN null ELSE 1 END)  开井数,
	round(avg(Yz),1)  油嘴,
	round(avg(YY),1)  油井油压,
	round(avg(hY),1) 回压,SUM(RCYL1)  日液,
	round(sum(rcyl1*(1-HS/100)),1)   日油, 
	round(sum(rcyl1)/sum(CASE WHEN (scsj is null or scsj=0) THEN null ELSE 1 END),1) 单井日液 , 
	round(sum(rcyl1*(1-HS/100))/sum(CASE WHEN (scsj is null or scsj=0) THEN null ELSE 1 END),1) 单井日油,
	CASE WHEN SUM(RCYL1)>0 THEN round((SUM(RCYL1)-sum(rcyl1*(1-HS/100)))/SUM(RCYL1)*100,1) ELSE null END 含水  
From sjcj.ys_DBA01 d,HYYDNEW.YD_DAB121 c 
WHERE to_char(rq,'yyyymmdd') >= {{QSSJ}}
and to_char(rq,'yyyymmdd') <= {{JSSJ}}
and d.DYDM = c.DYDM 
AND c.ND = (case when substr({{JSSJ}},5,2) - '00' = 1 then to_char(substr({{JSSJ}},1,4)-1) else substr({{JSSJ}},1,4) end)
AND c.ZHDYDM = {{ZHDYDM}}
GROUP BY RQ) A, 
(Select 
	to_char(rq,'yyyy-mm-dd') as 日期,
	count(jh)  水井总井数,
	sum(CASE WHEN (scsj is null or scsj=0) THEN null ELSE 1 END)  水井开井数,
	round(avg(gxyl),1) as 干线压力,
	round(avg(YY),1) as 水井油压, 
	sum(rpzsl) as 日配注水量 ,
	sum(rzsl) as 日注水量,
	round(sum(rzsl)/sum(CASE WHEN (scsj is null or scsj=0) THEN null ELSE 1 END),1) 单井日注   
From sjcj.ys_DBA02 e,HYYDNEW.YD_DAB121 f 
WHERE to_char(rq,'yyyymmdd') >= {{QSSJ}}
and to_char(rq,'yyyymmdd') <= {{JSSJ}}
and e.DYDM = f.DYDM 
AND f.ND =  (case when substr({{JSSJ}},5,2) - '00' = 1 then to_char(substr({{JSSJ}},1,4)-1) else substr({{JSSJ}},1,4) end)
AND f.ZHDYDM = {{ZHDYDM}}
GROUP BY RQ) B  
WHERE A.日期=B.日期(+)  
ORDER BY a.日期;

$QSNY:'199501';
$ZHDYDM:'CACX';
单元月度:
Select 
a.年月,a.开井数 ,a.日液水平,a.日油水平,a.单井日液能力,a.单井日油能力,a.含水,a.气油比, 
b.开井数,b.日注水平,ROUND(b.月注水量/(A.井口月产水量+A.井口月产油量*1.07/0.9386),2) AS 月注采比 
from
(Select 
	ny 年月,count(jh) 总井数, count(CASE WHEN scts>=1 THEN 1 ELSE null END) 开井数,round(avg(yy),2) 油压,
	round(sum( CASE WHEN scts>=1 THEN (ycyl+CASE WHEN ycsl is null THEN 0 ELSE ycsl END)/scts ELSE null END) ,0) 日液能力,
	round(sum( CASE WHEN scts>=1 THEN ycyl/scts ELSE null END) ,0) 日油能力,
	round(sum( CASE WHEN scts>=1 THEN ycql/scts ELSE null END) ,2) 日气能力, 
	round( sum(CASE WHEN scts>=1 THEN (ycyl+CASE WHEN ycsl is null THEN 0 ELSE ycsl END)/TO_CHAR(LAST_DAY(TO_DATE(NY,'YYYYMM')),'dd')  ELSE null END) ,1)  日液水平,
	round( sum(CASE WHEN scts>=1 THEN ycyl/TO_CHAR(LAST_DAY(TO_DATE(NY,'YYYYMM')),'dd')  ELSE null END) ,1)  日油水平,
	round( sum(CASE WHEN scts>=1 THEN ycql/TO_CHAR(LAST_DAY(TO_DATE(NY,'YYYYMM')),'dd')  ELSE null END) ,2)  日气水平,
	round(avg( CASE WHEN scts>=1 THEN (ycyl+CASE WHEN ycsl is null THEN 0 ELSE ycsl END)/scts ELSE null END) ,1) 单井日液能力,
	round(avg( CASE WHEN scts>=1 THEN ycyl/scts ELSE null END) ,1) 单井日油能力,
	round(sum( CASE WHEN scts>=1 THEN (hsycyl+CASE WHEN hsycsl is null THEN 0 ELSE hsycsl END)/scts ELSE null END) ,1) 核实日液能力,
	round(sum( CASE WHEN scts>=1 THEN hsycyl/scts ELSE null END) ,1) 核实日油能力,
	round(sum( ycsl)*100/(sum(ycyl)+sum(ycsl))  ,1) 含水,
	round(sum( ycql)*10000/sum(ycyl) ,1) 气油比,
	sum(ycyl) 井口月产油量,
	sum(ycsl) 井口月产水量,
	sum(ycql) 井口月产气量,
	sum(ycsl)+sum(ycyl) 井口月产液量,
	sum(hsycyl) 核实月产油量,
	sum(hsycsl) 核实月产水量,
	sum(hsycsl)+sum(hsycyl) 核实月产液量 
From HYYDNEW.YD_DBA04 d,HYYDNEW.YD_DAB121 c  
where SUBSTR(NY,5,2)<>'00' 
and  ny>= {{QSNY}}
and  d.DYDM = c.DYDM 
AND c.ND = (case when substr(to_char(sysdate, 'yyyymmdd'),5,2) - '00' = 1 then to_char(substr(to_char(sysdate, 'yyyymmdd'),1,4)-1) else substr(to_char(sysdate, 'yyyymmdd'),1,4) end)
AND c.ZHDYDM ={{ZHDYDM}}
group by ny ORDER BY ny ) a, 
(Select 
	ny 年月,count(jh) 总井数, count(CASE WHEN scts>=1 THEN 1 ELSE null END) 开井数,
	round(avg(gxyl),2) 干压,round(avg(yy),2) 油压,
	round(sum( CASE WHEN rpzsl<>0 THEN rpzsl ELSE null END) ,1)  日配注,
	round( sum(CASE WHEN scts>=1 THEN yzsl/TO_CHAR(LAST_DAY(TO_DATE(NY,'YYYYMM')),'dd')  ELSE null END) ,0)  日注水平,
	sum(yzsl) 月注水量  
From HYYDNEW.YD_DBA05 e,HYYDNEW.YD_DAB121 f 
where SUBSTR(NY,5,2)<>'00' 
and  ny>= {{QSNY}}
and e.DYDM = f.DYDM 
AND f.ND = (case when substr(to_char(sysdate, 'yyyymmdd'),5,2) - '00' = 1 then to_char(substr(to_char(sysdate, 'yyyymmdd'),1,4)-1) else substr(to_char(sysdate, 'yyyymmdd'),1,4) end)
AND f.ZHDYDM ={{ZHDYDM}}
group by ny ORDER BY ny ) b  
where a.年月 = b.年月(+) 
ORDER BY a.年月; 






-- ch2. 交油盘库
-- HYYTSJ.YS_HY_JSDYRFX 为综合室维护,通过存储过程pro_ys_hy_jsdyrfx(rq)由HYYTSJHY_BB_SYZWSRSJB算出,HYYTSJ表空间的密码为hysj   HY_BB_SYZLYRSJB  HY_BB_ZXPTZCSYXRSJ
-- HYYTSJHY_BB_SYZWSRSJB网页版在生产指挥系统-生产动态-集输大队-综合查询-交油统计表，登录方式dingbaolai.slyt/DBL+201911
-- 旬度分析中的旬度盘库为盘库日油的旬度平均值
$QSSJ:to_char(sysdate-100, 'yyyymmdd');
$JSSJ:to_char(sysdate-2, 'yyyymmdd');
@交油历史数据:
Select 
a.WSDY AS 外输单元,
a.RQ AS 日期,
a.ZJS AS 总井数,
a.KJS AS 开井数,
a.WSRY AS 外输日液,
a.WSRU AS 外输日油, 
a.WSHS AS 外输含水,
ROUND(a.WSRU/0.9825) AS 盘库日油,
ROUND(a.WSRU/0.9825/(1-a.JKHS/100)) AS 反算日液,
a.JKRY AS 井口日液,
a.JKRU AS 井口日油,
a.JKHS AS 井口含水,
a.RYCZ AS 日液差值,
a.RUCZ AS 日油差值,
a.HSCZ AS 含水差值   
From HYYTSJ.YS_HY_JSDYRFX a   
WHERE  to_char(a.RQ,'yyyymmdd') >= {{QSSJ}}
and to_char(a.RQ,'yyyymmdd') <= {{JSSJ}}
ORDER BY a.WSDY,a.RQ;



$QSSJ:'20191201';
$JSSJ:'20200110';
$DYMC:('海一','海二','海三','海四','全厂');
旬度盘库:
Select 
min(to_char(a.RQ, 'yyyymm') || (case when trunc((to_char(a.RQ, 'dd')-1)/10,0) = 3 then 2 else trunc((to_char(a.RQ, 'dd')-1)/10,0) end)) as 旬度,
min(a.WSDY) AS 单位,
round(avg(round(a.WSRU/0.9825,2))) AS 盘库水平
From HYYTSJ.YS_HY_JSDYRFX a   
WHERE  to_char(a.RQ,'yyyymmdd') >= {{QSSJ}} 
and to_char(a.RQ,'yyyymmdd') <=  {{JSSJ}}  
and a.WSDY in {{DYMC}}   
group by a.WSDY,to_char(a.RQ, 'yyyymm') || (case when trunc((to_char(a.RQ, 'dd')-1)/10,0) = 3 then 2 else trunc((to_char(a.RQ, 'dd')-1)/10,0) end)
order by 旬度,单位;





-- ch3. 实际增量因素分析(预警分析)
$QSSJ:'20190101';
$JSSJ:'20191231';
$LXMC:('维护','措施');
@分类构成:
Select unique(JH) From KFSJGL.GZ_KF_DYDMGC where ND in (substr({{QSSJ}},0,4), substr({{JSSJ}},0,4)) and  GC in {{LXMC}};



$ZHDYDM:'CACX';
$QSSJ:'20181223';
$JSSJ:'20191223';
@措施井数据查询:
select 
	A.JH AS 井号,
	A.rq as 日期,
	DECODE(DWDM,30205480,'海一',30205483,'海一',
		        30205482,'海一',30205484,'海一',
		        30205485,'海一',30205493,'海二',
		        30205495,'海二',30205496,'海二',
		        30205497,'海二',30205498,'海二',
		        30205506,'海三',30205507,'海三',
		        30205508,'海三',30205509,'海三',
		        30205510,'海三',30205517,'海四',
		        30205519,'海四',30205520,'海四',
		        30205521,'海四',30205522,'海四',
		        30205523,'海四',30205524,'海四','不详') AS 单位,
	A.SCSJ AS 生产时间,
	A.RCYL1 as 日液,
	round(A.rcyl1*(100-A.hs)/100,1) as 日油,
	A.hs as 含水,
	A.bz as 备注,

	B.最后正常生产时间, 
	B.最后正常生产日液, 
	B.最后正常生产日油, 
	B.最后正常生产含水, 
	B.见油时间, 
	B.作业完时间,

	case when to_char(A.rq,'yyyymmdd') >= B.见油时间 then 
		case when round(A.rcyl1 - B.最后正常生产日液, 1) > 0 then 
			round(A.rcyl1 - B.最后正常生产日油, 1)
		else 
			0
			-- round(A.rcyl1 - B.最后正常生产日油, 1)
		end
	end as 措施增液,
	case when to_char(A.rq,'yyyymmdd') >= B.见油时间 then 
		case when round(round(A.rcyl1*(100-A.hs)/100,1) - B.最后正常生产日油, 1) > 0 then 
			round(round(A.rcyl1*(100-A.hs)/100,1) - B.最后正常生产日油, 1)
		else 
			0
			-- round(round(A.rcyl1*(100-A.hs)/100,1) - B.最后正常生产日油, 1)
		end
	end as 措施增油
from
			(Select 
				A.JH, A.rq, DWDM, A.SCSJ, A.RCYL1, a.hs, a.bz 
			From HYYDNEW.YD_DBA01 A  
			WHERE jh in (select unique(jh) From sjcj.ys_DBA01 a,HYYDNEW.YD_DAB121 b where a.DYDM = b.DYDM and b.ZHDYDM = {{ZHDYDM}})
			and to_char(rq,'yyyymmdd') >= {{QSSJ}}
			and to_char(rq,'yyyymmdd') <= {{JSSJ}}) A,  
																										(select 
																											A.井号, 
																											A.日期 as 最后正常生产时间, 
																											-- A.单位, A.生产时间, 
																											A.日液 as 最后正常生产日液, 
																											A.日油 as 最后正常生产日油, 
																											A.含水 as 最后正常生产含水, 
																											-- A.备注, 
																											-- A.最后正常生产时间,
																											B.见油时间, 
																											B.作业完时间 
																										from 
																													(Select 
																														A.JH AS 井号,
																														to_char(A.rq,'yyyymmdd') as 日期,
																														-- A.DWDM AS 单位,
																														-- A.SCSJ AS 生产时间,
																														A.RCYL1 as 日液,
																														round(rcyl1*(100-hs)/100,1) as 日油,
																														a.hs as 含水
																														-- a.bz as 备注,
																														-- b.最后正常生产时间
																														-- b.作业完时间
																													From HYYDNEW.YD_DBA01 A,
																																										(select 井号,
																																											max(日期) as 最后正常生产时间,
																																											max(日期2) as 作业完时间  
																																										from
																																											(Select 
																																										      A.JH AS 井号,
																																										      to_char(A.rq,'yyyymmdd') as 日期
																																										      -- A.DWDM AS 单位,
																																										      -- A.SCSJ AS 生产时间,
																																										      -- A.RCYL1 as 日液,
																																										      -- round(rcyl1*(100-hs)/100,1) as 日油,
																																										      -- a.hs as 含水,
																																										      -- a.bz as 备注 
																																										    From HYYDNEW.YD_DBA01 A  
																																										    WHERE to_char(rq,'yyyymmdd') <= {{JSSJ}}
																																										    --and  to_char(rq,'yyyymmdd') > = '20181223'
																																										    -- and A.JH  in (Select JH From KFSJGL.GZ_KF_DYDMGC where ND in (substr({{QSSJ}},0,4), substr({{JSSJ}},0,4)) and  GC in ('维护','措施'))
																																										    and a.RCYL1 <> 0 and a.HS <> 0 and scsj = 24
																																										    order by jh) C,

																																										    (Select 
																																										      A.JH AS 井号2,
																																										      to_char(max(A.rq),'yyyymmdd') as 日期2
																																										    From HYYDNEW.YD_DBA01 A  
																																										    WHERE  to_char(rq,'yyyymmdd') > = {{QSSJ}}
																																										    and to_char(rq,'yyyymmdd') <= {{JSSJ}}
																																										    -- and A.JH  in (Select JH From KFSJGL.GZ_KF_DYDMGC where ND='2019' and  GC in ('维护','措施'))
																																										    and A.BZ like '%作业%' 
																																										    group by a.jh
																																										    order by jh) D

																																										where C.井号 = D.井号2 and C.日期 < D.日期2 + 1 --此处的1可以省略
																																										group by 井号
																																										order by 井号 asc) B  -- 之前某一天正常生产，后来在起始时间和结束时间之内完成作业
																													where A.JH = B.井号 and to_char(A.rq,'yyyymmdd') = B.最后正常生产时间) A,   -- 措施前产量

																																																																		(select 井号,min(日期) as 见油时间, min(日期2) as 作业完时间  from
																																																																		  (Select 
																																																																		    A.JH AS 井号,
																																																																		    to_char(A.rq,'yyyymmdd') as 日期
																																																																		    -- A.DWDM AS 单位,
																																																																		    -- A.SCSJ AS 生产时间 ,
																																																																		    -- A.RCYL1 as 日液,
																																																																		    -- round(rcyl1*(100-hs)/100,1) as 日油,
																																																																		    -- a.hs as 含水,
																																																																		    -- a.bz as 备注 
																																																																		  From HYYDNEW.YD_DBA01 A  
																																																																		  WHERE  to_char(rq,'yyyymmdd') > = {{QSSJ}}
																																																																		  -- and to_char(rq,'yyyymmdd') <= '20191223'
																																																																		  -- and A.JH  in (Select JH From KFSJGL.GZ_KF_DYDMGC where ND='2019' and  GC in ('维护','措施'))
																																																																		  and a.RCYL1 <> 0 and a.HS <> 0
																																																																		  order by jh) C,

																																																																		  (Select 
																																																																		    A.JH AS 井号2,
																																																																		    to_char(max(A.rq),'yyyymmdd') as 日期2
																																																																		  From HYYDNEW.YD_DBA01 A  
																																																																		  WHERE  to_char(rq,'yyyymmdd') > = {{QSSJ}}
																																																																		  and to_char(rq,'yyyymmdd') <= {{JSSJ}}
																																																																		  -- and A.JH  in (Select JH From KFSJGL.GZ_KF_DYDMGC where ND='2019' and  GC in ('维护','措施'))
																																																																		  and A.BZ like '%作业%' 
																																																																		  group by a.jh
																																																																		  order by jh) D
																																																																		where C.井号 = D.井号2 and C.日期 > D.日期2 --+ 1
																																																																		group by 井号) B -- 作业完时间和见油时间
																										where A.井号 = B.井号) B -- 措施井统计

where A.jh = B.井号
-- and A.JH  in (Select JH From KFSJGL.GZ_KF_DYDMGC where ND in (substr({{QSSJ}},0,4), substr({{JSSJ}},0,4)) and  GC in ('维护','措施'))
and to_char(A.rq,'yyyymmdd') >= B.见油时间
order by A.jh, A.rq asc;





$QSSJ:'20200101';
$JSSJ:'20201231';
@新井数据查询:
Select 
A.JH AS 井号,
A.rq as 日期,
DECODE(DWDM,30205480,'海一',30205483,'海一',
			30205482,'海一',30205484,'海一',
			30205485,'海一',30205493,'海二',
			30205495,'海二',30205496,'海二',
			30205497,'海二',30205498,'海二',
			30205506,'海三',30205507,'海三',
			30205508,'海三',30205509,'海三',
			30205510,'海三',30205517,'海四',
			30205519,'海四',30205520,'海四',
			30205521,'海四',30205522,'海四',
			30205523,'海四',30205524,'海四','不详') AS 单位,
A.SCSJ AS 生产时间,
A.RCYL1 as 日液,
round(rcyl1*(100-hs)/100,1) as 日油,
a.hs as 含水,
a.bz as 备注
From HYYDNEW.YD_DBA01 A  
WHERE  to_char(rq,'yyyymmdd') > = {{QSSJ}}
and to_char(rq,'yyyymmdd') <= {{JSSJ}}
and A.JH  in 
(Select JH   
	From KFSJGL.GZ_KF_DYDMGC  
	where ND in (substr({{QSSJ}},0,4), substr({{JSSJ}},0,4))
	and GC = '新井') 
order by jh,rq; 




-- ch4. 实际减量因素分析（各类关井对产量的影响）

-- 原程序分析思路是 找出备注带有 '关'（其非其它正常关井词语）、'测压'、'钻'、'转注' 等 的记录 保存在数据筛选 
-- 然后将前一天为关井，当天关井的记录筛选出来放到 数据筛选1
-- 最终生成名为 故障关井、测压关井、保钻关井、转注关井 等 的报表，如下面的故障关井计算过程：


$QSSJ:'20200101';
$JSSJ:'20201231';
@关躺井数据查询:
select 
	'关躺井' as 类型,
  a.井号,
  a.单位,
  a.停井日期GC as 关躺井日期,
  a.日液 as 躺井前日液,
  a.日油 as 躺井前日油,
  a.含水 as 躺井前含水,
  -- a.停井前正常生产日期,
  -- a.停井日期,  
  a.关井后开井时间 as 作业见油日期
  -- b.RCYL1 as 作业后日液,
  -- round(b.rcyl1*(100-b.hs)/100,1) as 作业后日油,--开井后日油,
  -- b.hs as 作业后含水--开井后含水
from 
		  (
		    select 
		      a.井号,
		      min(a.单位) as 单位,
		      min(a.日液) as 日液,
		      min(a.日油) as 日油,
		      min(a.含水) as 含水,
		      min(a.停井前正常生产日期) as 停井前正常生产日期,
		      min(a.停井日期) as 停井日期,
		      min(a.停井日期GC) as 停井日期GC,
		      min(b.rq) as 关井后开井时间

		    from 
				      (
				        select  
				          a.jh as 井号,
									DECODE(a.DWDM,30205480,'海一',30205483,'海一',30205482,'海一',30205484,'海一',30205485,'海一',
												   30205493,'海二',30205495,'海二',30205496,'海二',30205497,'海二',30205498,'海二',
												   30205506,'海三',30205507,'海三',30205508,'海三',30205509,'海三',30205510,'海三',
												   30205517,'海四',30205519,'海四',30205520,'海四',30205521,'海四',30205522,'海四',
												   30205523,'海四',30205524,'海四','不详') AS 单位,
				          A.RCYL1 as 日液,
				          a.rcyl1*(100-a.hs)/100 as 日油,
				          a.hs as 含水,
				          b.停井前正常生产日期,
				          b.停井日期,
				          b.停井日期GC
				        from HYYDNEW.YD_DBA01 a,
																	        (
																	          select 
																	            e.jh as 井号,
																	            max(e.rq) as 停井前正常生产日期,
																	            min(f.rq) as 停井日期,
																	            min(f.rq2) as 停井日期GC
																	          from HYYDNEW.YD_DBA01 e,
																													            (select 
																													              c.jh,
																													              d.rq,
																													              d.rq2
																													            from
																															              (select 
																															                jh,rq,SCSJ,RCYL1,HS
																															              from HYYDNEW.YD_DBA01 A
																															              where 
																															                to_char(a.rq,'yyyymmdd') >= {{QSSJ}}
																															                --A.RCYL1 is not null and A.HS is not null
																															                and a.SCSJ > 0
																															              ) C,
																																		              (Select * from
																																									                (Select 
																																									                  a.JH, 
																																									                  a.RQ,
																																									                  b.RQ as RQ2,
																																									                  replace(a.BZ,'停','关') AS BZ
																																									                From HYYDNEW.YD_DBA01 A,
																																														                              (Select JH,RQ   
																																														                                From KFSJGL.GZ_KF_DYDMGC  
																																														                                where ND >= substr({{QSSJ}},0,4)
																																														                                and ND <= substr({{JSSJ}},0,4)
																																														                                and GC = '关躺井') B
																																									                where to_char(a.rq,'yyyymmdd') >= {{QSSJ}}
																																									                and to_char(a.rq,'yyyymmdd') <= {{JSSJ}}
																																									                --and (a.RCYL1 is null or a.HS is null)
																																									                and (a.SCSJ = 0 or a.SCSJ is null)
																																									                and a.JH = B.JH
																																									                ) B 
																																		              where B.BZ like '%%') D
																													            where C.jh = D.jh and C.rq = D.rq -1  
																													            order by C.jh,C.rq asc) f
																	          where e.jh = f.jh
																	          and e.rq <= f.rq2
																	          and e.scsj = 24
																	          group by e.jh
																	        ) b
				        where a.jh = b.井号
				        and a.rq = b.停井前正常生产日期 -- a是关井前正常
				      ) a left join HYYDNEW.YD_DBA01 b
		    on a.井号 = b.jh 
		    and a.停井日期 < b.rq -- b是关井后开井正常
		    and b.SCSJ = 24
		    group by a.井号
		  ) a
-- left join HYYDNEW.YD_DBA01 b
-- on a.关井后开井时间 = b.rq
order by a.停井日期GC;






-------------------Part3 产能动态预测-------------------------------------
-- 目前已经有月度的，需要做一个日度的

-- 对于阶段初日油能力标定 
-- 起始时间为某月某旬初的日期,结束时间为某月某旬末的日期 对实际增减量因素进行统计 目的是对旬度盘库数据进行补缺并作为下一步骤的起步
-- 起始时间为某月某旬末的日期,结束时间为阶段初前一天的日期 对实际增减量因素进行统计 对结束时间进行多因素汇总得到标定值


-- 计划因素，输入工作量需满足如下标准接口：
-- 类型,细分类型,单位,井号,起始时间,日液,日油,含水,自然递减,年含水上升,年液增长百分数


-- 转注安排  (日液日油为负值 自然递减为0 年含水上升为0)
-- 类型	细分类型	单位	井号	起始时间	日液	日油	含水	自然递减	年含水上升
-- 措施	起步措施	海二	CACB251D-1	2019/1/20	83	5	94	8	2


-- 实际因素，通过报表提取也可以手输但要满足如下标准接口:
-- 类型	细分类型	单位	井号	日期	日液	日油	含水


井号考核单元:
select
	JH as 井号,
	KHDY as 考核单元
from KFSJGL.GZ_KF_DYDM
order by jh;


$QSSJ:'20200101';
$JSSJ:'20201231';
时间序列:
select 
to_date({{QSSJ}},'yyyymmdd')-1+rownum as 日期
from dual connect by rownum <= (to_date({{JSSJ}},'yyyymmdd')+1-to_date({{QSSJ}},'yyyymmdd'));

@计划单因素:
select 
类型,细分类型,考核单元,单位,井号,起始时间,日液,日油,含水,自然递减,含水上升,
0.005592*log(1-自然递减/100)+1 as 天自然递减, 
含水上升/365 as 天含水上升
-- (年液增长百分数/100+1)^(1/365) as 天液量增长
from [{{YSMC}}$];


@油递减法预测:
select 
b.类型,
b.细分类型,
b.考核单元,
b.单位,
b.井号,
a.日期,
(b.日油*b.天自然递减^(a.日期-b.起始时间))/(1-(b.含水+b.天含水上升*(a.日期-b.起始时间))/100) as 日液, -- 日液 = 日油 / (1-含水/100)
b.日油*b.天自然递减^(a.日期-b.起始时间) as 日油,
b.含水+b.天含水上升*(a.日期-b.起始时间) as 含水
from [时间序列$] a, [{{YSDM}}$] b -- 起步产量
where a.日期 >= b.起始时间
order by b.井号,a.日期;

-- 汇总方式
--$YSDM:YSAP;因素安排汇总:@油递减法预测;

@井口日油计算考虑未上报表新井:
select 
	{{FJZD}}
	日期,
	count(井号) as 总井数,
	sum(是否开井) as 开井数,
	sum(日液) as 日液,
	sum(日油) as 日油,
	CASE WHEN sum(日液)>0 THEN round((sum(日液)-sum(日油))/sum(日液)*100,1) ELSE null END as 含水  
from (
	select 
		a.井号,	
		a.是否开井,
		a.单位,
		a.日期,	
		a.日液,
		a.日油,
		a.含水,
		b.考核单元,
		b.新集输方式
	from 
		(select
			A.JH as 井号,
			CASE WHEN (A.scsj is null or A.scsj=0 or A.RCYL1 is null or A.RCYL1 = 0) THEN null ELSE 1 END  as 是否开井, 
			DECODE(A.DWDM,30205480,'海一',30205483,'海一',
					    30205482,'海一',30205484,'海一',
					    30205485,'海一',30205493,'海二',
					    30205495,'海二',30205496,'海二',
					    30205497,'海二',30205498,'海二',
					    30205506,'海三',30205507,'海三',
					    30205508,'海三',30205509,'海三',
					    30205510,'海三',30205517,'海四',
					    30205519,'海四',30205520,'海四',
					    30205521,'海四',30205522,'海四',
					    30205523,'海四',30205524,'海四','不详') AS 单位,
			A.rq as 日期,
			A.RCYL1 as 日液,
			round(A.rcyl1*(1-A.HS/100),1) as 日油,
			A.HS as 含水
		from HYYDNEW.YD_DBA01 a left join KFSJGL.GZ_KF_DBA01XZ b
		on a.JH = b.JH and a.rq = b.rq
		where to_char(A.rq,'yyyymmdd')>={{QSSJ}}
		and b.JH is null
			union 	
		select 
			A.JH as 井号,
			CASE WHEN (A.scsj is null or A.scsj=0 or A.RCYL1 is null or A.RCYL1 = 0) THEN null ELSE 1 END  as 是否开井, 
			DECODE(A.DWDM,30205480,'海一',30205483,'海一',
					    30205482,'海一',30205484,'海一',
					    30205485,'海一',30205493,'海二',
					    30205495,'海二',30205496,'海二',
					    30205497,'海二',30205498,'海二',
					    30205506,'海三',30205507,'海三',
					    30205508,'海三',30205509,'海三',
					    30205510,'海三',30205517,'海四',
					    30205519,'海四',30205520,'海四',
					    30205521,'海四',30205522,'海四',
					    30205523,'海四',30205524,'海四','不详') AS 单位,
			A.rq as 日期,
			A.RCYL1 as 日液,
			A.rcyl1*(1-A.HS/100) as 日油,
			A.HS as 含水
		from KFSJGL.GZ_KF_DBA01XZ A 
		where to_char(rq,'yyyymmdd')>={{QSSJ}}
		) a left join (select JH as 井号,KHDY as 考核单元,XJSFS as 新集输方式 from KFSJGL.GZ_KF_DYDM) b on a.井号 = b.井号
	) 
group by {{FJZD}} 日期
order by {{FJZD}} 日期;

$QSSJ:'20200101';
@井口日油计算不考虑未上报表新井:
select 
	{{FJZD}}
	日期,
	count(井号) as 总井数,
	sum(是否开井) as 开井数,
	sum(日液) as 日液,
	sum(日油) as 日油,
	CASE WHEN sum(日液)>0 THEN round((sum(日液)-sum(日油))/sum(日液)*100,1) ELSE null END as 含水  
from (
	select 
		a.井号,	
		a.是否开井,
		a.单位,
		a.日期,	
		a.日液,
		a.日油,
		a.含水,
		b.考核单元
	from 
		(select
			A.JH as 井号,
			CASE WHEN (A.scsj is null or A.scsj=0 or A.RCYL1 is null or A.RCYL1 = 0) THEN null ELSE 1 END  as 是否开井, 
			DECODE(A.DWDM,30205480,'海一',30205483,'海一',
					    30205482,'海一',30205484,'海一',
					    30205485,'海一',30205493,'海二',
					    30205495,'海二',30205496,'海二',
					    30205497,'海二',30205498,'海二',
					    30205506,'海三',30205507,'海三',
					    30205508,'海三',30205509,'海三',
					    30205510,'海三',30205517,'海四',
					    30205519,'海四',30205520,'海四',
					    30205521,'海四',30205522,'海四',
					    30205523,'海四',30205524,'海四','不详') AS 单位,
			A.rq as 日期,
			A.RCYL1 as 日液,
			round(A.rcyl1*(1-A.HS/100),1) as 日油,
			A.HS as 含水
		from HYYDNEW.YD_DBA01 a 
		where to_char(A.rq,'yyyymmdd')>={{QSSJ}}
		) a left join (select JH as 井号,KHDY as 考核单元 from KFSJGL.GZ_KF_DYDM) b on a.井号 = b.井号
) 
group by {{FJZD}} 日期
order by {{FJZD}} 日期;

$QSSJ:'20200101';$FJZD:单位,    ;管理区井口日油:@井口日油计算考虑未上报表新井;


$QSSJ:'20190101';
$JSSJ:'20191212';
集输单元日分析0:
@交油历史数据;

$QSSJ:'20200101';
$JSSJ:'20201231';
实际新井追加:
select 
	'新井' as 类型,
	'前新井' as 细分类型,
	DECODE(A.DWDM,30205480,'海一',30205483,'海一',
		        30205482,'海一',30205484,'海一',
		        30205485,'海一',30205493,'海二',
		        30205495,'海二',30205496,'海二',
		        30205497,'海二',30205498,'海二',
		        30205506,'海三',30205507,'海三',
		        30205508,'海三',30205509,'海三',
		        30205510,'海三',30205517,'海四',
		        30205519,'海四',30205520,'海四',
		        30205521,'海四',30205522,'海四',
		        30205523,'海四',30205524,'海四','不详') AS 单位,
	A.JH AS 井号,
	A.rq as 日期,
	to_char(A.RCYL1) as 日液,
	to_char(round(A.rcyl1*(100-A.hs)/100,1)) as 日油,
	to_char(A.hs) as 含水
from KFSJGL.GZ_KF_DBA01XZ A
where to_char(A.rq, 'yyyymmdd') >= {{QSSJ}}
and to_char(A.rq, 'yyyymmdd') <= {{JSSJ}}
and A.JH  in 
(Select JH   
	From KFSJGL.GZ_KF_DYDMGC  
	where ND in (substr({{QSSJ}},0,4), substr({{JSSJ}},0,4))
	and GC = '新井') 
and (a.RCYL is not null);

集输单元日分析:
select 
	a.外输单元 as 外输单元, a.日期 as 日期, 
	-- a.总井数 as 总井数, a.开井数 as 开井数,
	b.总井数 as 总井数, b.开井数 as 开井数,
	round(a.外输日液,0) as 外输日液, 
	round(a.外输日油,0) as 外输日油, 
	-- iif(a.外输日液=0,0,100*(a.外输日液-a.外输日油)/a.外输日液) as 外输含水, -- a.外输含水 as 外输含水, -- 
	
	-- round(a.井口日液+iif(b.日液 is null, 0, b.日液),0) as 井口日液, 
	-- round(a.井口日油+iif(b.日油 is null, 0, b.日油),0) as 井口日油, 
	round(iif(b.日液 is null, 0, b.日液),0) as 井口日液, 
	round(iif(b.日油 is null, 0, b.日油),0) as 井口日油, 

	-- iif(a.井口日液+iif(b.日液 is null, 0, b.日液)=0,
	-- 	0,
	-- 	100*((a.井口日液+iif(b.日液 is null, 0, b.日液))-(a.井口日油+iif(b.日油 is null, 0, b.日油)))/(a.井口日液+iif(b.日液 is null, 0, b.日液))) as 井口含水 -- a.井口含水 as 井口含水, -- 
	
	a.反算日液 as 反算日液, 
	a.盘库日油 as 盘库日油
from [集输单元日分析0$] a left join [管理区井口日油$] b on a.外输单元 = b.单位 and a.日期 = b.日期;
-- 																		(select 
-- 																			单位,
-- 																			日期,
-- 																			sum(日液) as 日液,
-- 																			sum(日油) as 日油
-- 																			from [实际新井追加$]
-- 																			group by 单位,日期) b
-- on a.外输单元=b.单位 and a.日期 = cdate(b.日期);



-- 实际起步分管理区日度数据的生成
实际起步:
select 
'自然' as 类型,
'实际起步' as 细分类型,
'' as 考核单元,
b.单位 as 单位,
'' as 井号,
b.起始时间 as 起始时间,
a.反算日液 as 日液,
a.盘库日油 as 日油,
100-100*a.盘库日油/a.反算日液 as 含水,
--a.井口含水 as 含水,
b.自然递减 as 自然递减,
b.含水上升 as 含水上升
from 
[集输单元日分析$] a, [起步产量$] b
where cdate(b.起始时间) = a.日期
and b.单位 = a.外输单元;
$YSMC:实际起步;SJQB:@计划单因素;
$YSDM:SJQB;实际起步汇总:@油递减法预测; 


-- 实际措施单井日度数据的生成
$ZHDYDM:'CACX';
$QSSJ:'20181223';
$JSSJ:'20191223';
措施井历史数据0:@措施井数据查询;


$RQ:'20200101';
起始阶段油井日报:
Select 
	A.JH AS 井号,
	to_char(A.rq,'yyyymmdd') as 日期,
	CASE WHEN (A.RCYL1=0 or A.scsj is null or A.scsj=0) THEN 0 ELSE A.RCYL1 END as 日液,
	round(CASE WHEN (A.RCYL1=0 or A.scsj is null or A.scsj=0) THEN 0 ELSE A.RCYL1*(1-A.hs/100) END,1) as 日油,
	CASE WHEN A.scsj is null or A.scsj=0 THEN 0 ELSE A.hs END as 含水 
From HYYDNEW.YD_DBA01 A 
WHERE to_char(rq,'yyyymmdd') = {{RQ}};


$LXMC:('维护','措施');
措施井号:@分类构成;
措施井历史数据:select 
									a.井号,a.日期,a.单位,a.生产时间,a.日液,a.日油,a.含水,
									b.初始阶段日液,
									b.初始阶段日油,
									b.初始阶段含水,
									iif(a.日液 - iif(b.初始阶段日液 is null, 0, b.初始阶段日液) > 0, a.日液 - iif(b.初始阶段日液 is null, 0, b.初始阶段日液), 0) as 增液,
									iif(a.日油 - iif(b.初始阶段日油 is null, 0, b.初始阶段日油) > 0, a.日油 - iif(b.初始阶段日油 is null, 0, b.初始阶段日油), 0) as 增油 
								from 
									(
										select 
											* 
										from [措施井历史数据0$] a, [措施井号$] b 
										where a.井号 = b.JH
									) a left join  
																(Select 
																	井号 as JH2,
																	日期 as 初始阶段日期,
																	str(iif(日液 is null, 0, 日液)) as 初始阶段日液,
																	str(iif(日油 is null, 0, 日油)) as 初始阶段日油,
																	str(iif(含水 is null, 0, 含水)) as 初始阶段含水 
																from [起始阶段油井日报$]  -- @油井日报
																) b 
															on a.井号 = b.JH2;


实际措施汇总: -- 实际措施追加 该表与此表格式相同
select 
	a.类型,a.细分类型,b.考核单元,a.单位,a.井号,a.日期,a.日液,a.日油,a.含水
from 
	(select 类型,细分类型,单位,井号,日期,日液,日油,含水 from 
		(select
			'措施' as 类型,
			'实际措施' as 细分类型,
			a.单位,a.井号,a.日期,
			iif(a.日液-iif(b.日油 is not null, iif(b.日液 is not null, b.日液, 0), iif(a.初始阶段日液 is null,0, a.初始阶段日液)) <0,
			  0,
				a.日液-iif(b.日油 is not null, iif(b.日液 is not null, b.日液, 0), iif(a.初始阶段日液 is null,0, a.初始阶段日液))) as 日液, --日增液 

			iif(a.日油-iif(b.日油 is not null, b.日油, iif(a.初始阶段日油 is null,0, a.初始阶段日油))<0,
				0,
				a.日油-iif(b.日油 is not null, b.日油, iif(a.初始阶段日油 is null,0, a.初始阶段日油))) as 日油, --日增油
			a.含水,

			b.井号 as 井号2,
			cdate(b.日期) as 日期2
		from [措施井历史数据$] a left join (select * from [实际措施追加$]) b
		on a.井号 = b.井号 
		)
	) a left join [井号考核单元$] b on a.井号 = b.井号
order by a.单位,a.井号,year(日期)*10000+month(日期)*100+day(日期) asc;




-- 实际新井单井日度数据的生成
$QSSJ:'20181223';
$JSSJ:'20191223';
新井历史数据:@新井数据查询;


实际新井汇总0:  -- 实际新井追加 该表与此表格式相同
select * from ( 
	select 类型,细分类型,单位,井号,日期,日液,日油,含水 from 
		(select
			'新井' as 类型,
			'实际新井' as 细分类型,
			a.单位,a.井号,a.日期,a.日液, a.日油, a.含水,

			b.井号 as 井号2,
			cdate(b.日期) as 日期2
		from [新井历史数据$] a left join (select * from [实际新井追加$]) b
		on a.井号 = b.井号 and cdate(a.日期) = cdate(b.日期))
	where 井号2 is null
	union all
	select
		'新井' as 类型,
		'实际新井' as 细分类型,
		b.单位,b.井号,b.日期,b.日液, b.日油, b.含水
	from (select * from [实际新井追加$]) b
) order by 单位,井号,year(日期)*10000+month(日期)*100+day(日期) asc;


-- $YSMC:实际新井修正;SJXJXZ:@计划单因素;
实际新井汇总:
select 
	a.类型,a.细分类型,b.考核单元,a.单位,a.井号,a.日期,a.日液,a.日油,a.含水
from
	(select
		类型,细分类型,单位,井号,日期,日液,日油,含水
	from
		(select
			a.类型,a.细分类型,a.单位,a.井号,a.日期,a.日液,a.日油,a.含水,
			-- b.类型,b.细分类型,b.单位,
			b.井号 as 井号2,b.起始时间
			-- b.日液,b.日油,b.含水
		from [实际新井汇总0$] a left join [实际新井修正$] b
		on a.井号 = b.井号)
	where (井号2 is null)
	or (井号2 is not null and 日期>起始时间)
	) a left join  [井号考核单元$] b on a.井号 = b.井号;


-- 实际关井 单井日度数据的生成
-- 计划关井作业 对应两条记录 ： 关井（-作业前日液 -作业前日油） 开井（实际日液 实际日油）
$QSSJ:'20200101';
$JSSJ:'20201231';
关躺井历史数据:@关躺井数据查询;

-- 实际关井:
-- select 
-- 	'关躺井' as 类型,
-- 	'实际关躺井' as 细分类型,
-- 	a.单位,a.井号,
-- 	a.关躺井日期 as 起始时间,
-- 	-1*a.躺井前日液 as 日液,
-- 	-1*a.躺井前日油 as 日油,
-- 	a.躺井前含水 as 含水,
-- 	0 as 自然递减,
-- 	0 as 含水上升
-- from [关躺井历史数据$] a
-- where a.作业见油日期 is null;

-- 时间序列 关躺井历史数据

实际关井汇总:
select 
	a.类型, a.细分类型, b.考核单元, a.单位, a.井号, a.日期, a.日液, a.日油, a.含水
from
	(
		select 
			b.类型,
			'实际关躺井' as 细分类型,
			b.单位,
			b.井号,
			a.日期,
			-1*b.躺井前日液 as 日液,
			-1*b.躺井前日油 as 日油,
			b.躺井前含水 as 含水
		from [时间序列$] a, [关躺井历史数据$] b 
		where a.日期 >= b.关躺井日期 
		and a.日期 < iif(b.作业见油日期 is null, a.日期+1, b.作业见油日期)
	) a left join [井号考核单元$] b on a.井号 = b.井号
	order by a.单位, a.井号,a.日期 asc;



-- 影响产量 ( 自然递减为0 年含水上升为0) ？？？



$JHJH:('CACBG7-2','CAZH10A-2');
$QSSJ:'20200101';
$JSSJ:'20201231';
计划外开井历史数据:
select 
	* 
from 
(
	Select 
		DECODE(A.DWDM,30205480,'海一',30205483,'海一',
			        30205482,'海一',30205484,'海一',
			        30205485,'海一',30205493,'海二',
			        30205495,'海二',30205496,'海二',
			        30205497,'海二',30205498,'海二',
			        30205506,'海三',30205507,'海三',
			        30205508,'海三',30205509,'海三',
			        30205510,'海三',30205517,'海四',
			        30205519,'海四',30205520,'海四',
			        30205521,'海四',30205522,'海四',
			        30205523,'海四',30205524,'海四','不详') AS 单位,
		to_char(A.JH) AS 井号,
		A.rq as 日期,
		to_char(A.RCYL1) as 日液,
		to_char(round(rcyl1*(100-hs)/100,1)) as 日油,
		to_char(a.hs) as 含水

	From SJCJ.YS_DBA01 A
	where jh in {{JHJH}}
	and to_char(A.rq,'yyyymmdd') >= {{QSSJ}}
	and to_char(A.rq,'yyyymmdd') <= {{JSSJ}}
);



计划外开井汇总:
select
	a.类型,a.细分类型,b.考核单元,a.单位,a.井号,a.日期,a.日液,a.日油,a.含水
from
	(
		select 
			b.类型,
			b.细分类型,
			a.单位,
			a.井号,
			a.日期,
			a.日液-0 as 日液,
			a.日油-0 as 日油,
			a.含水-0 as 含水
		from [计划外开井历史数据$] a left join [实际老井追加$] b
		on a.井号 = b.井号
		where a.日期 >= cdate(b.日期)
	) a left join [井号考核单元$] b on a.井号 = b.井号;




-- 后措施、后新井 因素汇总

-- 类型,细分类型, 考核单元, 单位,井号,日期,日液,日油,含水
-- 1	KFSJGL	GZ_KF_ZYFY	RCYL	日油
-- 2	KFSJGL	GZ_KF_ZYFY	HS	含水
-- 3	KFSJGL	GZ_KF_ZYFY	ZRDJ	自然递减
-- 4	KFSJGL	GZ_KF_ZYFY	HSSS	含水上升
-- 5	KFSJGL	GZ_KF_ZYFY	ZYWGRQ	作业完工日期
-- 6	KFSJGL	GZ_KF_ZYFY	YLFY	作业用料费用
-- 7	KFSJGL	GZ_KF_ZYFY	LWFY	作业劳务费用
-- 8	KFSJGL	GZ_KF_ZYFY	ZGFY	暂估费用
-- 9	KFSJGL	GZ_KF_ZYFY	JHZY	计划增油
-- 10	KFSJGL	GZ_KF_ZYFY	FL	分类
-- 11	KFSJGL	GZ_KF_ZYFY	KHDY	考核单元
-- 12	KFSJGL	GZ_KF_ZYFY	RCYL1	日液
-- 13	KFSJGL	GZ_KF_ZYFY	ND	年度
-- 14	KFSJGL	GZ_KF_ZYFY	JH	井号
-- 15	KFSJGL	GZ_KF_ZYFY	ZYKGRQ	作业开工日期
-- 16	KFSJGL	GZ_KF_ZYFY	GLQ	管理区
-- 17	KFSJGL	GZ_KF_ZYFY	ZYLX	作业类型
-- 18	KFSJGL	GZ_KF_ZYFY	JSLX	结算类型
-- 19	KFSJGL	GZ_KF_ZYFY	YSFY	预算费用
-- 20	KFSJGL	GZ_KF_ZYFY	JSFY	结算费用
-- 21	KFSJGL	GZ_KF_ZYFY	BZ	备注
-- 22	KFSJGL	GZ_KF_ZYFY	VRUSERNAME	虚拟用户名
-- 23	KFSJGL	GZ_KF_ZYFY	LRSJ	录入时间
-- 24	KFSJGL	GZ_KF_ZYFY	UPLOADFLAG	上报标志
-- 25	KFSJGL	GZ_KF_ZYFY	JB	井别
-- 26	KFSJGL	GZ_KF_ZYFY	ZYPTLX	作业平台类型
-- 27	KFSJGL	GZ_KF_ZYFY	ZYLB	作业类别



后措施安排:
select 
	'措施' as 类型，
	'后措施' as 细分类型,
	a.JH as 井号,
	a.ZYWGRQ as 日期,
	a.RCYL1 as 日液,
	a.RCYL as 日油,
	a.HS as 含水
from KFSJGL.GZ_KF_ZYFY a 
where a.ND = left({{JSSJ}},4)
and a.JB = '油井'
and a.ZYLB not like '%油井转注%'
-- and a.FL like '%下步安排%'
and a.JH not in (Select JH From KFSJGL.GZ_KF_DYDMGC where ND in (substr({{QSSJ}},0,4), substr({{JSSJ}},0,4)) and  GC in ('维护','措施'));

-- $LX:'措施';$XFLX:'后措施';后措施安排:@后因素安排;

-- $LX:'新井';$XFLX:'后新井';后新井安排:@后因素安排;
后新井安排:select * from [新井安排$] a where 细分类型 like '%后%'; -- 未上报表的都要标注为后

$YSMC:后措施安排;	HCSAP:@计划单因素;
$YSDM:HCSAP;			后措施汇总:@油递减法预测;

$YSMC:后新井安排;	HXJAP:@计划单因素;
$YSDM:HXJAP;			后新井汇总:@油递减法预测;


-- 将 后措施、后新井 放到 前实际因素汇总数据表里面
-- @后因素并入:select * from [{{QYS}}$] union all select * from [{{HYS}}$];

-- $QYS:实际措施汇总;$HYS:后措施汇总;buff:@后因素并入; -- buff --> 实际措施汇总
-- $QYS:实际新井汇总;$HYS:后新井汇总;buff:@后因素并入; -- buff --> 实际新井汇总



-- 计划因素汇总
$YSMC:起步产量;	QBCL:@计划单因素;
$YSDM:QBCL;			起步产量汇总:@油递减法预测;

$YSMC:措施安排;	CSAP:@计划单因素;
$YSDM:CSAP;			措施安排汇总:@油递减法预测;

$YSMC:新井安排;	XJAP:@计划单因素;
$YSDM:XJAP;			新井安排汇总:@油递减法预测;

$YSMC:转注安排;	ZZAP:@计划单因素;
$YSDM:ZZAP;			转注安排汇总:@油递减法预测;



计划因素汇总:
select * from [起步产量汇总$] 
union all
select * from [措施安排汇总$] 
union all
select * from [新井安排汇总$] 
union all
select * from [转注安排汇总$];

实际因素汇总:
select * from [实际起步汇总$] 
union all
select * from [实际措施汇总$] 
union all
select * from [实际新井汇总$]
union all
select * from [实际关井汇总$]
union all
select * from [计划外开井汇总$];

预计因素汇总:
select * from [起步产量汇总$] 
union all
select * from [实际措施汇总$] 
union all
select * from [实际新井汇总$]
union all
select * from [实际关井汇总$]
union all
select * from [计划外开井汇总$];




-- 因素汇总统计
@因素汇总统计:
select 
a.单位,
cdate(a.日期) as 日期,
count(a.井号) as 井数,
round(sum(a.日液),0) as 日液,
round(sum(a.日油),0) as 日油,
round(100*(sum(a.日液)-sum(a.日油))/sum(a.日液),1) as 含水
from [{{BZBM}}$] a 
group by a.日期,a.单位;

-- 计划因素统计
$BZBM:起步产量汇总;		起步产量统计:			@因素汇总统计;
$BZBM:措施安排汇总;		措施安排统计:			@因素汇总统计;
$BZBM:新井安排汇总;		新井安排统计:			@因素汇总统计;
$BZBM:转注安排汇总;		转注安排统计:			@因素汇总统计;
$BZBM:计划因素汇总;		计划因素汇总统计:	@因素汇总统计;

-- 实际因素统计
$BZBM:实际措施汇总;		实际措施统计:			@因素汇总统计;
$BZBM:实际新井汇总;		实际新井统计:			@因素汇总统计;
$BZBM:实际关井汇总;		实际关井统计:			@因素汇总统计;
$BZBM:计划外开井汇总;	计划外开井统计:		@因素汇总统计;

$BZBM:实际因素汇总;		实际因素汇总统计:	@因素汇总统计;
$BZBM:预计因素汇总;		预计因素汇总统计:	@因素汇总统计;






$DWMC:采油厂;
$DWMCJH:('海一', '海二', '海三', '海四');
阶段分析表:
select 
'{{DWMC}}' as 单位, 
日期 as 日期, 

sum(总井数) as 总井数, sum(开井数) as 开井数, 

sum(井口日液) as 井口日液, 
sum(井口日油) as 井口日油,
iif(sum(井口日液)=0,0,round(100*(sum(井口日液)-sum(井口日油))/sum(井口日液),1)) as 井口含水,

sum(外输日液) as 外输日液, 
sum(外输日油) as 外输日油,
iif(sum(外输日液)=0,0,round(100*(sum(外输日液)-sum(盘库日油))/sum(外输日液),1)) as 外输含水,

-- sum(反算日液) as 反算日液, 
sum(盘库日油) as 盘库日油,

sum(计划日液) as 计划日液,
sum(计划日油) as 计划日油,
round(100-100*sum(计划日油)/sum(计划日液),1) as 计划含水,

sum(总井数)-sum(总井数) + sum(预计日液) as 预计日液,
sum(总井数)-sum(总井数) + sum(预计日油) as 预计日油,
sum(总井数)-sum(总井数) + round(100-100*sum(预计日油)/sum(预计日液),1) as 预计含水,

-- sum(实际日液) as 实际日液,
-- sum(实际日油) as 实际日油,
-- round(100-100*sum(实际日油)/sum(实际日液),1) as 实际含水,

sum(计划措施日液) as 计划措施日液, sum(计划措施日油) as 计划措施日油, round(100-100*sum(计划措施日油)/sum(计划措施日液),1) as 计划措施含水, sum(计划措施井数) as 计划措施井数,
sum(计划新井日液) as 计划新井日液, sum(计划新井日油) as 计划新井日油, round(100-100*sum(计划新井日油)/sum(计划新井日液),1) as 计划新井含水, sum(计划新井井数) as 计划新井井数,
sum(实际措施日液) as 实际措施日液, sum(实际措施日油) as 实际措施日油, round(100-100*sum(实际措施日油)/sum(实际措施日液),1) as 实际措施含水, sum(实际措施井数) as 实际措施井数,
sum(实际新井日液) as 实际新井日液, sum(实际新井日油) as 实际新井日油, round(100-100*sum(实际新井日油)/sum(实际新井日液),1) as 实际新井含水, sum(实际新井井数) as 实际新井井数,
-1*sum(实际关井日液) as 实际关井日液, -1*sum(实际关井日油) as 实际关井日油, round(100-100*sum(实际关井日油)/sum(实际关井日液),1) as 实际关井含水, sum(实际关井井数) as 实际关井井数,

sum(起步产量日液)+sum(iif(计划措施日液 is not null,计划措施日液,0)) as 计划老井日液, 
sum(起步产量日油)+sum(iif(计划措施日油 is not null,计划措施日油,0)) as 计划老井日油, 
round(100-100*(sum(起步产量日油)+sum(iif(计划措施日油 is not null,计划措施日油,0)))/(sum(起步产量日液)+sum(iif(计划措施日液 is not null,计划措施日液,0))),1) as 计划老井含水,

sum(起步产量日液) as 计划自然日液, 
sum(起步产量日油) as 计划自然日油, 
round(100-100*sum(起步产量日油)/sum(起步产量日液),1) as 计划自然含水,

sum(外输日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(计划外开井日液 is not null,计划外开井日液,0)) as 实际老井日液, 
sum(盘库日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(计划外开井日油 is not null,计划外开井日油,0)) as 实际老井日油, 
round(100-100*(sum(井口日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(计划外开井日油 is not null,计划外开井日油,0)))/(sum(井口日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(计划外开井日液 is not null,计划外开井日液,0))),1) as 实际老井含水,

-- sum(井口日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(实际措施日液 is not null,实际措施日液,0))-sum(iif(实际关井日液 is not null,实际关井日液,0)) as 实际自然日液, 
-- sum(盘库日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(实际措施日油 is not null,实际措施日油,0))-sum(iif(实际关井日油 is not null,实际关井日油,0)) as 实际自然日油, 
-- round(100-100*(sum(盘库日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(实际措施日油 is not null,实际措施日油,0))-sum(iif(实际关井日油 is not null,实际关井日油,0)))/(sum(井口日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(实际措施日液 is not null,实际措施日液,0))-sum(iif(实际关井日液 is not null,实际关井日液,0))),1) as 实际自然含水,

sum(外输日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(实际措施日液 is not null,实际措施日液,0))-sum(iif(计划外开井日液 is not null,计划外开井日液,0)) as 实际自然日液, 
sum(盘库日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(实际措施日油 is not null,实际措施日油,0))-sum(iif(计划外开井日油 is not null,计划外开井日油,0)) as 实际自然日油, 
round(100-100*(sum(井口日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(实际措施日油 is not null,实际措施日油,0))-sum(iif(计划外开井日油 is not null,计划外开井日油,0)))/(sum(井口日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(实际措施日液 is not null,实际措施日液,0))-sum(iif(计划外开井日液 is not null,计划外开井日液,0))),1) as 实际自然含水,

round(sum(井口日液)/sum(开井数),0) as 井口单井日液, 
round(sum(外输日液)/sum(开井数),0) as 外输单井日液,

-- 预计日液 不考虑关井
sum(总井数)-sum(总井数) + sum(预计日液) - sum(iif(实际关井日液 is not null,实际关井日液,0)) as 预计日液不考虑关井,
sum(总井数)-sum(总井数) + sum(预计日油) - sum(iif(实际关井日油 is not null,实际关井日油,0)) as 预计日油不考虑关井,
sum(总井数)-sum(总井数) + round(100-100*(sum(预计日油) - sum(iif(实际关井日油 is not null,实际关井日油,0)))/(sum(预计日液) - sum(iif(实际关井日液 is not null,实际关井日液,0))),1) as 预计含水不考虑关井,

-- 计划外开井
sum(计划外开井日液) as 计划外开井日液, sum(计划外开井日油) as 计划外开井日油, round(100-100*sum(计划外开井日油)/sum(计划外开井日液),1) as 计划外开井含水, sum(计划外开井井数) as 计划外开井井数

from (
		select a.单位 as 单位, a.日期 as 日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,实际日液,实际日油,实际含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,实际新井日液, 实际新井日油, 实际新井含水, 实际新井井数,实际关井日液, 实际关井日油, 实际关井含水, 实际关井井数,计划外开井日液, 计划外开井日油, 计划外开井含水, 计划外开井井数,起步产量日液, 起步产量日油, 起步产量含水,
			h.总井数 as 总井数, h.开井数 as 开井数, h.井口日液 as 井口日液, h.井口日油 as 井口日油,h.外输日液 as 外输日液, h.外输日油 as 外输日油,h.盘库日油 as 盘库日油
		from (
			select a.单位 as 单位, a.日期 as 日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,实际日液,实际日油,实际含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,实际新井日液, 实际新井日油, 实际新井含水, 实际新井井数,实际关井日液, 实际关井日油, 实际关井含水, 实际关井井数,计划外开井日液, 计划外开井日油, 计划外开井含水, 计划外开井井数,
				g.日液 as 起步产量日液, g.日油 as 起步产量日油, g.含水 as 起步产量含水 
			from (
				select a.单位 as 单位, a.日期 as 日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,实际日液,实际日油,实际含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,实际新井日液, 实际新井日油, 实际新井含水, 实际新井井数,实际关井日液, 实际关井日油, 实际关井含水, 实际关井井数,
					f3.日液 as 计划外开井日液, f3.日油 as 计划外开井日油, f3.含水 as 计划外开井含水, f3.井数 as 计划外开井井数
				from ( 
					select a.单位 as 单位, a.日期 as 日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,实际日液,实际日油,实际含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,实际新井日液, 实际新井日油, 实际新井含水, 实际新井井数,
						f2.日液 as 实际关井日液, f2.日油 as 实际关井日油, f2.含水 as 实际关井含水, f2.井数 as 实际关井井数 
					from (
						select a.单位 as 单位, a.日期 as 日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,实际日液,实际日油,实际含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,	实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,
							f.日液 as 实际新井日液, f.日油 as 实际新井日油, f.含水 as 实际新井含水, f.井数 as 实际新井井数 
						from (
							select a.单位 as 单位, a.日期 as 日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,实际日液,实际日油,实际含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,
								e.日液 as 实际措施日液, e.日油 as 实际措施日油, e.含水 as 实际措施含水, e.井数 as 实际措施井数 
							from (
								select a.单位 as 单位, a.日期 as 日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,实际日液,实际日油,实际含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,
									d.日液 as 计划新井日液, d.日油 as 计划新井日油, d.含水 as 计划新井含水, d.井数 as 计划新井井数 
								from (
									select a.单位 as 单位, a.日期 as 日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,实际日液,实际日油,实际含水,
										c.日液 as 计划措施日液, c.日油 as 计划措施日油, c.含水 as 计划措施含水, c.井数 as 计划措施井数 
									from (
										select 单位,日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,
											b.日液 as 实际日液, b.日油 as 实际日油, b.含水 as 实际含水 
										from (
											select a.单位 as 单位, cdate(a.日期) as 日期, a.日液 as 计划日液, a.日油 as 计划日油, a.含水 as 计划含水,
																																		b.日液 as 预计日液, b.日油 as 预计日油, b.含水 as 预计含水
											from [计划因素汇总统计$] a, [预计因素汇总统计$] b  
											where a.单位 = b.单位 
											and a.日期 = b.日期 
											and a.单位 in {{DWMCJH}}
										) a left join [实际因素汇总统计$] b on a.单位 = b.单位 and a.日期 = b.日期
									) a left join [措施安排统计$] c on a.单位 = c.单位 and cdate(a.日期) = c.日期
								) a left join [新井安排统计$] d on a.单位 = d.单位 and cdate(a.日期) = d.日期
							) a left join [实际措施统计$] e on a.单位 = e.单位 and cdate(a.日期) = cdate(e.日期)
						) a left join [实际新井统计$] f on a.单位 = f.单位 and cdate(a.日期) = cdate(f.日期)
					) a left join [实际关井统计$] f2 on a.单位 = f2.单位 and cdate(a.日期) = cdate(f2.日期)
				) a left join [计划外开井统计$] f3 on a.单位 = f3.单位 and cdate(a.日期) = cdate(f3.日期)
			) a left join [起步产量统计$] g on a.单位 = g.单位 and cdate(a.日期) = g.日期
		) a left join [集输单元日分析$] h on a.单位 = h.外输单元 and cdate(a.日期) = h.日期
	) a 
group by 日期
order by 日期 asc;



阶段分析表数据格式:
select
	a.单位,a.日期,a.总井数,a.开井数,
	井口日液,井口日油,井口含水,
	外输日液,外输日油,外输含水,盘库日油,
	计划日液,计划日油,计划含水,
	预计日液,预计日油,预计含水,
	计划措施日液,计划措施日油,计划措施含水,计划措施井数,
	计划新井日液,计划新井日油,计划新井含水,计划新井井数,
	实际措施日液,实际措施日油,实际措施含水,实际措施井数,
	实际新井日液,实际新井日油,实际新井含水,实际新井井数,
	实际关井日液,实际关井日油,实际关井含水,实际关井井数,
	计划老井日液,计划老井日油,计划老井含水,

	计划自然日液,计划自然日油,计划自然含水,
	实际老井日液,实际老井日油,实际老井含水,
	实际自然日液,实际自然日油,实际自然含水,
	井口单井日液,外输单井日液,
	预计日液不考虑关井,预计日油不考虑关井,预计含水不考虑关井,
	计划外开井日液,计划外开井日油,计划外开井井数

from [{{BZBM}}$] a;








-- 生成月度阶段分析表

$BZBM:后措施汇总;		后措施统计:			@因素汇总统计;
$BZBM:后新井汇总;		后新井统计:			@因素汇总统计;

月度阶段分析表数据格式: -- 附加后措施、后新井的统计
select
		a.单位,a.日期,a.总井数,a.开井数,a.井口日液,a.井口日油,a.井口含水,a.外输日液,a.外输日油,a.外输含水,a.盘库日油,a.计划日液,a.计划日油,a.计划含水,a.预计日液,a.预计日油,a.预计含水,a.计划措施日液,a.计划措施日油,a.计划措施含水,a.计划措施井数,a.计划新井日液,a.计划新井日油,a.计划新井含水,a.计划新井井数,a.实际措施日液,a.实际措施日油,a.实际措施含水,a.实际措施井数,a.实际新井日液,a.实际新井日油,a.实际新井含水,a.实际新井井数,a.实际关井日液,a.实际关井日油,a.实际关井含水,a.实际关井井数,a.计划老井日液,a.计划老井日油,a.计划老井含水,a.计划自然日液,a.计划自然日油,a.计划自然含水,a.实际老井日液,a.实际老井日油,a.实际老井含水,a.实际自然日液,a.实际自然日油,a.实际自然含水,a.井口单井日液,a.外输单井日液,a.预计日液不考虑关井,a.预计日油不考虑关井,a.预计含水不考虑关井,a.计划外开井日液,a.计划外开井日油,a.计划外开井井数,a.后措施日液, a.后措施日油, a.后措施含水, a.后措施井数
		b.日液 as 后新井日液, b.日油 as 后新井日油, b.含水 as 后新井含水, b.井数 as 后新井井数
from (
	select
		a.单位,a.日期,a.总井数,a.开井数,a.井口日液,a.井口日油,a.井口含水,a.外输日液,a.外输日油,a.外输含水,a.盘库日油,a.计划日液,a.计划日油,a.计划含水,a.预计日液,a.预计日油,a.预计含水,a.计划措施日液,a.计划措施日油,a.计划措施含水,a.计划措施井数,a.计划新井日液,a.计划新井日油,a.计划新井含水,a.计划新井井数,a.实际措施日液,a.实际措施日油,a.实际措施含水,a.实际措施井数,a.实际新井日液,a.实际新井日油,a.实际新井含水,a.实际新井井数,a.实际关井日液,a.实际关井日油,a.实际关井含水,a.实际关井井数,a.计划老井日液,a.计划老井日油,a.计划老井含水,a.计划自然日液,a.计划自然日油,a.计划自然含水,a.实际老井日液,a.实际老井日油,a.实际老井含水,a.实际自然日液,a.实际自然日油,a.实际自然含水,a.井口单井日液,a.外输单井日液,a.预计日液不考虑关井,a.预计日油不考虑关井,a.预计含水不考虑关井,a.计划外开井日液,a.计划外开井日油,a.计划外开井井数,
		b.日液 as 后措施日液, b.日油 as 后措施日油, b.含水 as 后措施含水, b.井数 as 后措施井数
	from [{{BZBM}}$] a left join [后措施统计$] b on a.单位 = b.单位 and cdate(a.日期) = cdate(b.日期)
) a left join [后新井统计$] b on a.单位 = b.单位 and cdate(a.日期) = cdate(b.日期);



月度阶段分析表1: -- 求和的部分
select
	a.单位,	
	count(a.日期) as 月天数,
	max(a.日期) as 日期,

	sum(a.盘库日油)/count(a.日期) as 合计日产油水平,
	sum(a.盘库日油) as 合计月产油量,

	sum(a.实际自然日油)/count(a.日期) as 自然日产油水平,
	sum(a.实际自然日油) as 自然月产油量,

	iif(sum(a.实际措施日油)/count(a.日期) is null, 0, sum(a.实际措施日油)/count(a.日期)) - iif(sum(a.后措施日油)/count(a.日期) is null, 0, sum(a.后措施日油)/count(a.日期)) as 前措施日产油水平,
	iif(sum(a.实际措施日油) is null, 0, sum(a.实际措施日油)) - iif(sum(a.后措施日油) is null, 0, sum(a.后措施日油)) as 前措施月产油量,

	sum(a.后措施日油)/count(a.日期) as 后措施日产油水平,
	sum(a.后措施日油) as 后措施月产油量,

	sum(a.实际措施日油)/count(a.日期) as 措施日产油水平,
	sum(a.实际措施日油) as 措施月产油量,

	iif(sum(a.实际新井日油)/count(a.日期) is null, 0, sum(a.实际新井日油)/count(a.日期)) - iif(sum(a.后新井日油)/count(a.日期) is null, 0, sum(a.后新井日油)/count(a.日期)) as 前新井日产油水平,
	iif(sum(a.实际新井日油) is null, 0, sum(a.实际新井日油)) - iif(sum(a.后新井日油) is null, 0, sum(a.后新井日油)) as 前新井月产油量,

	sum(a.后新井日油)/count(a.日期) as 后新井日产油水平,
	sum(a.后新井日油) as 后新井月产油量,

	sum(a.实际新井日油)/count(a.日期) as 新井日产油水平,
	sum(a.实际新井日油) as 新井月产油量,


	sum(a.实际自然日液)/count(a.日期) as 自然日产液水平,
	sum(a.实际自然日液) as 自然月产液量,

	sum(a.实际措施日液)/count(a.日期) as 措施日产液水平,
	sum(a.实际措施日液) as 措施月产液量,
	
	sum(a.实际新井日液)/count(a.日期) as 新井日产液水平,
	sum(a.实际新井日液) as 新井月产液量,

	sum(a.外输日液)/count(a.日期) as 合计日产液水平,
	sum(a.外输日液) as 合计月产液量,

	sum(a.实际老井日油)/sum(a.实际老井日液) as 老井综合含水,
	sum(a.实际新井日油)/sum(a.实际新井日液) as 新井综合含水,
	sum(a.盘库日油)/sum(a.外输日液) as 综合含水

from [{{BZBM}}$] a
group by a.单位, year(a.日期)*100 + month(a.日期);


月度阶段分析表2: -- 累加的部分
select 
	a.单位, a.日期,
	sum(a.合计月产油量) as 合计年累计产油量,
	sum(a.自然月产油量) as 自然年累计产油量,
	sum(a.措施月产油量) as 措施年累计产油量,
	sum(a.新井月产油量) as 新井年累计产油量,

	sum(a.合计月产液量) as 合计年累计产液量,

	sum(a.合计月产油量)/sum(a.合计月产液量) as 年含水

from [月度阶段分析表1$] a left join [月度阶段分析表1$] b on year(a.日期)*100 + month(a.日期) <= year(b.日期)*100 + month(b.日期)

月度阶段分析表3: -- 差分的部分

select
	a.单位,a.日期,

	a.实际措施井数 - iif(b.实际措施井数 is null, 0, b.实际措施井数) as 当月措施井数,
	a.实际措施井数 as 累计措施井数, -- 
	
	a.实际新井井数 - iif(b.实际新井井数 is null, 0, b.实际新井井数) as 当月新井井数,
	a.实际新井井数 as 累计新井井数 -- 

from
(
	select
		a.单位,a.日期,a.总井数,a.开井数,
		a.井口日液,a.井口日油,a.井口含水,
		a.外输日液,a.外输日油,a.外输含水,a.盘库日油,
		a.计划日液,a.计划日油,a.计划含水,
		a.预计日液,a.预计日油,a.预计含水,
		a.计划措施日液,a.计划措施日油,a.计划措施含水,a.计划措施井数,
		a.计划新井日液,a.计划新井日油,a.计划新井含水,a.计划新井井数,
		a.实际措施日液,a.实际措施日油,a.实际措施含水,a.实际措施井数,
		a.实际新井日液,a.实际新井日油,a.实际新井含水,a.实际新井井数,
		a.实际关井日液,a.实际关井日油,a.实际关井含水,a.实际关井井数,
		a.计划老井日液,a.计划老井日油,a.计划老井含水,

		a.计划自然日液,a.计划自然日油,a.计划自然含水,
		a.实际老井日液,a.实际老井日油,a.实际老井含水,
		a.实际自然日液,a.实际自然日油,a.实际自然含水,
		a.井口单井日液,a.外输单井日液,
		a.预计日液不考虑关井,a.预计日油不考虑关井,a.预计含水不考虑关井,
		a.计划外开井日液,a.计划外开井日油,a.计划外开井井数

	from [{{BZBM}}$] a,
											(
												select 
													max(a.日期) as 日期
												from {{BZBM}} a
												group by year(a.日期)*100 + month(a.日期)
											) b
	where a.日期 = b.日期
) a left join 
							(
								select
									a.单位,a.日期,a.总井数,a.开井数,
									a.井口日液,a.井口日油,a.井口含水,
									a.外输日液,a.外输日油,a.外输含水,a.盘库日油,
									a.计划日液,a.计划日油,a.计划含水,
									a.预计日液,a.预计日油,a.预计含水,
									a.计划措施日液,a.计划措施日油,a.计划措施含水,a.计划措施井数,
									a.计划新井日液,a.计划新井日油,a.计划新井含水,a.计划新井井数,
									a.实际措施日液,a.实际措施日油,a.实际措施含水,a.实际措施井数,
									a.实际新井日液,a.实际新井日油,a.实际新井含水,a.实际新井井数,
									a.实际关井日液,a.实际关井日油,a.实际关井含水,a.实际关井井数,
									a.计划老井日液,a.计划老井日油,a.计划老井含水,

									a.计划自然日液,a.计划自然日油,a.计划自然含水,
									a.实际老井日液,a.实际老井日油,a.实际老井含水,
									a.实际自然日液,a.实际自然日油,a.实际自然含水,
									a.井口单井日液,a.外输单井日液,
									a.预计日液不考虑关井,a.预计日油不考虑关井,a.预计含水不考虑关井,
									a.计划外开井日液,a.计划外开井日油,a.计划外开井井数

								from [{{BZBM}}$] a,
																		(
																			select 
																				max(a.日期) as 日期
																			from {{BZBM}} a
																			group by year(a.日期)*100 + month(a.日期)
																		) b
								where a.日期 = b.日期
							) b
on year(a.日期)*100 + month(a.日期) = year(b.日期)*100 + month(b.日期) + 1;

月度阶段分析表: -- 合起来
select 
		-- a.单位,a.日期,
		a.合计日产油水平,a.合计月产油量,a.合计年累计产油量,
		a.自然日产油水平,a.自然月产油量,a.自然年累计产油量,

		b.当月措施井数,
		b.累计措施井数, 
		a.前措施日产油水平,a.前措施月产油量,
		a.后措施日产油水平,a.后措施月产油量,
		a.措施日产油水平,a.措施月产油量,a.措施年累计产油量,
		
		b.当月新井井数,
		b.累计新井井数,
		a.前新井日产油水平,a.前新井月产油量,
		a.后新井日产油水平,a.后新井月产油量,
		a.新井日产油水平,a.新井月产油量,a.新井年累计产油量,

		a.自然日产液水平,a.自然月产液量,
		a.措施日产液水平,a.措施月产液量,
		a.新井日产液水平,a.新井月产液量,
		a.合计日产液水平,a.合计月产液量,a.合计年累计产液量,

		a.老井综合含水,a.新井综合含水,
		a.综合含水,	
		a.年含水

from
(
	select
		a.单位,a.日期,
		a.合计日产油水平,a.合计月产油量,
		a.自然日产油水平,a.自然月产油量,
		a.前措施日产油水平,a.前措施月产油量,
		a.后措施日产油水平,a.后措施月产油量,
		a.措施日产油水平,a.措施月产油量,
		a.前新井日产油水平,a.前新井月产油量,
		a.后新井日产油水平,a.后新井月产油量,
		a.新井日产油水平,a.新井月产油量,
		a.自然日产液水平,a.自然月产液量,
		a.措施日产液水平,a.措施月产液量,
		a.新井日产液水平,a.新井月产液量,
		a.合计日产液水平,a.合计月产液量,
		a.老井综合含水,a.新井综合含水,
		a.综合含水,

		b.合计年累计产油量,
		b.自然年累计产油量,
		b.措施年累计产油量,
		b.新井年累计产油量,
		b.合计年累计产液量,
		b.年含水
	from [月度阶段分析表1$] a left join [月度阶段分析表2$] b on a.单位 = b.单位 and a.日期 = b.日期
) a left join [月度阶段分析表3$] b on a.单位 = b.单位 and a.日期 = b.日期;













--查询日报表中的汇总数据
开发数据:
select 
DECODE(DYDM,'CAX8','海一','CAX9','海二','CAXA','海三','CAXB','海四','CACX','采油厂','CAQ5','海五联','XBQ8','海六联','不详') AS 单位, 
NY AS 年月,
RCYSP AS 日油水平,
RCYSP1 AS 日液水平, 
round( YCYL,0) AS 月产油量,
round( YCYL1,0) AS 月产液量,
ROUND((YCYL1-YCYL)/(YCYL1+0.000000001)*100,2) AS 含水, 
round(HSNLCYL*10000,0) AS 年产油量,
round(HSNLCYL1*10000,0) AS 年产液量,
XTCJS AS 投产井数,
XJRCYSP AS 新井日油水平,
XJRCYSP1 AS 新井日液水平,
round( XJYCYL,0) AS 新井月产油量,
round( XJYCYL1,0)  AS 新井月产液量,
round(XJNCYL*10000,0) AS 新井年产油量,
round(XJNCYL1*10000,0) AS 新井年产液量,
LJCSZJC AS 措施井数,
LJRZYSP AS 措施增油水平,
LJRZYSP1 AS 措施增液水平,
round(LJHSYZYL,0) AS 措施月增油量, 
round(LHSYZYL1,0)  AS 措施月增液量,
round(LJHSNZYL*10000,0) AS 措施年增油量,
round(LHSNZYL1*10000,0) AS 措施年增液量 
FROM HYYDNEW.YD_BB_HSCLGCSJB 
WHERE LBDM=3 
AND DYDM IN('CACX','CAX8','CAX9','CAXA','CAXB','CAQ5','XBQ8')  --,'CANT' 中区
AND NY>='201901' 
ORDER BY NY;

-- 已作业井成本统计

-- 已作业完成井 
--[ 单位	井号	类别	日期	作业费用	备注]
-- 海一	CACB11NA-10	油井措施	2019/1/1	 4,526,061.00 	已更新

-- 作业费用 
-- [类型	细分类型	单位	井号	类别	日期	费用]
-- 成本	后成本	海四	CACB25B-1	油井措施	2017/1/25	219





























-- 算作业成本
@实际作业费用:
select
	a.类型, a.井号, a.管理区, a.作业日期, a.计划增油,a.作业费用,a.采油厂费用, b.考核单元
from (
			select 
				-- a.ZYLX as 类型,
				{{ZYLX}} as 类型,
				a.JH as 井号,
				a.GLQ as 管理区,
				a.ZYKGRQ as 作业日期,
				a.JHZY as 计划增油,

				case when (a.JSFY is null or a.JSFY=0) then 
					a.YSFY
				else
					a.JSFY
				end as 作业费用,

				case when (a.BZ like '%长效治理%') then --长效治理井采油厂只出劳务费用的1/3
					-- a.JSFY 
					case when (a.JSFY is null or a.JSFY=0) then
						a.YSFY * 0.4
					else
						case when (a.LWFY is null or a.LWFY=0) then 
								a.YLFY + round((case when a.ZGFY is null then 0 else a.ZGFY end)/3,4)
						else
							-- a.YLFY + round(a.LWFY/3,4)
							a.YLFY + round(((case when a.ZGFY is null then 0 else a.ZGFY end)+a.LWFY)/3,4)
						end					
					end

				else

					case when (a.BZ like '%合作井%') then --合作经井采油厂只出用料费用
						case when (a.YLFY is null or a.YLFY=0) then
							case when a.YSFY is null then 0 else a.YSFY end
						else
							a.YLFY				
						end
					else

						case when (a.JSFY is null or a.JSFY=0) then 
							a.YSFY
						else
							a.JSFY
						end

					end

				end as 采油厂费用

			from KFSJGL.GZ_KF_ZYFY a
			where a.ND >= substr({{QSSJ}},0,4)
			and a.ND <= substr({{JSSJ}},0,4)
			{{SXTJ}}
		 ) a left join (select JH as 井号,KHDY as 考核单元 from KFSJGL.GZ_KF_DYDM) b on a.井号 = b.井号;

-- select * from KFSJGL.GZ_KF_ZYFY 

$ZYLX:'前措施';				$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '措施' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前非长效井措施费用:@实际作业费用;
$ZYLX:'前维护';				$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '维护' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前非长效井维护费用:@实际作业费用;
$ZYLX:'前水井';				$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ is null or a.BZ not like '%化学驱%')                              								and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前非长效井水井费用:@实际作业费用;
$ZYLX:'前转注井';			$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井'                     and (a.BZ is null or a.BZ not like '%化学驱%') and a.ZYLB =  '油井转注'      								and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前非长效井转注井费用:@实际作业费用;
$ZYLX:'前水源井';			$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水源井'                                                                                               								and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前非长效井水源井费用:@实际作业费用;
$ZYLX:'前化学驱';			$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ like '%化学驱%')                                                  								and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前非长效井化学驱费用:@实际作业费用;

$ZYLX:'前长效措施';		$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '措施' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ like '%长效治理%') 										 and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前长效井措施费用:@实际作业费用;
$ZYLX:'前长效维护';		$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '维护' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ like '%长效治理%') 										 and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前长效井维护费用:@实际作业费用;
$ZYLX:'前长效水井';		$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ is null or a.BZ not like '%化学驱%') 																							and (a.BZ like '%长效治理%') 										 and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前长效井水井费用:@实际作业费用;
$ZYLX:'前长效转注井';	$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井'                     and (a.BZ is null or a.BZ not like '%化学驱%') and a.ZYLB =  '油井转注'                     and (a.BZ like '%长效治理%') 										 and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前长效井转注井费用:@实际作业费用;
$ZYLX:'前长效水源井';	$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水源井'                                                                  																							and (a.BZ like '%长效治理%') 										 and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前长效井水源井费用:@实际作业费用;
$ZYLX:'前长效化学驱';	$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ like '%化学驱%')                     																							and (a.BZ like '%长效治理%') 										 and (a.FL is null or a.FL not in ('下步安排', '正作业'));实际前长效井化学驱费用:@实际作业费用;


-- 正实施
$ZYLX:'中措施';				$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '措施' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%正作业%')                     					;实际中非长效井措施费用:@实际作业费用;
$ZYLX:'中维护';				$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '维护' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%正作业%')                     					;实际中非长效井维护费用:@实际作业费用;
$ZYLX:'中水井';				$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ is null or a.BZ not like '%化学驱%')                                              and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%正作业%')                     					;实际中非长效井水井费用:@实际作业费用;
$ZYLX:'中转注井';			$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井'                     and (a.BZ is null or a.BZ not like '%化学驱%') and a.ZYLB =  '油井转注'                     and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%正作业%')                     					;实际中非长效井转注井费用:@实际作业费用;
$ZYLX:'中水源井';			$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水源井'                                                                                                               and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%正作业%')                     					;实际中非长效井水源井费用:@实际作业费用;
$ZYLX:'中化学驱';			$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ like '%化学驱%')                                                                  and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%正作业%')                     					;实际中非长效井化学驱费用:@实际作业费用;

$ZYLX:'中长效措施';		$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '措施' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ like '%长效治理%')										 and (a.FL like '%正作业%')                     					;实际中长效井措施费用:@实际作业费用;
$ZYLX:'中长效维护';		$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '维护' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ like '%长效治理%')										 and (a.FL like '%正作业%')                     					;实际中长效井维护费用:@实际作业费用;
$ZYLX:'中长效水井';		$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ is null or a.BZ not like '%化学驱%') 																							and (a.BZ like '%长效治理%')										 and (a.FL like '%正作业%')                     					;实际中长效井水井费用:@实际作业费用;
$ZYLX:'中长效转注井';	$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井'                     and (a.BZ is null or a.BZ not like '%化学驱%') and a.ZYLB =  '油井转注'                     and (a.BZ like '%长效治理%')										 and (a.FL like '%正作业%')                     					;实际中长效井转注井费用:@实际作业费用;
$ZYLX:'中长效水源井';	$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水源井'                                                                  																							and (a.BZ like '%长效治理%')										 and (a.FL like '%正作业%')                     					;实际中长效井水源井费用:@实际作业费用;
$ZYLX:'中长效化学驱';	$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ like '%化学驱%')                     																							and (a.BZ like '%长效治理%')										 and (a.FL like '%正作业%')                     					;实际中长效井化学驱费用:@实际作业费用;


-- 下步安排
$ZYLX:'后措施';				$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '措施' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%下步安排%')                     				;实际后非长效井措施费用:@实际作业费用;
$ZYLX:'后维护';				$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '维护' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%下步安排%')                     				;实际后非长效井维护费用:@实际作业费用;
$ZYLX:'后水井';				$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ is null or a.BZ not like '%化学驱%')                                              and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%下步安排%')                     				;实际后非长效井水井费用:@实际作业费用;
$ZYLX:'后转注井';			$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井'                     and (a.BZ is null or a.BZ not like '%化学驱%') and a.ZYLB =  '油井转注'                     and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%下步安排%')                     				;实际后非长效井转注井费用:@实际作业费用;
$ZYLX:'后水源井';			$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水源井'                                                                                                               and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%下步安排%')                     				;实际后非长效井水源井费用:@实际作业费用;
$ZYLX:'后化学驱';			$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ like '%化学驱%')                                                                  and (a.BZ is null or a.BZ not like '%长效治理%') and (a.FL like '%下步安排%')                     				;实际后非长效井化学驱费用:@实际作业费用;

$ZYLX:'后长效措施';		$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '措施' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ like '%长效治理%')										 and (a.FL like '%下步安排%')                     				;实际后长效井措施费用:@实际作业费用;
$ZYLX:'后长效维护';		$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井' and a.ZYLX = '维护' and (a.BZ is null or a.BZ not like '%化学驱%') and (a.ZYLB is null or a.ZYLB <> '油井转注') and (a.BZ like '%长效治理%')										 and (a.FL like '%下步安排%')                     				;实际后长效井维护费用:@实际作业费用;
$ZYLX:'后长效水井';		$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ is null or a.BZ not like '%化学驱%') 																							and (a.BZ like '%长效治理%')										 and (a.FL like '%下步安排%')                     				;实际后长效井水井费用:@实际作业费用;
$ZYLX:'后长效转注井';	$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '油井'                     and (a.BZ is null or a.BZ not like '%化学驱%') and a.ZYLB =  '油井转注'                     and (a.BZ like '%长效治理%')										 and (a.FL like '%下步安排%')                     				;实际后长效井转注井费用:@实际作业费用;
$ZYLX:'后长效水源井';	$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水源井'                                                                  																							and (a.BZ like '%长效治理%')										 and (a.FL like '%下步安排%')                     				;实际后长效井水源井费用:@实际作业费用;
$ZYLX:'后长效化学驱';	$QSSJ:'20200101';$JSSJ:'20201231';$SXTJ:and a.JB = '水井'                     and (a.BZ like '%化学驱%')                     																							and (a.BZ like '%长效治理%')										 and (a.FL like '%下步安排%')                     				;实际后长效井化学驱费用:@实际作业费用;

--
实际措施费用:select * from [实际前非长效井措施费用$] union all select * from [实际中非长效井措施费用$] union all select * from [实际后非长效井措施费用$] union all select * from [实际前长效井措施费用$] union all select * from [实际中长效井措施费用$] union all select * from [实际后长效井措施费用$];
实际维护费用:select * from [实际前非长效井维护费用$] union all select * from [实际中非长效井维护费用$] union all select * from [实际后非长效井维护费用$] union all select * from [实际前长效井维护费用$] union all select * from [实际中长效井维护费用$] union all select * from [实际后长效井维护费用$];
实际水井费用:select * from [实际前非长效井水井费用$] union all select * from [实际中非长效井水井费用$] union all select * from [实际后非长效井水井费用$] union all select * from [实际前长效井水井费用$] union all select * from [实际中长效井水井费用$] union all select * from [实际后长效井水井费用$];
实际转注井费用:select * from [实际前非长效井转注井费用$] union all select * from [实际中非长效井转注井费用$] union all select * from [实际后非长效井转注井费用$] union all select * from [实际前长效井转注井费用$] union all select * from [实际中长效井转注井费用$] union all select * from [实际后长效井转注井费用$];
实际水源井费用:select * from [实际前非长效井水源井费用$] union all select * from [实际中非长效井水源井费用$] union all select * from [实际后非长效井水源井费用$] union all select * from [实际前长效井水源井费用$] union all select * from [实际中长效井水源井费用$] union all select * from [实际后长效井水源井费用$];
实际化学驱费用:select * from [实际前非长效井化学驱费用$] union all select * from [实际中非长效井化学驱费用$] union all select * from [实际后非长效井化学驱费用$] union all select * from [实际前长效井化学驱费用$] union all select * from [实际中长效井化学驱费用$] union all select * from [实际后长效井化学驱费用$];



-- 下步安排 测试专用接口
-- $BZBM:实际措施长效井费用下步安排;
-- @实际作业费用下步安排计划增油修正:
-- select
-- 	a.类型, a.井号, a.管理区, a.作业日期, a.作业费用,a.采油厂费用,b.增油能力 as 计划增油, a.考核单元
-- from [{{BZBM}}$] a left join [作业费用下步安排$] b on a.井号 = b.井号 and a.类型 = b.作业类型;


@因素汇总作业费用: --分因素单井日度累积计算
select
b.类型, b.井号, b.考核单元, b.管理区 as 单位, {{BYZD}} as 增油, a.日期, b.作业费用
from [时间序列$] a, [{{ZYDM}}$] b
where a.日期 >= cdate(b.作业日期)
order by b.井号,a.日期;

$ZYDM:计划措施费用;                $BYZD:null as 采油厂费用,b.计划增油;计划措施费用汇总:@因素汇总作业费用;
$ZYDM:计划维护费用;                $BYZD:null as 采油厂费用,b.计划增油;计划维护费用汇总:@因素汇总作业费用;
$ZYDM:计划水井费用;                $BYZD:null as 采油厂费用,      null;计划水井费用汇总:@因素汇总作业费用;
$ZYDM:计划转注井费用;              $BYZD:null as 采油厂费用,      null;计划转注井费用汇总:@因素汇总作业费用;
$ZYDM:计划水源井费用;              $BYZD:null as 采油厂费用,      null;计划水源井费用汇总:@因素汇总作业费用;

$ZYDM:实际措施费用;                $BYZD:      b.采油厂费用,b.计划增油;实际措施费用汇总0:@因素汇总作业费用;
$ZYDM:实际维护费用;                $BYZD:      b.采油厂费用,b.计划增油;实际维护费用汇总0:@因素汇总作业费用;
$ZYDM:实际水井费用;                $BYZD:      b.采油厂费用,      null;实际水井费用汇总:@因素汇总作业费用;
$ZYDM:实际转注井费用;              $BYZD:      b.采油厂费用,      null;实际转注井费用汇总:@因素汇总作业费用;
$ZYDM:实际水源井费用;              $BYZD:      b.采油厂费用,      null;实际水源井费用汇总:@因素汇总作业费用;
$ZYDM:实际化学驱费用;              $BYZD:      b.采油厂费用,      null;实际化学驱费用汇总:@因素汇总作业费用;

-- $ZYDM:实际措施长效井费用;          $BYZD:      b.采油厂费用,      null;实际措施长效井费用汇总0:@因素汇总作业费用;
-- $ZYDM:实际维护长效井费用;          $BYZD:      b.采油厂费用,      null;实际维护长效井费用汇总0:@因素汇总作业费用;
-- $ZYDM:实际水井长效井费用;          $BYZD:      b.采油厂费用,      null;实际水井长效井费用汇总:@因素汇总作业费用;
-- $ZYDM:实际转注长效井费用;          $BYZD:      b.采油厂费用,      null;实际转注长效井费用汇总:@因素汇总作业费用;
-- $ZYDM:实际水源长效井费用;          $BYZD:      b.采油厂费用,      null;实际水源长效井费用汇总:@因素汇总作业费用;
-- $ZYDM:实际化学驱长效井费用;        $BYZD:      b.采油厂费用,      null;实际化学驱长效井费用汇总:@因素汇总作业费用;

-- $ZYDM:实际措施费用下步安排;        $BYZD:      b.采油厂费用,b.计划增油;实际措施费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际维护费用下步安排;        $BYZD:      b.采油厂费用,b.计划增油;实际维护费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际水井费用下步安排;        $BYZD:      b.采油厂费用,      null;实际水井费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际转注井费用下步安排;      $BYZD:      b.采油厂费用,      null;实际转注井费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际水源井费用下步安排;      $BYZD:      b.采油厂费用,      null;实际水源井费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际化学驱费用下步安排;      $BYZD:      b.采油厂费用,      null;实际化学驱费用汇总下步安排:@因素汇总作业费用;

-- $ZYDM:实际措施长效井费用下步安排;  $BYZD:      b.采油厂费用,b.计划增油;实际措施长效井费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际维护长效井费用下步安排;  $BYZD:      b.采油厂费用,b.计划增油;实际维护长效井费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际水井长效井费用下步安排;  $BYZD:      b.采油厂费用,      null;实际水井长效井费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际转注长效井费用下步安排;  $BYZD:      b.采油厂费用,      null;实际转注长效井费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际水源长效井费用下步安排;  $BYZD:      b.采油厂费用,      null;实际水源长效井费用汇总下步安排:@因素汇总作业费用;
-- $ZYDM:实际化学驱长效井费用下步安排;$BYZD:      b.采油厂费用,      null;实际化学驱长效井费用汇总下步安排:@因素汇总作业费用;

@实际作业费用汇总增油修正:
select 
a.类型,
a.井号,
a.考核单元,
a.单位,
a.采油厂费用,
-- str(iif(b.日油 is null,0,b.日油)) as 增油,
iif(a.类型 like '%前%', str(iif(b.日油 is null,0,b.日油)), a.增油) as 增油,
a.日期,
a.作业费用

from [{{HZBM}}$] a left join [实际措施汇总$] b  -- 类型 细分类型 单位 井号 日期  日油   
on a.井号 = b.井号 
and a.日期 = b.日期;
-- and a.类型 like '%前%';

$HZBM:实际措施费用汇总0;      实际措施费用汇总:@实际作业费用汇总增油修正;
$HZBM:实际维护费用汇总0;      实际维护费用汇总:@实际作业费用汇总增油修正;
-- $HZBM:实际措施长效井费用汇总0;实际措施长效井费用汇总:@实际作业费用汇总增油修正;
-- $HZBM:实际维护长效井费用汇总0;实际维护长效井费用汇总:@实际作业费用汇总增油修正;

-- 生成全年统计表时需要 对JSSJ之后的增油修正为JSSJ当天的增油
@实际作业费用汇总增油预测:
select 
a.类型,
a.井号,
a.考核单元,
a.单位,
a.采油厂费用,
-- str(iif(a.日期 > b.日期, b.日油, a.增油)) as 增油,
iif(a.类型 like '%前%' and a.日期 > b.日期, b.日油, a.增油) as 增油,
-- a.增油,
-- b.日期 as 日期b,
-- b.日油,
a.日期,
a.作业费用
from [{{HZBM}}$] a left join (select * from [实际措施汇总$] where year(日期)*10000 + month(日期)*100 + day(日期)  = {{JSSJ}} + 0) b  -- 类型 细分类型 单位 井号 日期  日油   
on a.井号 = b.井号;

-- $JSSJ:'20200521';
-- $HZBM:实际措施费用汇总;
-- @实际作业费用汇总增油预测;




-- 生成全年统计表时需要 叠加下步安排
-- $HZBM1:实际措施费用汇总;
-- $HZBM2:实际措施费用汇总下步安排;
-- @实际作业费用汇总叠加下步安排:
-- select a.类型,a.井号,a.考核单元,a.单位,a.采油厂费用,a.增油,a.日期,a.作业费用 from [{{HZBM1}}$] a union all
-- select a.类型,a.井号,a.考核单元,a.单位,a.采油厂费用,a.增油,a.日期,a.作业费用 from [{{HZBM2}}$] a;



@因素汇总统计作业成本:
select 
a.单位,
cdate(a.日期) as 日期,
count(a.井号) as 井数,
str(round(sum(a.增油),0)) as 增油,
round(sum(a.作业费用),0) as 作业费用,
round(sum(a.采油厂费用),0) as 采油厂费用
from {{BZBM}} a 
{{SXTJ}}
group by a.日期,a.单位
order by a.单位,a.日期 asc;

$BZBM:[计划措施费用汇总$];  			$SXTJ:  ;													计划措施费用统计:@因素汇总统计作业成本;
$BZBM:[计划维护费用汇总$];  			$SXTJ:  ;													计划维护费用统计:@因素汇总统计作业成本;
$BZBM:[计划水井费用汇总$];  			$SXTJ:  ;													计划水井费用统计:@因素汇总统计作业成本;
$BZBM:[计划水源井费用汇总$];			$SXTJ:  ;													计划水源井费用统计:@因素汇总统计作业成本;
$BZBM:[计划转注井费用汇总$];			$SXTJ:  ;													计划转注井费用统计:@因素汇总统计作业成本;


-- 已完成、正进行
$BZBM:[实际措施费用汇总$];  			$SXTJ: where a.类型 not like '%后%';		实际措施费用统计:@因素汇总统计作业成本;
$BZBM:[实际维护费用汇总$];  			$SXTJ: where a.类型 not like '%后%';		实际维护费用统计:@因素汇总统计作业成本;
$BZBM:[实际水井费用汇总$];  			$SXTJ: where a.类型 not like '%后%';		实际水井费用统计:@因素汇总统计作业成本;
$BZBM:[实际水源井费用汇总$];			$SXTJ: where a.类型 not like '%后%';		实际水源井费用统计:@因素汇总统计作业成本;
$BZBM:[实际转注井费用汇总$];			$SXTJ: where a.类型 not like '%后%';		实际转注井费用统计:@因素汇总统计作业成本;
$BZBM:[实际化学驱费用汇总$];			$SXTJ: where a.类型 not like '%后%';		实际化学驱费用统计:@因素汇总统计作业成本;

-- 正进行 实际中措施费用统计


-- (全年统计) 下步安排 实际后措施费用统计

-- 长效井
$BZBM:[实际措施费用汇总$];				$SXTJ: where a.类型 like '%长效%';	实际措施长效井费用统计:@因素汇总统计作业成本;
$BZBM:[实际维护费用汇总$];				$SXTJ: where a.类型 like '%长效%';	实际维护长效井费用统计:@因素汇总统计作业成本;
$BZBM:[实际水井费用汇总$];				$SXTJ: where a.类型 like '%长效%';	实际水井长效井费用统计:@因素汇总统计作业成本;
$BZBM:[实际水源费用汇总$];				$SXTJ: where a.类型 like '%长效%';	实际水源长效井费用统计:@因素汇总统计作业成本;
$BZBM:[实际转注费用汇总$];				$SXTJ: where a.类型 like '%长效%';	实际转注长效井费用统计:@因素汇总统计作业成本;
$BZBM:[实际化学驱费用汇总$];			$SXTJ: where a.类型 like '%长效%';	实际化学驱长效井费用统计:@因素汇总统计作业成本;

-- 
计划作业费用汇总:
select * from [计划措施费用汇总$] union all select * from [计划维护费用汇总$] union all select * from [计划水井费用汇总$] union all select * from [计划转注井费用汇总$] union all select * from [计划水源井费用汇总$];

实际作业费用汇总:
select * from [实际措施费用汇总$] union all select * from [实际维护费用汇总$] union all select * from [实际水井费用汇总$] union all select * from [实际转注井费用汇总$] union all select * from [实际水源井费用汇总$]; -- 化学驱不走成本

$BZBM:[计划作业费用汇总$];
$SXTJ:  ;
计划作业费用统计:@因素汇总统计作业成本;

$BZBM:[实际作业费用汇总$]; 
$SXTJ: where a.类型 not like '%后%';
实际作业费用统计:@因素汇总统计作业成本;

-- (全年统计 小表)
-- 已完成费用合计:			select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%'                         ) {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 正进行费用合计:			select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%'                         ) {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 下步安排费用合计:		select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%'                         ) {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);

-- 已完成费用措施:			select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%措施%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 正进行费用措施:			select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%措施%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 下步安排费用措施:		select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%措施%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);

-- 已完成费用维护:			select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%维护%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 正进行费用维护:			select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%维护%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 下步安排费用维护:		select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%维护%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);

-- 已完成费用水井:			select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%水井%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 正进行费用水井:			select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%水井%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 下步安排费用水井:		select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%水井%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);

-- 已完成费用转注井:		select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%转注%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 正进行费用转注井:		select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%转注%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 下步安排费用转注井:	select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%转注%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);

-- 已完成费用水源井:		select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%水源%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 正进行费用水源井:		select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%水源%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);
-- 下步安排费用水源井:	select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%水源%') {{SXTJ}} and 日期 = (select max(日期) from [实际作业费用汇总$]);

$SXTJ: and a.单位 = '海一' and a.日期 = cdate('2020/06/22');
当前费用统计:	
select * from (select * from
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%措施%') {{SXTJ}} ) a,    -- and 日期 = (select max(日期) from [实际作业费用汇总$])
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%措施%') {{SXTJ}} ) b) a,
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%措施%') {{SXTJ}} ) b
union all select * from (select * from
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%维护%') {{SXTJ}} ) a,
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%维护%') {{SXTJ}} ) b) a, 
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%维护%') {{SXTJ}} ) b 
union all select * from (select * from
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%水井%') {{SXTJ}} ) a, 
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%水井%') {{SXTJ}} ) b) a, 
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%水井%') {{SXTJ}} ) b 
union all select * from (select * from
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%转注%') {{SXTJ}} ) a, 
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%转注%') {{SXTJ}} ) b) a, 
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%转注%') {{SXTJ}} ) b 
union all select * from (select * from
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%' and a.类型 like '%水源%') {{SXTJ}} ) a, 
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%' and a.类型 like '%水源%') {{SXTJ}} ) b) a, 
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%' and a.类型 like '%水源%') {{SXTJ}} ) b
union all select * from (select * from
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%前%'                         ) {{SXTJ}} ) a,
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%中%'                         ) {{SXTJ}} ) b) a,
(select count(a.井号) as 井数,sum(a.增油) as 增油,sum(a.作业费用) as 作业费用 from [实际作业费用汇总$] a where (a.类型 like '%后%'                         ) {{SXTJ}} ) b;












$DWMC:('海二');开井数: select sum(a.开井数), month(a.日期)*100+day(a.日期) from [集输单元日分析$] a where a.日期 = (select max(日期) from [集输单元日分析$]) and a.外输单元 in {{DWMC}} group by a.日期;


躺井率0:
select
	a.日期,
	a.外输单元,
	a.开井数
from [集输单元日分析$] a, (
														select 
															max(a.日期) as 日期
														from [集输单元日分析$] a
														group by year(a.日期)*100 + month(a.日期)
													) b
where a.日期 = b.日期
and a.外输单元 in ('海一','海二','海三','海四');

躺井率1:
select
	a.外输单元, a.日期, sum(b.开井数) as 开井数
from [躺井率0$] a, [躺井率0$] b 
where a.外输单元 = b.外输单元
and a.日期 >= b.日期 
group by a.外输单元, a.日期;

躺井率:
select
	a.日期,
	a.外输单元 as 单位,
	iif(b.躺井数 is null, 0, b.躺井数) as 躺井数,
	a.开井数
	-- round(b.躺井数/a.总井数*100,2) as 躺井率
from (
				select
					a.日期, a.外输单元, b.开井数
				from [集输单元日分析$] a left join [躺井率1$] b
				on a.外输单元 = b.外输单元
				and year(a.日期)*100 + month(a.日期) = year(b.日期)*100 + month(b.日期)
				where a.外输单元 in ('海一','海二','海三','海四')
			) a left join (
											select
									 			a.日期,
									 			a.单位,
									 			count(a.井号) as 躺井数
									 		from
									 			(
									 				select
									 					a.日期,
									 					b.单位,
									 					b.井号
									 				from [时间序列$] a, [关躺井历史数据$] b 
									 				where a.日期 >= b.关躺井日期
									 			) a
									 			group by a.单位,a.日期
									 	) b
on a.日期 = cdate(b.日期) 
and a.外输单元 = b.单位
where a.外输单元 in ('海一','海二','海三','海四');

$DWMC:'海一';
$DWMCJH:('海一');
@作业成本效果评价:
select
	-- a.日期, '海二' as 单位,
	a.日期, {{DWMC}} as 单位,
	str(sum(a.措施计划井数)) as 措施计划井数, str(sum(a.措施计划增油)) as 措施计划增油, str(sum(a.措施计划费用)) as 措施计划费用,
	str(sum(a.维护计划井数)) as 维护计划井数, str(sum(a.维护计划增油)) as 维护计划增油, str(sum(a.维护计划费用)) as 维护计划费用,
	str(sum(a.水井计划井数)) as 水井计划井数, str(sum(a.水井计划费用)) as 水井计划费用,
	str(sum(a.转注井计划井数)) as 转注井计划井数, str(sum(a.转注井计划费用)) as 转注井计划费用,
	str(sum(a.水源井计划井数)) as 水源井计划井数, str(sum(a.水源井计划费用)) as 水源井计划费用,
	str(sum(a.计划作业总井数)) as 计划作业总井数, str(sum(a.计划作业增油)) as 计划作业增油, str(sum(a.计划作业总费用)) as 计划作业总费用,
	str(sum(a.措施完成井数)) as 措施完成井数, str(sum(a.措施完成增油)) as 措施完成增油, str(sum(a.措施完成费用)) as 措施完成费用,
	str(sum(a.维护完成井数)) as 维护完成井数, str(sum(a.维护完成增油)) as 维护完成增油, str(sum(a.维护完成费用)) as 维护完成费用,
	str(sum(a.水井完成井数)) as 水井完成井数, str(sum(a.水井完成费用)) as 水井完成费用, 
	str(sum(a.转注井完成井数)) as 转注井完成井数, str(sum(a.转注井完成费用)) as 转注井完成费用, 
	str(sum(a.水源井完成井数)) as 水源井完成井数, str(sum(a.水源井完成费用)) as 水源井完成费用, 
	str(sum(a.作业完成总井数)) as 作业完成总井数, str(sum(a.作业增油)) as 作业增油, str(sum(a.作业完成总费用)) as 作业完成总费用, 
	round(sum(a.躺井数)/sum(a.开井数)*100,2) as 阶段躺井率,
	0.5 as 计划躺井率,

	str(sum(a.化学驱完成井数)) as 化学驱完成井数, str(sum(a.化学驱完成费用)) as 化学驱完成费用,

	str(sum(a.措施完成采油厂费用)) as 措施完成采油厂费用,
	str(sum(a.维护完成采油厂费用)) as 维护完成采油厂费用,
	str(sum(a.水井完成采油厂费用)) as 水井完成采油厂费用,
	str(sum(a.转注井完成采油厂费用)) as 转注井完成采油厂费用,
	str(sum(a.水源井完成采油厂费用)) as 水源井完成采油厂费用,
	str(sum(a.化学驱完成采油厂费用)) as 化学驱完成采油厂费用,
	str(sum(a.作业完成采油厂费用)) as 作业完成采油厂费用,

	str(sum(a.措施完成长效井井数)) as 措施完成长效井井数, str(sum(a.措施完成长效井费用)) as 措施完成长效井费用,str(sum(a.措施完成长效井采油厂费用)) as 措施完成长效井采油厂费用,
	str(sum(a.维护完成长效井井数)) as 维护完成长效井井数, str(sum(a.维护完成长效井费用)) as 维护完成长效井费用,str(sum(a.维护完成长效井采油厂费用)) as 维护完成长效井采油厂费用,
	str(sum(a.水井完成长效井井数)) as 水井完成长效井井数, str(sum(a.水井完成长效井费用)) as 水井完成长效井费用,str(sum(a.水井完成长效井采油厂费用)) as 水井完成长效井采油厂费用,
	str(sum(a.水源井完成长效井井数)) as 水源井完成长效井井数, str(sum(a.水源井完成长效井费用)) as 水源井完成长效井费用,str(sum(a.水源井完成长效井采油厂费用)) as 水源井完成长效井采油厂费用,
	str(sum(a.转注井完成长效井井数)) as 转注井完成长效井井数, str(sum(a.转注井完成长效井费用)) as 转注井完成长效井费用,str(sum(a.转注井完成长效井采油厂费用)) as 转注井完成长效井采油厂费用,
	str(sum(a.化学驱完成长效井井数)) as 化学驱完成长效井井数, str(sum(a.化学驱完成长效井费用)) as 化学驱完成长效井费用,str(sum(a.化学驱完成长效井采油厂费用)) as 化学驱完成长效井采油厂费用
from
	(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, a.作业完成总井数, a.作业增油, a.作业完成总费用, a.作业完成采油厂费用,a.化学驱完成井数, a.化学驱完成费用, a.化学驱完成采油厂费用,a.措施完成长效井井数,a.措施完成长效井费用,a.措施完成长效井采油厂费用,a.维护完成长效井井数,a.维护完成长效井费用,a.维护完成长效井采油厂费用,a.水井完成长效井井数,a.水井完成长效井费用,a.水井完成长效井采油厂费用,a.水源井完成长效井井数,a.水源井完成长效井费用,a.水源井完成长效井采油厂费用,a.转注井完成长效井井数,a.转注井完成长效井费用,a.转注井完成长效井采油厂费用,a.化学驱完成长效井井数,a.化学驱完成长效井费用,a.化学驱完成长效井采油厂费用,
		b.躺井数, b.开井数
		from
		(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, a.作业完成总井数, a.作业增油, a.作业完成总费用, a.作业完成采油厂费用,a.化学驱完成井数, a.化学驱完成费用, a.化学驱完成采油厂费用,a.措施完成长效井井数,a.措施完成长效井费用,a.措施完成长效井采油厂费用,a.维护完成长效井井数,a.维护完成长效井费用,a.维护完成长效井采油厂费用,a.水井完成长效井井数,a.水井完成长效井费用,a.水井完成长效井采油厂费用,a.水源井完成长效井井数,a.水源井完成长效井费用,a.水源井完成长效井采油厂费用,a.转注井完成长效井井数,a.转注井完成长效井费用,a.转注井完成长效井采油厂费用,
			b.井数 as 化学驱完成长效井井数, b.作业费用 as 化学驱完成长效井费用, b.采油厂费用 as 化学驱完成长效井采油厂费用
			from
			(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, a.作业完成总井数, a.作业增油, a.作业完成总费用, a.作业完成采油厂费用,a.化学驱完成井数, a.化学驱完成费用, a.化学驱完成采油厂费用,a.措施完成长效井井数,a.措施完成长效井费用,a.措施完成长效井采油厂费用,a.维护完成长效井井数,a.维护完成长效井费用,a.维护完成长效井采油厂费用,a.水井完成长效井井数,a.水井完成长效井费用,a.水井完成长效井采油厂费用,a.水源井完成长效井井数,a.水源井完成长效井费用,a.水源井完成长效井采油厂费用,
				b.井数 as 转注井完成长效井井数, b.作业费用 as 转注井完成长效井费用, b.采油厂费用 as 转注井完成长效井采油厂费用
				from
				(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, a.作业完成总井数, a.作业增油, a.作业完成总费用, a.作业完成采油厂费用,a.化学驱完成井数, a.化学驱完成费用, a.化学驱完成采油厂费用,a.措施完成长效井井数,a.措施完成长效井费用,a.措施完成长效井采油厂费用,a.维护完成长效井井数,a.维护完成长效井费用,a.维护完成长效井采油厂费用,a.水井完成长效井井数,a.水井完成长效井费用,a.水井完成长效井采油厂费用,
					b.井数 as 水源井完成长效井井数, b.作业费用 as 水源井完成长效井费用, b.采油厂费用 as 水源井完成长效井采油厂费用
					from
					(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, a.作业完成总井数, a.作业增油, a.作业完成总费用, a.作业完成采油厂费用,a.化学驱完成井数, a.化学驱完成费用, a.化学驱完成采油厂费用,a.措施完成长效井井数,a.措施完成长效井费用,a.措施完成长效井采油厂费用,a.维护完成长效井井数,a.维护完成长效井费用,a.维护完成长效井采油厂费用,
						b.井数 as 水井完成长效井井数, b.作业费用 as 水井完成长效井费用, b.采油厂费用 as 水井完成长效井采油厂费用
						from
						(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, a.作业完成总井数, a.作业增油, a.作业完成总费用, a.作业完成采油厂费用,a.化学驱完成井数, a.化学驱完成费用, a.化学驱完成采油厂费用,a.措施完成长效井井数,a.措施完成长效井费用,a.措施完成长效井采油厂费用,
							b.井数 as 维护完成长效井井数, b.作业费用 as 维护完成长效井费用, b.采油厂费用 as 维护完成长效井采油厂费用
							from
							(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, a.作业完成总井数, a.作业增油, a.作业完成总费用, a.作业完成采油厂费用,a.化学驱完成井数, a.化学驱完成费用, a.化学驱完成采油厂费用,
								b.井数 as 措施完成长效井井数, b.作业费用 as 措施完成长效井费用, b.采油厂费用 as 措施完成长效井采油厂费用
								from
								(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, a.作业完成总井数, a.作业增油, a.作业完成总费用, a.作业完成采油厂费用,
									b.井数 as 化学驱完成井数, b.作业费用 as 化学驱完成费用, b.采油厂费用 as 化学驱完成采油厂费用
									from
									(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, 
										b.井数 as 作业完成总井数, b.增油 as 作业增油, b.作业费用 as 作业完成总费用, b.采油厂费用 as 作业完成采油厂费用
										from
										(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,	a.水源井完成井数, a.水源井完成费用, a.水源井完成采油厂费用,
											b.井数 as 计划作业总井数, b.增油 as 计划作业增油, b.作业费用 as 计划作业总费用 
											from
											(select a.日期, a.单位,  a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,	a.转注井完成井数, a.转注井完成费用, a.转注井完成采油厂费用,
												b.井数 as 水源井完成井数, b.作业费用 as 水源井完成费用, b.采油厂费用 as 水源井完成采油厂费用
												from	
												(select	a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用, a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,	a.水井完成井数, a.水井完成费用, a.水井完成采油厂费用,
													b.井数 as 转注井完成井数, b.作业费用 as 转注井完成费用, b.采油厂费用 as 转注井完成采油厂费用
													from
													(select	a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用, a.维护完成采油厂费用,
														b.井数 as 水井完成井数, b.作业费用 as 水井完成费用, b.采油厂费用 as 水井完成采油厂费用
														from
														(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用, a.水源井计划井数, a.水源井计划费用, a.措施完成井数, a.措施完成增油, a.措施完成费用, a.措施完成采油厂费用,
															b.井数 as 维护完成井数, b.增油 as 维护完成增油, b.作业费用 as 维护完成费用, b.采油厂费用 as 维护完成采油厂费用
															from
															(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,
																b.井数 as 措施完成井数, b.增油 as 措施完成增油, b.作业费用 as 措施完成费用,  b.采油厂费用 as 措施完成采油厂费用
																from
																(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用, a.转注井计划井数, a.转注井计划费用,
																	b.井数 as 水源井计划井数, b.作业费用 as 水源井计划费用 
																	from
																	(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,a.水井计划井数, a.水井计划费用,
																		b.井数 as 转注井计划井数, b.作业费用 as 转注井计划费用 
																		from
																		(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,
																			b.井数 as 水井计划井数, b.作业费用 as 水井计划费用 
																			from 
																			(select a.日期, a.单位, a.措施计划井数, a.措施计划增油, a.措施计划费用,
																				b.井数 as 维护计划井数, b.增油 as 维护计划增油, b.作业费用 as 维护计划费用
																				from 
																				(select a.日期, a.单位, 
																					b.井数 as 措施计划井数, b.增油 as 措施计划增油, b.作业费用 as 措施计划费用
																					from (select 日期,单位 from [时间序列$], (select distinct(单位)	from [躺井率$])) a 
																																															 left join (
																																																				  select * 
																																																						from [计划措施费用统计$] b 
																																																				 ) b on a.单位 = b.单位 and a.日期 = b.日期
																																																						where a.单位 in {{DWMCJH}}
																																																						-- where a..单位 in ('海一','海三')
																				) a left join [计划维护费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
																			) a left join [计划水井费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
																		) a left join [计划转注井费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
																	) a left join [计划水源井费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
																) a left join [实际措施费用统计$] b on a.单位 = b.单位 and a.日期 = b.日期
															) a left join [实际维护费用统计$] b on a.单位 = b.单位 and a.日期 = b.日期
														) a left join [实际水井费用统计$] b on a.单位 = b.单位 and a.日期 = b.日期
													) a left join [实际转注井费用统计$] b on a.单位 = b.单位 and a.日期 = b.日期
												) a left join [实际水源井费用统计$] b on a.单位 = b.单位 and a.日期 = b.日期
											) a left join [计划作业费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
										) a left join [实际作业费用统计$] b on a.单位 = b.单位 and a.日期 = b.日期
									) a left join [实际化学驱费用统计$] b on a.单位 = b.单位 and a.日期 = b.日期
								) a left join [实际措施长效井费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
							) a left join [实际维护长效井费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
						) a left join [实际水井长效井费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
					) a left join [实际水源长效井费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
				) a left join [实际转注长效井费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
			) a left join [实际化学驱长效井费用统计$] b on a.单位 = b.单位 and a.日期 = cdate(b.日期)
		) a left join (select 日期,单位,躺井数,开井数 from [躺井率$] where 单位 in {{DWMCJH}}) b on a.单位 = b.单位 and  a.日期 = cdate(b.日期)
	) a 
group by a.日期;

$DWMC:'海一';
$DWMCJH:('海一');
采油厂成本0:@作业成本效果评价;



-- 解决数据格式问题
@作业成本效果评价数据格式:
select
		a.日期, a.单位,
		a.措施计划井数+0 as 措施计划井数, a.措施计划增油+0 as 措施计划增油, a.措施计划费用+0 as 措施计划费用,
		a.维护计划井数+0 as 维护计划井数, a.维护计划增油+0 as 维护计划增油, a.维护计划费用+0 as 维护计划费用,
		a.水井计划井数+0 as 水井计划井数, a.水井计划费用+0 as 水井计划费用,
		a.转注井计划井数+0 as 转注井计划井数, a.转注井计划费用+0 as 转注井计划费用,
		a.水源井计划井数+0 as 水源井计划井数, a.水源井计划费用+0 as 水源井计划费用,
		a.计划作业总井数+0 as 计划作业总井数, a.计划作业增油+0 as 计划作业增油, a.计划作业总费用+0 as 计划作业总费用,
		a.措施完成井数+0 as 措施完成井数, a.措施完成增油+0 as 措施完成增油, a.措施完成费用+0 as 措施完成费用, 
		a.维护完成井数+0 as 维护完成井数, a.维护完成增油+0 as 维护完成增油, a.维护完成费用+0 as 维护完成费用, 
		a.水井完成井数+0 as 水井完成井数, a.水井完成费用+0 as 水井完成费用, 
		a.转注井完成井数+0 as 转注井完成井数, a.转注井完成费用+0 as 转注井完成费用, 
		a.水源井完成井数+0 as 水源井完成井数, a.水源井完成费用+0 as 水源井完成费用, 
		a.作业完成总井数+0 as 作业完成总井数, a.作业增油+0 as 作业增油, a.作业完成总费用+0 as 作业完成总费用, 
		a.阶段躺井率,
		a.计划躺井率,
		a.化学驱完成井数+0 as 化学驱完成井数, a.化学驱完成费用+0 as 化学驱完成费用
		-- ,
		-- a.措施完成采油厂费用+0 as 措施完成采油厂费用,
		-- a.维护完成采油厂费用+0 as 维护完成采油厂费用,
		-- a.水井完成采油厂费用+0 as 水井完成采油厂费用,
		-- a.转注井完成采油厂费用+0 as 转注井完成采油厂费用,
		-- a.水源井完成采油厂费用+0 as 水源井完成采油厂费用,
		-- a.化学驱完成采油厂费用+0 as 化学驱完成采油厂费用,
		-- a.作业完成采油厂费用+0 as 作业完成采油厂费用,

		-- a.措施完成长效井井数+0 as 措施完成长效井井数, a.措施完成长效井费用+0 as 措施完成长效井费用,a.措施完成长效井采油厂费用+0 as 措施完成长效井采油厂费用,
		-- a.维护完成长效井井数+0 as 维护完成长效井井数, a.维护完成长效井费用+0 as 维护完成长效井费用,a.维护完成长效井采油厂费用+0 as 维护完成长效井采油厂费用,
		-- a.水井完成长效井井数+0 as 水井完成长效井井数, a.水井完成长效井费用+0 as 水井完成长效井费用,a.水井完成长效井采油厂费用+0 as 水井完成长效井采油厂费用,
		-- a.水源井完成长效井井数+0 as 水源井完成长效井井数, a.水源井完成长效井费用+0 as 水源井完成长效井费用,a.水源井完成长效井采油厂费用+0 as 水源井完成长效井采油厂费用,
		-- a.转注井完成长效井井数+0 as 转注井完成长效井井数, a.转注井完成长效井费用+0 as 转注井完成长效井费用,a.转注井完成长效井采油厂费用+0 as 转注井完成长效井采油厂费用,
		-- a.化学驱完成长效井井数+0 as 化学驱完成长效井井数, a.化学驱完成长效井费用+0 as 化学驱完成长效井费用,a.化学驱完成长效井采油厂费用+0 as 化学驱完成长效井采油厂费用
from [{{BZBM}}$] a;

$BZBM:采油厂成本0;采油厂成本:@作业成本效果评价数据格式;

-- 生成月度对比表
$BZBM:[海一成本$];
@作业成本效果评价月度:
select
	a.日期, a.单位,
	
	iif(a.措施计划井数 is null, 0, a.措施计划井数) - iif(b.措施计划井数 is null, 0, b.措施计划井数) as 措施计划月井数,
	a.措施计划井数,
	a.措施计划增油,
	iif(a.措施计划费用 is null, 0, a.措施计划费用) - iif(b.措施计划费用 is null, 0, b.措施计划费用) as 措施计划月费用,
	a.措施计划费用,
	iif(a.措施完成井数 is null, 0, a.措施完成井数) - iif(b.措施完成井数 is null, 0, b.措施完成井数) as 措施完成月井数,
	a.措施完成井数,
	a.措施完成增油,
	iif(a.措施完成费用 is null, 0, a.措施完成费用) - iif(b.措施完成费用 is null, 0, b.措施完成费用) as 措施完成月费用,
	a.措施完成费用,
	-- iif(a.措施完成长效井井数 is null, 0, a.措施完成长效井井数) - iif(b.措施完成长效井井数 is null, 0, b.措施完成长效井井数) as 措施完成长效井月井数,
	a.措施完成长效井井数, 
	a.措施完成长效井费用,
	a.措施完成长效井采油厂费用,
	a.措施完成采油厂费用,
	(
	 	(iif(a.措施完成井数 is null, 0, a.措施完成井数) - iif(b.措施完成井数 is null, 0, b.措施完成井数)) -
	 	(iif(a.措施计划井数 is null, 0, a.措施计划井数) - iif(b.措施计划井数 is null, 0, b.措施计划井数)) 
	 
	) as 措施月井数差值,
	iif(a.措施完成井数 is null, 0, a.措施完成井数) - iif(a.措施计划井数 is null, 0, a.措施计划井数) as 措施井数差值,
	iif(a.措施完成增油 is null, 0, a.措施完成增油) - iif(a.措施计划增油 is null, 0, a.措施计划增油) as 措施增油差值,
	iif(a.措施完成费用 is null, 0, a.措施完成费用) - iif(a.措施计划费用 is null, 0, a.措施计划费用) as 措施费用差值,


	iif(a.维护计划井数 is null, 0, a.维护计划井数) - iif(b.维护计划井数 is null, 0, b.维护计划井数) as 维护计划月井数,
	a.维护计划井数,
	a.维护计划增油,
	iif(a.维护计划费用 is null, 0, a.维护计划费用) - iif(b.维护计划费用 is null, 0, b.维护计划费用) as 维护计划月费用,
	a.维护计划费用,
	iif(a.维护完成井数 is null, 0, a.维护完成井数) - iif(b.维护完成井数 is null, 0, b.维护完成井数) as 维护完成月井数,
	a.维护完成井数,
	a.维护完成增油,
	iif(a.维护完成费用 is null, 0, a.维护完成费用) - iif(b.维护完成费用 is null, 0, b.维护完成费用) as 维护完成月费用,
	a.维护完成费用,
	-- iif(a.维护完成长效井井数 is null, 0, a.维护完成长效井井数) - iif(b.维护完成长效井井数 is null, 0, b.维护完成长效井井数) as 维护完成长效井月井数,
	a.维护完成长效井井数, 
	a.维护完成长效井费用,
	a.维护完成长效井采油厂费用,
	a.维护完成采油厂费用,
	(
		(iif(a.维护完成井数 is null, 0, a.维护完成井数) - iif(b.维护完成井数 is null, 0, b.维护完成井数)) -
	 	(iif(a.维护计划井数 is null, 0, a.维护计划井数) - iif(b.维护计划井数 is null, 0, b.维护计划井数)) 
	) as 维护月井数差值,
	iif(a.维护完成井数 is null, 0, a.维护完成井数) - iif(a.维护计划井数 is null, 0, a.维护计划井数) as 维护井数差值,
	iif(a.维护完成增油 is null, 0, a.维护完成增油) - iif(a.维护计划增油 is null, 0, a.维护计划增油) as 维护增油差值,
	iif(a.维护完成费用 is null, 0, a.维护完成费用) - iif(a.维护计划费用 is null, 0, a.维护计划费用) as 维护费用差值,


	iif(a.水井计划井数 is null, 0, a.水井计划井数) - iif(b.水井计划井数 is null, 0, b.水井计划井数) as 水井计划月井数,
	a.水井计划井数,
	iif(a.水井计划费用 is null, 0, a.水井计划费用) - iif(b.水井计划费用 is null, 0, b.水井计划费用) as 水井计划月费用,
	a.水井计划费用,
	iif(a.水井完成井数 is null, 0, a.水井完成井数) - iif(b.水井完成井数 is null, 0, b.水井完成井数) as 水井完成月井数,
	a.水井完成井数,
	iif(a.水井完成费用 is null, 0, a.水井完成费用) - iif(b.水井完成费用 is null, 0, b.水井完成费用) as 水井完成月费用,
	a.水井完成费用,
	-- iif(a.水井完成长效井井数 is null, 0, a.水井完成长效井井数) - iif(b.水井完成长效井井数 is null, 0, b.水井完成长效井井数) as 水井完成长效井月井数,
	a.水井完成长效井井数, 
	a.水井完成长效井费用,
	a.水井完成长效井采油厂费用,
	a.水井完成采油厂费用,
	(
		(iif(a.水井完成井数 is null, 0, a.水井完成井数) - iif(b.水井完成井数 is null, 0, b.水井完成井数)) -
	 	(iif(a.水井计划井数 is null, 0, a.水井计划井数) - iif(b.水井计划井数 is null, 0, b.水井计划井数))
	) as 水井月井数差值,
	iif(a.水井完成井数 is null, 0, a.水井完成井数) - iif(a.水井计划井数 is null, 0, a.水井计划井数) as 水井井数差值,
	iif(a.水井完成费用 is null, 0, a.水井完成费用) - iif(a.水井计划费用 is null, 0, a.水井计划费用) as 水井费用差值,

	-- 转注井维护
	iif(a.转注井计划井数 is null, 0, a.转注井计划井数) - iif(b.转注井计划井数 is null, 0, b.转注井计划井数) as 转注井计划月井数,
	a.转注井计划井数,
	iif(a.转注井计划费用 is null, 0, a.转注井计划费用) - iif(b.转注井计划费用 is null, 0, b.转注井计划费用) as 转注井计划月费用,
	a.转注井计划费用,
	iif(a.转注井完成井数 is null, 0, a.转注井完成井数) - iif(b.转注井完成井数 is null, 0, b.转注井完成井数) as 转注井完成月井数,
	a.转注井完成井数,
	iif(a.转注井完成费用 is null, 0, a.转注井完成费用) - iif(b.转注井完成费用 is null, 0, b.转注井完成费用) as 转注井完成月费用,
	a.转注井完成费用,
	-- iif(a.转注井完成长效井井数 is null, 0, a.转注井完成长效井井数) - iif(b.转注井完成长效井井数 is null, 0, b.转注井完成长效井井数) as 转注井完成长效井月井数,
	a.转注井完成长效井井数, 
	a.转注井完成长效井费用,
	a.转注井完成长效井采油厂费用,
	a.转注井完成采油厂费用,
	(
		(iif(a.转注井完成井数 is null, 0, a.转注井完成井数) - iif(b.转注井完成井数 is null, 0, b.转注井完成井数)) -
	 	(iif(a.转注井计划井数 is null, 0, a.转注井计划井数) - iif(b.转注井计划井数 is null, 0, b.转注井计划井数))
	) as 转注井月井数差值,
	iif(a.转注井完成井数 is null, 0, a.转注井完成井数) - iif(a.转注井计划井数 is null, 0, a.转注井计划井数) as 转注井井数差值,
	iif(a.转注井完成费用 is null, 0, a.转注井完成费用) - iif(a.转注井计划费用 is null, 0, a.转注井计划费用) as 转注井费用差值,

	-- 水源井维护
	iif(a.水源井计划井数 is null, 0, a.水源井计划井数) - iif(b.水源井计划井数 is null, 0, b.水源井计划井数) as 水源井计划月井数,
	a.水源井计划井数,
	iif(a.水源井计划费用 is null, 0, a.水源井计划费用) - iif(b.水源井计划费用 is null, 0, b.水源井计划费用) as 水源井计划月费用,
	a.水源井计划费用,
	iif(a.水源井完成井数 is null, 0, a.水源井完成井数) - iif(b.水源井完成井数 is null, 0, b.水源井完成井数) as 水源井完成月井数,
	a.水源井完成井数,
	iif(a.水源井完成费用 is null, 0, a.水源井完成费用) - iif(b.水源井完成费用 is null, 0, b.水源井完成费用) as 水源井完成月费用,
	a.水源井完成费用,
	-- iif(a.水源井完成长效井井数 is null, 0, a.水源井完成长效井井数) - iif(b.水源井完成长效井井数 is null, 0, b.水源井完成长效井井数) as 水源井完成长效井月井数,
	a.水源井完成长效井井数, 
	a.水源井完成长效井费用,
	a.水源井完成长效井采油厂费用,
	a.水源井完成采油厂费用,
	(
		(iif(a.水源井完成井数 is null, 0, a.水源井完成井数) - iif(b.水源井完成井数 is null, 0, b.水源井完成井数)) -
	  (iif(a.水源井计划井数 is null, 0, a.水源井计划井数) - iif(b.水源井计划井数 is null, 0, b.水源井计划井数))
	) as 水源井月井数差值,
	iif(a.水源井完成井数 is null, 0, a.水源井完成井数) - iif(a.水源井计划井数 is null, 0, a.水源井计划井数) as 水源井井数差值,
	iif(a.水源井完成费用 is null, 0, a.水源井完成费用) - iif(a.水源井计划费用 is null, 0, a.水源井计划费用) as 水源井费用差值,


	iif(a.计划作业总井数 is null, 0, a.计划作业总井数) - iif(b.计划作业总井数 is null, 0, b.计划作业总井数) as 计划作业月井数,
	a.计划作业总井数,
	a.计划作业增油,
	iif(a.计划作业总费用 is null, 0, a.计划作业总费用) - iif(b.计划作业总费用 is null, 0, b.计划作业总费用) as 计划作业月费用,
	a.计划作业总费用,

	iif(a.作业完成总井数 is null, 0, a.作业完成总井数) - iif(b.作业完成总井数 is null, 0, b.作业完成总井数) as 作业完成月井数,  -- 不包括化学驱
	a.作业完成总井数,
	a.作业增油,
	iif(a.作业完成总费用 is null, 0, a.作业完成总费用) - iif(b.作业完成总费用 is null, 0, b.作业完成总费用) as 作业完成月费用,
	a.作业完成总费用,

	iif(a.措施完成长效井井数 is null, 0, a.措施完成长效井井数) + iif(a.维护完成长效井井数 is null, 0, a.维护完成长效井井数) + iif(a.水井完成长效井井数 is null, 0, a.水井完成长效井井数) + -- 不包括化学驱
	iif(a.水源井完成长效井井数 is null, 0, a.水源井完成长效井井数) + iif(a.转注井完成长效井井数 is null, 0, a.转注井完成长效井井数)	-- + iif(a.化学驱完成长效井井数 is null, 0, a.化学驱完成长效井井数) 
	as 长效井井数,
	iif(a.措施完成长效井费用 is null, 0, a.措施完成长效井费用) + iif(a.维护完成长效井费用 is null, 0, a.维护完成长效井费用) + iif(a.水井完成长效井费用 is null, 0, a.水井完成长效井费用) + 
	iif(a.水源井完成长效井费用 is null, 0, a.水源井完成长效井费用) + iif(a.转注井完成长效井费用 is null, 0, a.转注井完成长效井费用) -- + iif(a.化学驱完成长效井费用 is null, 0, a.化学驱完成长效井费用) 
	as 长效井费用,
	iif(a.措施完成长效井采油厂费用 is null, 0, a.措施完成长效井采油厂费用) + iif(a.维护完成长效井采油厂费用 is null, 0, a.维护完成长效井采油厂费用) + iif(a.水井完成长效井采油厂费用 is null, 0, a.水井完成长效井采油厂费用) + 
	iif(a.水源井完成长效井采油厂费用 is null, 0, a.水源井完成长效井采油厂费用) + iif(a.转注井完成长效井采油厂费用 is null, 0, a.转注井完成长效井采油厂费用) -- + iif(a.化学驱完成长效井采油厂费用 is null, 0, a.化学驱完成长效井采油厂费用) 
	as 长效井采油厂费用,

	a.作业完成采油厂费用,

	(
		(iif(a.作业完成总井数 is null, 0, a.作业完成总井数) - iif(b.作业完成总井数 is null, 0, b.作业完成总井数)) -
		(iif(a.计划作业总井数 is null, 0, a.计划作业总井数) - iif(b.计划作业总井数 is null, 0, b.计划作业总井数))
	) as 作业月井数差值,
	iif(a.作业完成总井数 is null, 0, a.作业完成总井数) - iif(a.计划作业总井数 is null, 0, a.计划作业总井数) as 作业井数差值,
	iif(a.作业增油 is null, 0, a.作业增油) - iif(a.计划作业增油 is null, 0, a.计划作业增油) as 作业增油差值,
	iif(a.作业完成总费用 is null, 0, a.作业完成总费用) - iif(a.计划作业总费用 is null, 0, a.计划作业总费用) as 作业费用差值

from
(
	select
		a.日期, a.单位,
		a.措施计划井数+0 as 措施计划井数, a.措施计划增油+0 as 措施计划增油, a.措施计划费用+0 as 措施计划费用,
		a.维护计划井数+0 as 维护计划井数, a.维护计划增油+0 as 维护计划增油, a.维护计划费用+0 as 维护计划费用,
		a.水井计划井数+0 as 水井计划井数, a.水井计划费用+0 as 水井计划费用,
		a.转注井计划井数+0 as 转注井计划井数, a.转注井计划费用+0 as 转注井计划费用,
		a.水源井计划井数+0 as 水源井计划井数, a.水源井计划费用+0 as 水源井计划费用,
		a.计划作业总井数+0 as 计划作业总井数, a.计划作业增油+0 as 计划作业增油, a.计划作业总费用+0 as 计划作业总费用,
		a.措施完成井数+0 as 措施完成井数, a.措施完成增油+0 as 措施完成增油, a.措施完成费用+0 as 措施完成费用, a.措施完成采油厂费用+0 as 措施完成采油厂费用,
		a.维护完成井数+0 as 维护完成井数, a.维护完成增油+0 as 维护完成增油, a.维护完成费用+0 as 维护完成费用, a.维护完成采油厂费用+0 as 维护完成采油厂费用,
		a.水井完成井数+0 as 水井完成井数, a.水井完成费用+0 as 水井完成费用, a.水井完成采油厂费用+0 as 水井完成采油厂费用,
		a.转注井完成井数+0 as 转注井完成井数, a.转注井完成费用+0 as 转注井完成费用, a.转注井完成采油厂费用+0 as 转注井完成采油厂费用,
		a.水源井完成井数+0 as 水源井完成井数, a.水源井完成费用+0 as 水源井完成费用, a.水源井完成采油厂费用+0 as 水源井完成采油厂费用,
		a.作业完成总井数+0 as 作业完成总井数, a.作业增油+0 as 作业增油, a.作业完成总费用+0 as 作业完成总费用, a.作业完成采油厂费用+0 as 作业完成采油厂费用,
		-- a.阶段躺井率,
		-- a.计划躺井率,

		a.化学驱完成井数+0 as 化学驱完成井数, a.化学驱完成费用+0 as 化学驱完成费用, a.化学驱完成采油厂费用+0 as 化学驱完成采油厂费用,

		a.措施完成长效井井数+0 as 措施完成长效井井数, a.措施完成长效井费用+0 as 措施完成长效井费用,a.措施完成长效井采油厂费用+0 as 措施完成长效井采油厂费用,
		a.维护完成长效井井数+0 as 维护完成长效井井数, a.维护完成长效井费用+0 as 维护完成长效井费用,a.维护完成长效井采油厂费用+0 as 维护完成长效井采油厂费用,
		a.水井完成长效井井数+0 as 水井完成长效井井数, a.水井完成长效井费用+0 as 水井完成长效井费用,a.水井完成长效井采油厂费用+0 as 水井完成长效井采油厂费用,
		a.水源井完成长效井井数+0 as 水源井完成长效井井数, a.水源井完成长效井费用+0 as 水源井完成长效井费用,a.水源井完成长效井采油厂费用+0 as 水源井完成长效井采油厂费用,
		a.转注井完成长效井井数+0 as 转注井完成长效井井数, a.转注井完成长效井费用+0 as 转注井完成长效井费用,a.转注井完成长效井采油厂费用+0 as 转注井完成长效井采油厂费用,
		a.化学驱完成长效井井数+0 as 化学驱完成长效井井数, a.化学驱完成长效井费用+0 as 化学驱完成长效井费用,a.化学驱完成长效井采油厂费用+0 as 化学驱完成长效井采油厂费用
	from {{BZBM}} a,
										(
											select 
												max(a.日期) as 日期
											from {{BZBM}} a
											group by year(a.日期)*100 + month(a.日期)
										) b
	where a.日期 = b.日期
) a left join 
							(
								select
									a.日期, a.单位,
									a.措施计划井数+0 as 措施计划井数, a.措施计划增油+0 as 措施计划增油, a.措施计划费用+0 as 措施计划费用,
									a.维护计划井数+0 as 维护计划井数, a.维护计划增油+0 as 维护计划增油, a.维护计划费用+0 as 维护计划费用,
									a.水井计划井数+0 as 水井计划井数, a.水井计划费用+0 as 水井计划费用,
									a.转注井计划井数+0 as 转注井计划井数, a.转注井计划费用+0 as 转注井计划费用,
									a.水源井计划井数+0 as 水源井计划井数, a.水源井计划费用+0 as 水源井计划费用,
									a.计划作业总井数+0 as 计划作业总井数, a.计划作业增油+0 as 计划作业增油, a.计划作业总费用+0 as 计划作业总费用,
									a.措施完成井数+0 as 措施完成井数, a.措施完成增油+0 as 措施完成增油, a.措施完成费用+0 as 措施完成费用, a.措施完成采油厂费用+0 as 措施完成采油厂费用,
									a.维护完成井数+0 as 维护完成井数, a.维护完成增油+0 as 维护完成增油, a.维护完成费用+0 as 维护完成费用, a.维护完成采油厂费用+0 as 维护完成采油厂费用,
									a.水井完成井数+0 as 水井完成井数, a.水井完成费用+0 as 水井完成费用, a.水井完成采油厂费用+0 as 水井完成采油厂费用,
									a.转注井完成井数+0 as 转注井完成井数, a.转注井完成费用+0 as 转注井完成费用, a.转注井完成采油厂费用+0 as 转注井完成采油厂费用,
									a.水源井完成井数+0 as 水源井完成井数, a.水源井完成费用+0 as 水源井完成费用, a.水源井完成采油厂费用+0 as 水源井完成采油厂费用,
									a.作业完成总井数+0 as 作业完成总井数, a.作业增油+0 as 作业增油, a.作业完成总费用+0 as 作业完成总费用, a.作业完成采油厂费用+0 as 作业完成采油厂费用,
									-- a.阶段躺井率,
									-- a.计划躺井率,

									a.化学驱完成井数+0 as 化学驱完成井数, a.化学驱完成费用+0 as 化学驱完成费用, a.化学驱完成采油厂费用+0 as 化学驱完成采油厂费用,

									a.措施完成长效井井数+0 as 措施完成长效井井数, a.措施完成长效井费用+0 as 措施完成长效井费用,a.措施完成长效井采油厂费用+0 as 措施完成长效井采油厂费用,
									a.维护完成长效井井数+0 as 维护完成长效井井数, a.维护完成长效井费用+0 as 维护完成长效井费用,a.维护完成长效井采油厂费用+0 as 维护完成长效井采油厂费用,
									a.水井完成长效井井数+0 as 水井完成长效井井数, a.水井完成长效井费用+0 as 水井完成长效井费用,a.水井完成长效井采油厂费用+0 as 水井完成长效井采油厂费用,
									a.水源井完成长效井井数+0 as 水源井完成长效井井数, a.水源井完成长效井费用+0 as 水源井完成长效井费用,a.水源井完成长效井采油厂费用+0 as 水源井完成长效井采油厂费用,
									a.转注井完成长效井井数+0 as 转注井完成长效井井数, a.转注井完成长效井费用+0 as 转注井完成长效井费用,a.转注井完成长效井采油厂费用+0 as 转注井完成长效井采油厂费用,
									a.化学驱完成长效井井数+0 as 化学驱完成长效井井数, a.化学驱完成长效井费用+0 as 化学驱完成长效井费用,a.化学驱完成长效井采油厂费用+0 as 化学驱完成长效井采油厂费用
								from {{BZBM}} a,
																	(
																		select 
																			max(a.日期) as 日期
																		from {{BZBM}} a
																		group by year(a.日期)*100 + month(a.日期)
																	) b
								where a.日期 = b.日期
							) b
on year(a.日期)*100 + month(a.日期) = year(b.日期)*100 + month(b.日期) + 1;


















------------------ 区块 效益产量跟踪分析 需要额外补充的内容
$YSMC:区块起步产量;
区块起步产量汇总:
select 
	b.类型,
	b.细分类型,
	b.考核单元,
	'' as 单位,
	'' as 井号,
	a.日期,
	(b.日油*b.天自然递减^(a.日期-b.起始时间))/(1-(b.含水+b.天含水上升*(a.日期-b.起始时间))/100) as 日液, 
	b.日油*b.天自然递减^(a.日期-b.起始时间) as 日油,
	b.含水+b.天含水上升*(a.日期-b.起始时间) as 含水
from [时间序列$] a, (select 
											类型,
											细分类型,
											考核单元,
											起始时间,
											日液,
											日油,
											含水,
											自然递减,
											含水上升,
											0.005592*log(1-自然递减/100)+1 as 天自然递减, 
											含水上升/365 as 天含水上升
										from [{{YSMC}}$]) b
where a.日期 >= b.起始时间
order by b.考核单元,a.日期;



-- @区块汇总结果:
-- select
-- 	a.类型,
-- 	a.细分类型,
-- 	a.单位,
-- 	a.井号,
-- 	a.日期,
-- 	a.日液,
-- 	a.日油,
-- 	a.含水,
-- 	b.考核单元
-- from [{{HZBM}}$] a left join [井号考核单元$] b
-- on a.井号 = b.井号;

-- $HZBM:措施安排汇总;      区块措施安排汇总:@区块汇总结果;  
-- $HZBM:新井安排汇总;      区块新井安排汇总:@区块汇总结果;
-- $HZBM:转注安排汇总;      区块转注安排汇总:@区块汇总结果; 
-- $HZBM:实际措施汇总;      区块实际措施汇总:@区块汇总结果;
-- $HZBM:实际新井汇总修正后;区块实际新井汇总:@区块汇总结果; 
-- $HZBM:实际关井汇总;      区块实际关井汇总:@区块汇总结果;  
-- $HZBM:计划外开井汇总;    区块计划外开井汇总:@区块汇总结果;




区块计划因素汇总:
select * from [区块起步产量汇总$] 
union all
select * from [措施安排汇总$] 
union all
select * from [新井安排汇总$] 
union all
select * from [转注安排汇总$];


区块预计因素汇总:
select * from [区块起步产量汇总$] 
union all
select * from [实际措施汇总$] 
union all
select * from [实际新井汇总$]
union all
select * from [实际关井汇总$]
union all
select * from [计划外开井汇总$];


@区块因素汇总统计:
select 
a.考核单元,
cdate(a.日期) as 日期,
count(a.井号) as 井数,
round(sum(a.日液),0) as 日液,
round(sum(a.日油),0) as 日油,
round(100*(sum(a.日液)-sum(a.日油))/sum(a.日液),1) as 含水
from [{{BZBM}}$] a 
group by a.日期,a.考核单元;

$BZBM:区块起步产量汇总;  区块起步产量统计:@区块因素汇总统计;
$BZBM:措施安排汇总;  区块措施安排统计:@区块因素汇总统计;
$BZBM:新井安排汇总;  区块新井安排统计:@区块因素汇总统计;
$BZBM:转注安排汇总;  区块转注安排统计:@区块因素汇总统计;
$BZBM:实际措施汇总;  区块实际措施统计:@区块因素汇总统计;
$BZBM:实际新井汇总;  区块实际新井统计:@区块因素汇总统计;
$BZBM:实际关井汇总;  区块实际关井统计:@区块因素汇总统计;
$BZBM:计划外开井汇总;区块计划外开井统计:@区块因素汇总统计;

$BZBM:区块计划因素汇总;区块计划因素汇总统计:@区块因素汇总统计;
$BZBM:区块预计因素汇总;区块预计因素汇总统计:@区块因素汇总统计;





@区块因素汇总统计作业成本:
select 
a.考核单元,
cdate(a.日期) as 日期,
count(a.井号) as 井数,
str(round(sum(a.增油),0)) as 增油,
round(sum(a.作业费用),0) as 作业费用
from {{BZBM}} a 
group by a.日期,a.考核单元
order by a.考核单元,a.日期 asc;

$BZBM:[计划措施费用汇总$];  区块计划措施费用统计:@区块因素汇总统计作业成本;
$BZBM:[计划维护费用汇总$];  区块计划维护费用统计:@区块因素汇总统计作业成本;
$BZBM:[计划水井费用汇总$];  区块计划水井费用统计:@区块因素汇总统计作业成本;
$BZBM:[计划转注井费用汇总$];区块计划转注井费用统计:@区块因素汇总统计作业成本;
$BZBM:[计划水源井费用汇总$];区块计划水源井费用统计:@区块因素汇总统计作业成本;

$BZBM:[实际措施费用汇总$];  区块实际措施费用统计:@区块因素汇总统计作业成本;
$BZBM:[实际维护费用汇总$];  区块实际维护费用统计:@区块因素汇总统计作业成本;
$BZBM:[实际水井费用汇总$];  区块实际水井费用统计:@区块因素汇总统计作业成本;
$BZBM:[实际转注井费用汇总$];区块实际转注井费用统计:@区块因素汇总统计作业成本;
$BZBM:[实际水源井费用汇总$];区块实际水源井费用统计:@区块因素汇总统计作业成本;
$BZBM:[实际化学驱费用汇总$];区块实际化学驱费用统计:@区块因素汇总统计作业成本;

$BZBM:(select * from [计划措施费用汇总$] union all select * from [计划维护费用汇总$] union all select * from [计划水井费用汇总$] union all select * from [计划转注井费用汇总$] union all select * from [计划水源井费用汇总$]);
区块计划作业费用统计:@区块因素汇总统计作业成本;
$BZBM:(select * from [实际措施费用汇总$] union all select * from [实际维护费用汇总$] union all select * from [实际水井费用汇总$] union all select * from [实际转注井费用汇总$] union all select * from [实际水源井费用汇总$]);
区块实际作业费用统计:@区块因素汇总统计作业成本;


$QSSJ:'20200101';
$JSSJ:'20201231';
区块集输单元日分析:
select 
	考核单元,
	日期,
	count(井号) as 总井数,
	sum(是否开井) as 开井数,
	
	round(sum(日油),0) as 井口日油,
	round(sum(日液),0) as 井口日液,

	sum(单井盘库日油) as 盘库日油,
	sum(单井外输日油) as 外输日油,
	sum(单井外输日液) as 外输日液 

from 
	(
		select
			a.井号,	
			a.是否开井,
			a.单位,
			a.日期,	
			a.日液,
			a.日油,
			a.含水,
			a.考核单元,
			a.新集输方式,

			a.集输单元井口日液,
			a.集输单元井口日油,

			b.外输日液 as 集输单元外输日液,
			b.外输日油 as 集输单元外输日油,
			b.盘库日油 as 集输单元盘库日油,

			round(b.盘库日油*a.日油/a.集输单元井口日油,0) as 单井盘库日油,
			round(b.外输日油*a.日油/a.集输单元井口日油,0) as 单井外输日油, 
			round(b.外输日液*a.日液/a.集输单元井口日液,0) as 单井外输日液

		from
			(
			select 
				a.井号,	
				a.是否开井,
				a.单位,
				a.日期,	
				a.日液,
				a.日油,
				a.含水,
				b.考核单元,
				b.新集输方式,

				round(sum(a.日液) OVER(PARTITION BY a.日期,b.新集输方式),1) as 集输单元井口日液,
				round(sum(a.日油) OVER(PARTITION BY a.日期,b.新集输方式),1) as 集输单元井口日油
			from 
				(select
					A.JH as 井号,
					CASE WHEN (A.scsj is null or A.scsj=0) THEN null ELSE 1 END  as 是否开井, 
					DECODE(A.DWDM,30205480,'海一',30205483,'海一',
							    30205482,'海一',30205484,'海一',
							    30205485,'海一',30205493,'海二',
							    30205495,'海二',30205496,'海二',
							    30205497,'海二',30205498,'海二',
							    30205506,'海三',30205507,'海三',
							    30205508,'海三',30205509,'海三',
							    30205510,'海三',30205517,'海四',
							    30205519,'海四',30205520,'海四',
							    30205521,'海四',30205522,'海四',
							    30205523,'海四',30205524,'海四','不详') AS 单位,
					A.rq as 日期,
					A.RCYL1 as 日液,
					round(A.rcyl1*(1-A.HS/100),1) as 日油,
					A.HS as 含水
				from HYYDNEW.YD_DBA01 a left join KFSJGL.GZ_KF_DBA01XZ b
				on a.JH = b.JH and a.rq = b.rq
				where to_char(A.rq,'yyyymmdd')>={{QSSJ}}
				and to_char(A.rq,'yyyymmdd')<={{JSSJ}}
				and b.JH is null
									union 	
											select 
												A.JH as 井号,
												CASE WHEN (A.scsj is null or A.scsj=0) THEN null ELSE 1 END  as 是否开井, 
												DECODE(A.DWDM,30205480,'海一',30205483,'海一',
														    30205482,'海一',30205484,'海一',
														    30205485,'海一',30205493,'海二',
														    30205495,'海二',30205496,'海二',
														    30205497,'海二',30205498,'海二',
														    30205506,'海三',30205507,'海三',
														    30205508,'海三',30205509,'海三',
														    30205510,'海三',30205517,'海四',
														    30205519,'海四',30205520,'海四',
														    30205521,'海四',30205522,'海四',
														    30205523,'海四',30205524,'海四','不详') AS 单位,
												A.rq as 日期,
												A.RCYL1 as 日液,
												A.rcyl1*(1-A.HS/100) as 日油,
												A.HS as 含水
											from KFSJGL.GZ_KF_DBA01XZ A 
											where to_char(rq,'yyyymmdd')>={{QSSJ}}
											and to_char(A.rq,'yyyymmdd')<={{JSSJ}}
				) a left join (select JH as 井号,KHDY as 考核单元,XJSFS as 新集输方式 from KFSJGL.GZ_KF_DYDM) b on a.井号 = b.井号
			) a
				left join (
							Select 
							a.WSDY AS 外输单元,
							a.RQ AS 日期,
							a.ZJS AS 总井数,
							a.KJS AS 开井数,
							a.WSRY AS 外输日液,
							a.WSRU AS 外输日油, 
							a.WSHS AS 外输含水,
							ROUND(a.WSRU/0.9825) AS 盘库日油,
							ROUND(a.WSRU/0.9825/(1-a.JKHS/100)) AS 反算日液,
							a.JKRY AS 井口日液,
							a.JKRU AS 井口日油,
							a.JKHS AS 井口含水,
							a.RYCZ AS 日液差值,
							a.RUCZ AS 日油差值,
							a.HSCZ AS 含水差值   
							From HYYTSJ.YS_HY_JSDYRFX a   
							WHERE  to_char(a.RQ,'yyyymmdd') >= {{QSSJ}}
							and to_char(a.RQ,'yyyymmdd') <= {{JSSJ}}
							ORDER BY a.WSDY,a.RQ
						  ) b on a.新集输方式 = b.外输单元 and a.日期 = b.日期
	) 
group by 考核单元,日期
order by 考核单元,日期;


-- $QSSJ:'20200101';$FJZD:考核单元,;区块井口日油:@井口日油计算考虑未上报表新井;
-- $QSSJ:'20200101';$FJZD:         ;采油厂井口日油:@井口日油计算考虑未上报表新井;

-- 区块集输单元日分析:
-- select
-- 	a.考核单元,
-- 	a.日期,
-- 	a.总井数,
-- 	a.开井数,
-- 	a.区块井口日油 as 井口日油,
-- 	a.区块井口日液 as 井口日液,
-- 	a.采油厂井口日油,
-- 	a.采油厂井口日液,

-- 	round(b.采油厂外输日液*a.区块井口日液/a.采油厂井口日液,0) as 外输日液,
-- 	round(b.采油厂外输日油*a.区块井口日油/a.采油厂井口日油,0) as 外输日油,

-- 	-- b.采油厂盘库日油,
-- 	round(b.采油厂盘库日油*a.区块井口日油/a.采油厂井口日油) as 盘库日油
	
-- from
-- 	(select 
-- 		a.考核单元,
-- 		a.日期, 
-- 		a.总井数,
-- 		a.开井数,
-- 		a.日油 as 区块井口日油,
-- 		a.日液 as 区块井口日液,
-- 		b.日油 as 采油厂井口日油,
-- 		b.日液 as 采油厂井口日液
-- 	from [区块井口日油$] a 
-- 	left join [采油厂井口日油$] b 
-- 	on a.日期 = b.日期) a
-- left join 
-- 	(select
-- 		日期,
-- 		-- 外输单元,
-- 		-- 井口日油 as 采油厂井口日油,
-- 		外输日液 as 采油厂外输日液,
-- 		外输日油 as 采油厂外输日油,
-- 		盘库日油 as 采油厂盘库日油
-- 	from [集输单元日分析$] 
-- 	where 外输单元 = '全厂'
-- 	) b
-- on a.日期 = b.日期;

-- 生成对比分析表
$KHDY:中一区;
$KHDYJH:('中一区','中二区','中三区','北区','东区','南区','西北区','西北新区','东斜坡','断块','潜山','新北油田');
区块阶段分析表:
select 
'{{KHDY}}' as 考核单元, 
日期 as 日期, 
sum(总井数) as 总井数, sum(开井数) as 开井数, 
round(sum(井口日液),0) as 井口日液, 
round(sum(井口日油),0) as 井口日油,
iif(sum(井口日液)=0,0,round(100*(sum(井口日液)-sum(井口日油))/sum(井口日液),1)) as 井口含水,
sum(外输日液) as 外输日液, 
sum(外输日油) as 外输日油,
iif(sum(外输日液)=0,0,round(100*(sum(外输日液)-sum(盘库日油))/sum(外输日液),1)) as 外输含水,
sum(盘库日油) as 盘库日油,
sum(计划日液) as 计划日液,
sum(计划日油) as 计划日油,
round(100-100*sum(计划日油)/sum(计划日液),1) as 计划含水,
sum(总井数)-sum(总井数) + sum(预计日液) as 预计日液,
sum(总井数)-sum(总井数) + sum(预计日油) as 预计日油,
sum(总井数)-sum(总井数) + round(100-100*sum(预计日油)/sum(预计日液),1) as 预计含水,
sum(计划措施日液) as 计划措施日液, sum(计划措施日油) as 计划措施日油, round(100-100*sum(计划措施日油)/sum(计划措施日液),1) as 计划措施含水, sum(计划措施井数) as 计划措施井数,
sum(计划新井日液) as 计划新井日液, sum(计划新井日油) as 计划新井日油, round(100-100*sum(计划新井日油)/sum(计划新井日液),1) as 计划新井含水, sum(计划新井井数) as 计划新井井数,
sum(实际措施日液) as 实际措施日液, sum(实际措施日油) as 实际措施日油, round(100-100*sum(实际措施日油)/sum(实际措施日液),1) as 实际措施含水, sum(实际措施井数) as 实际措施井数,
sum(实际新井日液) as 实际新井日液, sum(实际新井日油) as 实际新井日油, round(100-100*sum(实际新井日油)/sum(实际新井日液),1) as 实际新井含水, sum(实际新井井数) as 实际新井井数,
-1*sum(实际关井日液) as 实际关井日液, -1*sum(实际关井日油) as 实际关井日油, round(100-100*sum(实际关井日油)/sum(实际关井日液),1) as 实际关井含水, sum(实际关井井数) as 实际关井井数,
sum(起步产量日液)+sum(iif(计划措施日液 is not null,计划措施日液,0)) as 计划老井日液, 
sum(起步产量日油)+sum(iif(计划措施日油 is not null,计划措施日油,0)) as 计划老井日油, 
round(100-100*(sum(起步产量日油)+sum(iif(计划措施日油 is not null,计划措施日油,0)))/(sum(起步产量日液)+sum(iif(计划措施日液 is not null,计划措施日液,0))),1) as 计划老井含水,
sum(起步产量日液) as 计划自然日液, 
sum(起步产量日油) as 计划自然日油, 
round(100-100*sum(起步产量日油)/sum(起步产量日液),1) as 计划自然含水,
sum(外输日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(计划外开井日液 is not null,计划外开井日液,0)) as 实际老井日液, 
sum(盘库日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(计划外开井日油 is not null,计划外开井日油,0)) as 实际老井日油, 
round(100-100*(sum(井口日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(计划外开井日油 is not null,计划外开井日油,0)))/(sum(井口日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(计划外开井日液 is not null,计划外开井日液,0))),1) as 实际老井含水,
sum(外输日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(实际措施日液 is not null,实际措施日液,0))-sum(iif(计划外开井日液 is not null,计划外开井日液,0)) as 实际自然日液, 
sum(盘库日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(实际措施日油 is not null,实际措施日油,0))-sum(iif(计划外开井日油 is not null,计划外开井日油,0)) as 实际自然日油, 
round(100-100*(sum(井口日油)-sum(iif(实际新井日油 is not null,实际新井日油,0))-sum(iif(实际措施日油 is not null,实际措施日油,0))-sum(iif(计划外开井日油 is not null,计划外开井日油,0)))/(sum(井口日液)-sum(iif(实际新井日液 is not null,实际新井日液,0))-sum(iif(实际措施日液 is not null,实际措施日液,0))-sum(iif(计划外开井日液 is not null,计划外开井日液,0))),1) as 实际自然含水,
round(sum(井口日液)/sum(开井数),0) as 井口单井日液, 
round(sum(外输日液)/sum(开井数),0) as 外输单井日液,
sum(总井数)-sum(总井数) + sum(预计日液) - sum(iif(实际关井日液 is not null,实际关井日液,0)) as 预计日液不考虑关井,
sum(总井数)-sum(总井数) + sum(预计日油) - sum(iif(实际关井日油 is not null,实际关井日油,0)) as 预计日油不考虑关井,
sum(总井数)-sum(总井数) + round(100-100*(sum(预计日油) - sum(iif(实际关井日油 is not null,实际关井日油,0)))/(sum(预计日液) - sum(iif(实际关井日液 is not null,实际关井日液,0))),1) as 预计含水不考虑关井,
sum(计划外开井日液) as 计划外开井日液, sum(计划外开井日油) as 计划外开井日油, round(100-100*sum(计划外开井日油)/sum(计划外开井日液),1) as 计划外开井含水, sum(计划外开井井数) as 计划外开井井数
from (
	select a.考核单元,a.日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,计划措施日液,计划措施日油,计划措施含水,计划措施井数,计划新井日液, 计划新井日油, 计划新井含水,计划新井井数,实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,实际新井日液, 实际新井日油, 实际新井含水, 实际新井井数,实际关井日液, 实际关井日油, 实际关井含水, 实际关井井数,计划外开井日液, 计划外开井日油, 计划外开井含水, 计划外开井井数,起步产量日液, 起步产量日油, 起步产量含水,
	h.总井数 as 总井数, h.开井数 as 开井数,h.井口日液 as 井口日液, h.井口日油 as 井口日油,h.外输日液 as 外输日液, h.外输日油 as 外输日油,	h.盘库日油 as 盘库日油
	from ( 
		select a.考核单元,a.日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,实际新井日液, 实际新井日油, 实际新井含水, 实际新井井数,实际关井日液, 实际关井日油, 实际关井含水, 实际关井井数,计划外开井日液, 计划外开井日油, 计划外开井含水, 计划外开井井数,
		g.日液 as 起步产量日液, g.日油 as 起步产量日油, g.含水 as 起步产量含水
		from ( 
			select a.考核单元,a.日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,实际新井日液, 实际新井日油, 实际新井含水, 实际新井井数,实际关井日液, 实际关井日油, 实际关井含水, 实际关井井数,
			f3.日液 as 计划外开井日液, f3.日油 as 计划外开井日油, f3.含水 as 计划外开井含水, f3.井数 as 计划外开井井数
			from ( 
				select a.考核单元,a.日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,实际新井日液, 实际新井日油, 实际新井含水, 实际新井井数,
				f2.日液 as 实际关井日液, f2.日油 as 实际关井日油, f2.含水 as 实际关井含水, f2.井数 as 实际关井井数 
				from (
					select a.考核单元,a.日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,实际措施日液, 实际措施日油, 实际措施含水, 实际措施井数,
					f.日液 as 实际新井日液, f.日油 as 实际新井日油, f.含水 as 实际新井含水, f.井数 as 实际新井井数 
					from (
						select a.考核单元,a.日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,计划新井日液, 计划新井日油, 计划新井含水, 计划新井井数,
						e.日液 as 实际措施日液, e.日油 as 实际措施日油, e.含水 as 实际措施含水, e.井数 as 实际措施井数 
						from (
							select a.考核单元,a.日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,计划措施日液, 计划措施日油, 计划措施含水, 计划措施井数,
							d.日液 as 计划新井日液, d.日油 as 计划新井日油, d.含水 as 计划新井含水, d.井数 as 计划新井井数 
							from (
								select a.考核单元,a.日期,计划日液,计划日油,计划含水,预计日液,预计日油,预计含水,
								c.日液 as 计划措施日液, c.日油 as 计划措施日油, c.含水 as 计划措施含水, c.井数 as 计划措施井数 
								from (
									select a.考核单元, cdate(a.日期) as 日期, a.日液 as 计划日液, a.日油 as 计划日油, a.含水 as 计划含水,	
																														b.日液 as 预计日液, b.日油 as 预计日油, b.含水 as 预计含水
									from [区块计划因素汇总统计$] a, [区块预计因素汇总统计$] b  
									where a.考核单元 = b.考核单元 and a.日期 = b.日期 
								  and a.考核单元 in {{KHDYJH}}
								) a left join [区块措施安排统计$] c on a.考核单元 = c.考核单元 and cdate(a.日期) = c.日期
							) a left join [区块新井安排统计$] d on a.考核单元 = d.考核单元 and cdate(a.日期) = d.日期
						) a left join [区块实际措施统计$] e on a.考核单元 = e.考核单元 and cdate(a.日期) = cdate(e.日期)
					) a left join [区块实际新井统计$] f on a.考核单元 = f.考核单元 and cdate(a.日期) = cdate(f.日期)
				) a left join [区块实际关井统计$] f2 on a.考核单元 = f2.考核单元 and cdate(a.日期) = cdate(f2.日期)
			) a left join [区块计划外开井统计$] f3 on a.考核单元 = f3.考核单元 and cdate(a.日期) = cdate(f3.日期)
		) a left join [区块起步产量统计$] g on a.考核单元 = g.考核单元 and cdate(a.日期) = g.日期
	) a left join [区块集输单元日分析$] h on a.考核单元 = h.考核单元 and cdate(a.日期) = h.日期
) a
group by 日期
order by 日期 asc;






-- 区块躺井率0:
-- select
-- 	a.考核单元,
-- 	a.日期,
-- 	a.开井数
-- from [区块集输单元日分析$] a, (
-- 														select 
-- 															max(a.日期) as 日期
-- 														from [区块集输单元日分析$] a
-- 														group by year(a.日期)*100 + month(a.日期)
-- 													) b
-- where a.日期 = b.日期;

-- 区块躺井率1:
-- select
-- 	a.考核单元, a.日期, sum(b.开井数) as 开井数
-- from [区块躺井率0$] a, [区块躺井率0$] b 
-- where a.考核单元 = b.考核单元
-- and a.日期 >= b.日期 
-- group by a.考核单元, a.日期;

-- 区块躺井率:
-- select
-- 	a.日期,
-- 	a.考核单元 as 考核单元,
-- 	iif(b.躺井数 is null, 0, b.躺井数) as 躺井数,
-- 	a.开井数
-- 	-- round(b.躺井数/a.总井数*100,2) as 躺井率
-- from (
-- 				select
-- 					a.日期, 
-- 					a.考核单元, 
-- 					b.开井数
-- 				from [区块集输单元日分析$] a left join [区块躺井率1$] b
-- 				on a.考核单元 = b.考核单元
-- 				and year(a.日期)*100 + month(a.日期) = year(b.日期)*100 + month(b.日期)
-- 			) a left join (
-- 											select
-- 									 			a.日期,
-- 									 			a.考核单元,
-- 									 			count(a.井号) as 躺井数
-- 									 		from
-- 									 			(
-- 									 				select
-- 									 					a.日期,
-- 									 					b.考核单元,
-- 									 					b.井号
-- 									 				from [时间序列$] a, (
-- 									 														select 
-- 									 															a.井号, a.关躺井日期, b.考核单元
-- 									 														from [关躺井历史数据$] a left join [井号考核单元$] b
-- 									 														on a.井号 = b.井号
-- 									 														) b 
-- 									 				where a.日期 >= b.关躺井日期
-- 									 			) a
-- 									 			group by a.考核单元,a.日期
-- 									 	) b
-- on a.日期 = cdate(b.日期) 
-- and a.考核单元 = b.考核单元;


-- $KHDY:'中一区';
-- $KHDYJH:('中一区','中二区','中三区','北区','东区','南区','西北区','西北新区','东斜坡','断块','潜山','新北油田');
-- @区块作业成本效果评价:
-- select
-- 	a.日期, {{KHDY}} as 考核单元,
-- 	sum(a.措施计划井数) as 措施计划井数, sum(a.措施计划增油) as 措施计划增油, sum(a.措施计划费用) as 措施计划费用,
-- 	sum(a.维护计划井数) as 维护计划井数, sum(a.维护计划增油) as 维护计划增油, sum(a.维护计划费用) as 维护计划费用,
-- 	sum(a.水井计划井数) as 水井计划井数, sum(a.水井计划费用) as 水井计划费用,
-- 	sum(a.转注井计划井数) as 转注井计划井数, sum(a.转注井计划费用) as 转注井计划费用,
-- 	sum(a.水源井计划井数) as 水源井计划井数, sum(a.水源井计划费用) as 水源井计划费用,
-- 	sum(a.计划作业总井数) as 计划作业总井数, sum(a.计划作业增油) as 计划作业增油, sum(a.计划作业总费用) as 计划作业总费用,
-- 	sum(a.措施完成井数) as 措施完成井数, sum(a.措施完成增油) as 措施完成增油, sum(a.措施完成费用) as 措施完成费用,
-- 	sum(a.维护完成井数) as 维护完成井数, sum(a.维护完成增油) as 维护完成增油, sum(a.维护完成费用) as 维护完成费用,
-- 	sum(a.水井完成井数) as 水井完成井数, sum(a.水井完成费用) as 水井完成费用,
-- 	sum(a.转注井完成井数) as 转注井完成井数, sum(a.转注井完成费用) as 转注井完成费用,
-- 	sum(a.水源井完成井数) as 水源井完成井数, sum(a.水源井完成费用) as 水源井完成费用,
-- 	sum(a.作业完成总井数) as 作业完成总井数, sum(a.作业增油) as 作业增油, sum(a.作业完成总费用) as 作业完成总费用,
-- 	round(sum(a.躺井数)/sum(a.开井数)*100,2) as 阶段躺井率,
-- 	0.5 as 计划躺井率,

-- 	sum(a.化学驱完成井数) as 化学驱完成井数, sum(a.化学驱完成费用) as 化学驱完成费用
-- from
-- 	(select a.日期, a.考核单元, a.躺井数, a.开井数,	a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用,	a.水井完成井数, a.水井完成费用,	a.转注井完成井数, a.转注井完成费用,	a.水源井完成井数, a.水源井完成费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, a.作业完成总井数, a.作业增油, a.作业完成总费用,
-- 		b.井数 as 化学驱完成井数, b.作业费用 as 化学驱完成费用
-- 		from
-- 		(select a.日期, a.考核单元, a.躺井数, a.开井数,	a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用,	a.水井完成井数, a.水井完成费用,	a.转注井完成井数, a.转注井完成费用,	a.水源井完成井数, a.水源井完成费用, a.计划作业总井数, a.计划作业增油, a.计划作业总费用, 
-- 			b.井数 as 作业完成总井数, b.增油 as 作业增油, b.作业费用 as 作业完成总费用 
-- 			from
-- 			(select a.日期, a.考核单元, a.躺井数, a.开井数,	a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用,	a.水井完成井数, a.水井完成费用,	a.转注井完成井数, a.转注井完成费用,	a.水源井完成井数, a.水源井完成费用,
-- 				b.井数 as 计划作业总井数, b.增油 as 计划作业增油, b.作业费用 as 计划作业总费用 
-- 				from
-- 				(select a.日期, a.考核单元, a.躺井数, a.开井数, a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用,	a.水井完成井数, a.水井完成费用,	a.转注井完成井数, a.转注井完成费用,
-- 					b.井数 as 水源井完成井数, b.作业费用 as 水源井完成费用
-- 					from	
-- 					(select	a.日期, a.考核单元, a.躺井数, a.开井数,	a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用, a.维护完成井数, a.维护完成增油, a.维护完成费用,	a.水井完成井数, a.水井完成费用,
-- 						b.井数 as 转注井完成井数, b.作业费用 as 转注井完成费用
-- 						from
-- 						(select	a.日期, a.考核单元, a.躺井数, a.开井数,	a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,	a.措施完成井数, a.措施完成增油, a.措施完成费用,	a.维护完成井数, a.维护完成增油, a.维护完成费用,
-- 							b.井数 as 水井完成井数, b.作业费用 as 水井完成费用
-- 							from
-- 							(select a.日期, a.考核单元, a.躺井数, a.开井数,	a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用, a.水源井计划井数, a.水源井计划费用, a.措施完成井数, a.措施完成增油, a.措施完成费用,
-- 								b.井数 as 维护完成井数, b.增油 as 维护完成增油, b.作业费用 as 维护完成费用
-- 								from
-- 								(select a.日期, a.考核单元, a.躺井数, a.开井数,	a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用,	a.转注井计划井数, a.转注井计划费用,	a.水源井计划井数, a.水源井计划费用,
-- 									b.井数 as 措施完成井数, b.增油 as 措施完成增油, b.作业费用 as 措施完成费用
-- 									from
-- 									(select a.日期, a.考核单元, a.躺井数, a.开井数,	a.措施计划井数, a.措施计划增油, a.措施计划费用,	a.维护计划井数, a.维护计划增油, a.维护计划费用,	a.水井计划井数, a.水井计划费用, a.转注井计划井数, a.转注井计划费用,
-- 										b.井数 as 水源井计划井数, b.作业费用 as 水源井计划费用 
-- 										from
-- 										(select a.日期, a.考核单元, a.躺井数, a.开井数,a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,a.水井计划井数, a.水井计划费用,
-- 											b.井数 as 转注井计划井数, b.作业费用 as 转注井计划费用 
-- 											from
-- 											(select a.日期, a.考核单元, a.躺井数, a.开井数,a.措施计划井数, a.措施计划增油, a.措施计划费用, a.维护计划井数, a.维护计划增油, a.维护计划费用,
-- 												b.井数 as 水井计划井数, b.作业费用 as 水井计划费用 
-- 												from 
-- 												(select a.日期, a.考核单元, a.躺井数, a.开井数,a.措施计划井数, a.措施计划增油, a.措施计划费用,
-- 													b.井数 as 维护计划井数, b.增油 as 维护计划增油, b.作业费用 as 维护计划费用
-- 													from 
-- 													(select a.日期, a.考核单元, a.躺井数, a.开井数,
-- 														b.井数 as 措施计划井数, b.增油 as 措施计划增油, b.作业费用 as 措施计划费用
-- 														from [区块躺井率$] a left join [区块计划措施费用统计$] b 
-- 														on a.考核单元 = b.考核单元 
-- 														and a.日期 = cdate(b.日期)
-- 														where a.考核单元 in {{KHDYJH}}
-- 													) a left join [区块计划维护费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 												) a left join [区块计划水井费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 											) a left join [区块计划转注井费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 										) a left join [区块计划水源井费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 									) a left join [区块实际措施费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 								) a left join [区块实际维护费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 							) a left join [区块实际水井费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 						) a left join [区块实际转注井费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 					) a left join [区块实际水源井费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 				) a left join [区块计划作业费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 			) a left join [区块实际作业费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 		) a left join [区块实际化学驱费用统计$] b on a.考核单元 = b.考核单元 and a.日期 = cdate(b.日期)
-- 	) a 
-- group by a.日期;