

////Funcoes DNA
function alinhar_reads(seqbase:string):string;
var s,s2:tstringlist;
     n,l,j,contagem:integer;
     str,new,conc,ant,pos:string;
begin
s:=tstringlist.Create;
s2:=tstringlist.Create;

s.Text:=seqbase;
//comprimento
contagem:=0;
for j:= 1 to length(s.Strings[1]) do begin new:=new+copy(s.Strings[1],j,1); end;
 s2.add(new);
 for n:= 1 to length(s.Strings[1]) do
 begin
 ant:=copy(new,1,n-1);
 pos:=copy(new,n+1,(length(new)-length(ant))+1 );
  for l:=1 to s.Count -1 do
  begin
  str:=copy(s.Strings[l],n,1);
    if str='-' then
   begin
   new:=(ant + '-' + pos);
  s2.strings[0]:=new;
   end;

  end;

 end;
  result:=s2.strings[0] ;
  s.free;
  s2.free;
end;
procedure reads_dna(readtext,referencia,outcsv:string);
var t,lista,resultados,formatado:Tstringlist;
      amostra,s,ant,suf,encontrada,formata,saida:string;
      i,n,reads:integer;
begin
t := Tstringlist.create;
formatado:= Tstringlist.create;
resultados := Tstringlist.create;
resultados.add('ID;READ;REFERENCE');
lista := Tstringlist.create;
lista.Delimiter:=char(';');
t.text:=referencia;
lista.DelimitedText:=readtext;
for  reads:=0 to lista.Count-1 do
begin
formata:='';
amostra:=lista.Strings[reads];
//formata saida
for n:=1 to length(amostra) do
 begin
 formata:=formata+'-';
 end;

//processa
 for i:=1 to (length(t.text)-length(amostra)) do
 begin

 s:=copy(t.text,i,length(amostra));
 if (s=amostra) then
 begin
 ant:=copy(t.text,1,i-1);//parte anterior
 suf:=copy(t.text,i+length(amostra),length(t.text)-length(amostra) );//parte do sufixo
 encontrada:=stringreplace(amostra,amostra,formata,[rfreplaceall]);
 resultados.add(inttostr(reads)+';'+amostra+';'+ant + encontrada + copy(suf,1,length(suf)-2) );
 end;


 end;
end;

//Formata saida
lista.Clear;
t.Delimiter:=char(';');
if resultados.Count>1 then //controle
begin
for i:= 1 to resultados.Count-1 do  //0
begin
lista.DelimitedText:=resultados.Strings[i];
t.Add(lista.Strings[2]);
formatado.add(resultados.Strings[i]);
end;
saida:=alinhar_reads(t.text);

formatado.Insert(0,'ID;READ;REFERENCE');
formatado.add('Length:'+inttostr(length(saida))+';=>>;'+ saida );
formatado.SaveToFile(outcsv);
end;
if resultados.Count=1 then
begin
formatado.Insert(0,'ID;READ;REFERENCE');
formatado.add('Length:'+inttostr(length('null'))+';=>>;'+ 'null' );
formatado.SaveToFile(outcsv);
end;
lista.free;
resultados.free;
t.free;
formatado.free;
end;
{
funções ue formata saida do buffer como tabela (apenas no console).Não aconselhável para grandes dados
Autor:Almir Bispo
Data:27/10/2021
Slogan:Yehovah é o Nome do Santo
dependencia:strutils
}
function format_output(strfile:string):string;
var fs,sfile,sgrid:tstringlist;
   j, i:integer;
    fl,linehead,sep,conc,strlist:string;
begin
fl :='|                              ';//32length (se precisar,aumente o comprimento da formatacao)
sep:='+-------------------------------';
sgrid:=tstringlist.create;
sfile:=tstringlist.create;
sfile.text:=strfile;

fs:=tstringlist.create;
fs.Delimiter:=char(';');
for j:= 0 to sfile.Count-1 do
begin
strlist:=sfile.Strings[j];
fs.DelimitedText:=strlist;
for i:= 0 to fs.Count-1 do
begin
fs.Strings[i]:= copy(fl,1, length(fl)-length(fs.strings[i] ) ) + fs.strings[i] ;
conc := conc + sep ;
end;
sgrid.add(fs.DelimitedText + ' |');
sgrid.add(conc + '+');
linehead:=conc + '+';
conc:='';
end;
sgrid.text:=stringreplace(sgrid.text,';',' ',[rfreplaceAll]);
sgrid.text:=stringreplace(sgrid.text,'"','',[rfreplaceAll]);
sgrid.Insert(0,linehead);
linehead:='';
result :=sgrid.text;
fs.free;
sgrid.free;
sfile.free;
end;
