return(function(Check_g,Check_a,Check_a)local Check_j=string.char;local Check_e=string.sub;local Check_o=table.concat;local Check_n=math.ldexp;local Check_m=getfenv or function()return _ENV end;local Check_k=select;local Check_a=unpack or table.unpack;local Check_l=tonumber;local function Check_p(Check_h)local Check_b,Check_c,Check_f="","",{}local Check_g=256;local Check_d={}for Check_a=0,Check_g-1 do Check_d[Check_a]=Check_j(Check_a)end;local Check_a=1;local function Check_i()local Check_b=Check_l(Check_e(Check_h,Check_a,Check_a),36)Check_a=Check_a+1;local Check_c=Check_l(Check_e(Check_h,Check_a,Check_a+Check_b-1),36)Check_a=Check_a+Check_b;return Check_c end;Check_b=Check_j(Check_i())Check_f[1]=Check_b;while Check_a<#Check_h do local Check_a=Check_i()if Check_d[Check_a]then Check_c=Check_d[Check_a]else Check_c=Check_b..Check_e(Check_b,1,1)end;Check_d[Check_g]=Check_b..Check_e(Check_c,1,1)Check_f[#Check_f+1],Check_b,Check_g=Check_c,Check_c,Check_g+1 end;return table.concat(Check_f)end;local Check_h=Check_p('25X25W27525Y25T27525W24K25325125425425W27427627925Y25V27924M24X24L24H25927N27925W1Y1N2111W24527T25W25S27925I25Z27927H25W25I28227425Y27T26127J27G27527827528725U27T26528027528428G28725Y28B28O28E28U28728F27928I28G275');local Check_a=(bit or bit32);local Check_d=Check_a and Check_a.bxor or function(Check_a,Check_c)local Check_b,Check_d,Check_e=1,0,10 while Check_a>0 and Check_c>0 do local Check_f,Check_e=Check_a%2,Check_c%2 if Check_f~=Check_e then Check_d=Check_d+Check_b end Check_a,Check_c,Check_b=(Check_a-Check_f)/2,(Check_c-Check_e)/2,Check_b*2 end if Check_a<Check_c then Check_a=Check_c end while Check_a>0 do local Check_c=Check_a%2 if Check_c>0 then Check_d=Check_d+Check_b end Check_a,Check_b=(Check_a-Check_c)/2,Check_b*2 end return Check_d end local function Check_c(Check_c,Check_a,Check_b)if Check_b then local Check_a=(Check_c/2^(Check_a-1))%2^((Check_b-1)-(Check_a-1)+1);return Check_a-Check_a%1;else local Check_a=2^(Check_a-1);return(Check_c%(Check_a+Check_a)>=Check_a)and 1 or 0;end;end;local Check_a=1;local function Check_b()local Check_e,Check_f,Check_c,Check_b=Check_g(Check_h,Check_a,Check_a+3);Check_e=Check_d(Check_e,212)Check_f=Check_d(Check_f,212)Check_c=Check_d(Check_c,212)Check_b=Check_d(Check_b,212)Check_a=Check_a+4;return(Check_b*16777216)+(Check_c*65536)+(Check_f*256)+Check_e;end;local function Check_i()local Check_b=Check_d(Check_g(Check_h,Check_a,Check_a),212);Check_a=Check_a+1;return Check_b;end;local function Check_f()local Check_b,Check_c=Check_g(Check_h,Check_a,Check_a+2);Check_b=Check_d(Check_b,212)Check_c=Check_d(Check_c,212)Check_a=Check_a+2;return(Check_c*256)+Check_b;end;local function Check_p()local Check_d=Check_b();local Check_a=Check_b();local Check_e=1;local Check_d=(Check_c(Check_a,1,20)*(2^32))+Check_d;local Check_b=Check_c(Check_a,21,31);local Check_a=((-1)^Check_c(Check_a,32));if(Check_b==0)then if(Check_d==0)then return Check_a*0;else Check_b=1;Check_e=0;end;elseif(Check_b==2047)then return(Check_d==0)and(Check_a*(1/0))or(Check_a*(0/0));end;return Check_n(Check_a,Check_b-1023)*(Check_e+(Check_d/(2^52)));end;local Check_l=Check_b;local function Check_q(Check_b)local Check_c;if(not Check_b)then Check_b=Check_l();if(Check_b==0)then return'';end;end;Check_c=Check_e(Check_h,Check_a,Check_a+Check_b-1);Check_a=Check_a+Check_b;local Check_b={}for Check_a=1,#Check_c do Check_b[Check_a]=Check_j(Check_d(Check_g(Check_e(Check_c,Check_a,Check_a)),212))end return Check_o(Check_b);end;local Check_a=Check_b;local function Check_n(...)return{...},Check_k('#',...)end local function Check_l()local Check_j={};local Check_e={};local Check_a={};local Check_h={[#{"1 + 1 = 111";{883;169;162;567};}]=Check_e,[#{{88;366;113;9};{213;781;309;181};{223;969;650;488};}]=nil,[#{{768;937;359;518};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]=Check_a,[#{"1 + 1 = 111";}]=Check_j,};local Check_a=Check_b()local Check_d={}for Check_c=1,Check_a do local Check_b=Check_i();local Check_a;if(Check_b==3)then Check_a=(Check_i()~=0);elseif(Check_b==0)then Check_a=Check_p();elseif(Check_b==2)then Check_a=Check_q();end;Check_d[Check_c]=Check_a;end;Check_h[3]=Check_i();for Check_a=1,Check_b()do Check_e[Check_a-1]=Check_l();end;for Check_h=1,Check_b()do local Check_a=Check_i();if(Check_c(Check_a,1,1)==0)then local Check_e=Check_c(Check_a,2,3);local Check_g=Check_c(Check_a,4,6);local Check_a={Check_f(),Check_f(),nil,nil};if(Check_e==0)then Check_a[3]=Check_f();Check_a[4]=Check_f();elseif(Check_e==1)then Check_a[3]=Check_b();elseif(Check_e==2)then Check_a[3]=Check_b()-(2^16)elseif(Check_e==3)then Check_a[3]=Check_b()-(2^16)Check_a[4]=Check_f();end;if(Check_c(Check_g,1,1)==1)then Check_a[2]=Check_d[Check_a[2]]end if(Check_c(Check_g,2,2)==1)then Check_a[3]=Check_d[Check_a[3]]end if(Check_c(Check_g,3,3)==1)then Check_a[4]=Check_d[Check_a[4]]end Check_j[Check_h]=Check_a;end end;return Check_h;end;local function Check_f(Check_a,Check_b,Check_d)Check_a=(Check_a==true and Check_l())or Check_a;return(function(...)local Check_l=Check_a[1];local Check_c=Check_a[3];local Check_i=Check_a[2];local Check_a=Check_n local Check_e=1;local Check_a=-1;local Check_j={};local Check_g={...};local Check_h=Check_k('#',...)-1;local Check_a={};local Check_b={};for Check_a=0,Check_h do if(Check_a>=Check_c)then Check_j[Check_a-Check_c]=Check_g[Check_a+1];else Check_b[Check_a]=Check_g[Check_a+#{{860;665;595;881};}];end;end;local Check_a=Check_h-Check_c+1 local Check_a;local Check_c;while true do Check_a=Check_l[Check_e];Check_c=Check_a[1];if Check_c<=6 then if Check_c<=2 then if Check_c<=0 then do return Check_b[Check_a[2]]end elseif Check_c>1 then Check_b[Check_a[2]]=Check_a[3];else Check_b[Check_a[2]]=Check_f(Check_i[Check_a[3]],nil,Check_d);end;elseif Check_c<=4 then if Check_c>3 then Check_b[Check_a[2]]=Check_a[3];else Check_b[Check_a[2]]=Check_d[Check_a[3]];end;elseif Check_c>5 then Check_b[Check_a[2]]=Check_f(Check_i[Check_a[3]],nil,Check_d);else do return end;end;elseif Check_c<=9 then if Check_c<=7 then Check_b[Check_a[2]]=Check_d[Check_a[3]];elseif Check_c>8 then Check_b[Check_a[2]]={};else Check_b[Check_a[2]]={};end;elseif Check_c<=11 then if Check_c>10 then do return Check_b[Check_a[2]]end else do return end;end;elseif Check_c==12 then local Check_a=Check_a[2]Check_b[Check_a](Check_b[Check_a+1])else local Check_a=Check_a[2]Check_b[Check_a](Check_b[Check_a+1])end;Check_e=Check_e+1;end;end);end;return Check_f(true,{},Check_m())();end)(string.byte,table.insert,setmetatable);