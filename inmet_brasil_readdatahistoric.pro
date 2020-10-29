









diretorio='F:\INMET\automaticas_202008\2008\'     
diretorio2='F:\INMET\automaticas_202008idl\'     
NEM = 100
c_arquivo=strarr(NEM)
em=0
c_arquivo(em)='INMET_S_RS_A827_BAGE_01-01-2008_A_31-12-2008'                    


c_regiao=strarr(NEM)     ;& $ ;1
c_uf=strarr(NEM)         ;& $ ;2
c_cidade=strarr(NEM)     ;& $ ;3
c_codigo=strarr(NEM)     ;& $ ;4
c_lat=strarr(NEM)        ;& $ ;5
c_lon=strarr(NEM)        ;& $ ;6
c_alt=strarr(NEM)        ;& $ ;7
c_fundacao=strarr(NEM)   ;& $ ;8
c_cabeca=strarr(NEM)     ;& $ ;9


filein=strcompress(string(diretorio+c_arquivo(em)+'.CSV'),/remove_all) & print, filein ;& $ 

em=0
openr,1,filein 
rows = FILE_LINES(filein) & print, rows ;& $ 
cabeca=' ' & readf,1,cabeca & c_regiao(em)=cabeca & print, c_regiao(em) & readf,1,cabeca & c_uf(em)=cabeca & print,c_uf(em) & readf,1,cabeca & c_cidade(em)=cabeca & print,c_cidade(em) & readf,1,cabeca & c_codigo(em)=cabeca & print,c_codigo(em) & readf,1,cabeca & c_lat(em)=cabeca & print,c_lat(em) & readf,1,cabeca & c_lon(em)=cabeca & print,c_lon(em) & readf,1,cabeca & c_alt(em)=cabeca & print,c_alt(em) & readf,1,cabeca & c_fundacao(em)=cabeca & print,c_fundacao(em) & readf,1,cabeca & c_cabeca(em)=cabeca & print,c_cabeca(em)
line=strarr(rows-9)  & line0=strarr(1)  ;& $ 
for k=0, rows-1-9 do begin & $ 
READF,1,line0 & $
line(k)=line0 & $
endfor  ;& $ 
close,1 ;& $ 

c_regiao(em) = STRJOIN(STRSPLIT(c_regiao(em),'Ã', /EXTRACT), 'A') ;& $
c_uf(em) = STRJOIN(STRSPLIT(c_uf(em),'UF:;', /EXTRACT), '') ;& $
c_cidade(em) = STRJOIN(STRSPLIT(c_cidade(em),'ESTAÇÃO:;', /EXTRACT, /REGEX), '') ;& $
c_fundacao(em) = STRJOIN(STRSPLIT(c_fundacao(em),'ÇÃ', /EXTRACT), 'CA') ;& $
c_cabeca(em) = STRJOIN(STRSPLIT(c_cabeca(em),'ÇÃ', /EXTRACT), 'CA') ;& $
c_cabeca(em) = STRJOIN(STRSPLIT(c_cabeca(em),'Á', /EXTRACT), 'A') ;& $
c_cabeca(em) = STRJOIN(STRSPLIT(c_cabeca(em),'Â', /EXTRACT), 'A') ;& $

c_codigo(em) = STRJOIN(STRSPLIT(c_codigo(em),'CODIGO (WMO):;A', /EXTRACT), '') ;& $
c_lat(em) = STRJOIN(STRSPLIT(c_lat(em),'LATITUDE:;', /EXTRACT), '') ;& $
c_lat(em) = STRJOIN(STRSPLIT(c_lat(em),',', /EXTRACT), '.') ;& $
c_lon(em) = STRJOIN(STRSPLIT(c_lon(em),'LONGITUDE:;', /EXTRACT), '') ;& $
c_lon(em) = STRJOIN(STRSPLIT(c_lon(em),',', /EXTRACT), '.') ;& $
c_alt(em) = STRJOIN(STRSPLIT(c_alt(em),'ALTITUDE:;', /EXTRACT), '') ;& $
c_alt(em) = STRJOIN(STRSPLIT(c_alt(em),',', /EXTRACT), '.') ;& $


result=line & result2=line & d=0 ;& $
for k=0, rows-1-9 do begin & $ 
if(k eq d) then begin & print,'k=' ,k & d=d+100 & endif & $
result(k) = STRJOIN(STRSPLIT(result(k),',', /EXTRACT), '.') & $
result(k) = STRJOIN(STRSPLIT(result(k),':', /EXTRACT), ',') & $
result(k) = STRJOIN(STRSPLIT(result(k),';', /EXTRACT), ',') & $
result(k) = STRJOIN(STRSPLIT(result(k),'-', /EXTRACT), ',') & $
result(k) = STRJOIN(STRSPLIT(result(k),',9999', /EXTRACT, /REGEX), '-9999.99') & $
;result2(k) = STRMID(result(k), 0, teste-1) & $
endfor 
fileouttxt=strcompress(string(diretorio2+c_arquivo(em)+'.txt'),/remove_all) & print, fileouttxt
openw,1,fileouttxt & d2=0  & $
printf,1,c_regiao(em) & printf,1,c_uf(em) & printf,1,c_cidade(em) & printf,1,c_codigo(em) & printf,1,c_lat(em) & printf,1,c_lon(em) & printf,1,c_alt(em) & printf,1,c_fundacao(em) & printf,1,c_cabeca(em) & $
for k2=0, rows-1-9 do begin & $ 
if(k2 eq d2) then begin & print, 'k2=' ,k2 & d2=d2+100 & endif & $
printf,1,result(k2) & $ 
endfor  
close,1 

d_alt=fltarr(nem) & d_alt(em)=c_alt(em) 
print, d_alt(em), 2*d_alt(em)
d_lon=fltarr(nem) & d_lon(em)=c_lon(em)
d_lat=fltarr(nem) & d_lat(em)=c_lat(em)
d_codigo=intarr(nem) & d_codigo(em)=c_codigo(em)

em=nem
ncol=22
for e=0,0 do begin & $   ;em-1
fileinall=fileouttxt & print, fileinall & $
openr,e+1,fileinall & $                ; abrindo o arquivo e descobrindo o numero de linhas que ele possui
cabecalho1=' '  & $
for c=0,9-1 do begin & $
readf,e+1,cabecalho1 & $               ; le as primeiras linhas 
endfor & $
vec=fltarr(ncol) & $
nn=0  & $             ; number of rows        ; ROTINA PARA DESCUBRIR NUMERO DE LINHAS DO ARQUIVO
while not eof(e+1) do begin & $
readf,e+1,vec & $
nn=UINT(nn+1) & $
endwhile & $
print, nn  , '  8760 , pois esperado  24horas x 365dias 8784 ano bisexto'    & $                  ; IMPRIME N LINHAS
stvar=fltarr(ncol,nn)  & $            ; 
close,e+1 & $
openr,e+1,fileinall  & $               ; lendo novamente o arquivo e salvando nas variaveis para usar depois 
cabecalho1=' '  & $ 
for c=0,9-1 do begin & $
readf,e+1,cabecalho1 & $               ; le as primeiras linhas 
endfor & $
vec=fltarr(ncol)  & $
d=0 & for k=0,nn-1 do begin & $
readf,e+1,vec & $
for co=0, ncol-1 do begin & $
stvar(co,k)=vec(co) & $
if(e eq 0) then stvar0=stvar & $
;if(e eq 1) then stvar1=stvar & $
;if(e eq 2) then stvar2=stvar & $
;if(e eq 3) then stvar3=stvar & $
;if(e eq 4) then stvar4=stvar & $
;if(e eq 5) then stvar5=stvar & $
;if(e eq 6) then stvar6=stvar & $
;if(e eq 7) then stvar7=stvar & $
;if(e eq 8) then stvar8=stvar & $
;if(e eq 9) then stvar9=stvar & $
;if(e eq 10) then stvar10=stvar & $
;if(e eq 11) then stvar11=stvar & $
;if(e eq 12) then stvar12=stvar & $
;if(e eq 13) then stvar13=stvar & $
endfor                         ;close e co k
for e=0,0 do begin & close,e+1  & endfor 

plot, stvar(5,*)
plot, stvar(5,*), yrange=[0,40] 










