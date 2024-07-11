function inverte(strdna:string):string;
var i:integer;
    conc,base,sbase:string;
begin
     for i:= 1 to length(strdna) do
     begin
     base:=copy(strdna,i,1);
     if base='A' then begin sbase:='T' end;
     if base='T' then begin sbase:='A' end;
     if base='C' then begin sbase:='G';end;
     if base='G' then begin sbase:='C';end;
     conc:= conc + sbase;
     end;
result:= conc;
end;
///////                     //seq arquivo, seq digitadas
function busca_complementar(dna_amostra , dna_analise:string):string;
var i ,j,contagem:integer;
     base,seq,sbase,normal,invertida,link:string;
     s:Tstringlist;
     prep,prep_neg:string;
begin
dna_amostra:=stringreplace(dna_amostra,#13,'',[rfreplaceall]);
dna_amostra:=stringreplace(dna_amostra,#10,'',[rfreplaceall]);

dna_amostra:=trim(dna_amostra);
dna_analise:=trim(dna_analise);
s:=Tstringlist.create;
normal:=dna_amostra;
invertida:=inverte(dna_amostra);
contagem:=0;
// prep amostra
for j:= 1 to length(dna_amostra) do
begin
 prep:=prep + '-';
end;
//prepa analise
for j:= 1 to length(dna_analise) do
begin
 prep_neg:=prep_neg + 'X';
end;


if AnsiContainsStr(dna_amostra,dna_analise)=true then
begin
normal:=stringreplace(normal,dna_analise,prep_neg,[RfreplaceAll]);

//lado correto

for i:= 1 to length(normal) do
begin
 if copy(normal,i,1)='X' then
 begin
  link:='|';
 end;
 if copy(normal,i,1)<>'X' then
 begin
  link:=' ';
 end;
 if i=length(dna_amostra) then
 begin
 writeln(copy(dna_amostra,i,1)+' << File Sample ' );
 end;
 if i<length(dna_amostra) then
write(copy(dna_amostra,i,1));

 seq:=seq + link ;
end;
writeln('');
//oposto
for i:= 1 to length(normal) do
begin
 if copy(normal,i,1)='X' then
 begin
 
 end;
 if copy(normal,i,1)<>'X' then
 begin
 
 end;
  if i=length(dna_amostra) then
  begin
writeln(copy(inverte(dna_amostra),i,1)+ ' << Complementary Sequence');
  end;
 if i<length(dna_amostra) then
write(copy(inverte(dna_amostra),i,1));

end;

for i:= 1 to length(dna_amostra) do
begin
 if copy(dna_amostra,i,length(dna_analise)) =dna_analise then
 begin
 inc(contagem);
 end;

end;
//se encontrou

writeln('Found Sequences : '+ inttostr(contagem));

writeln('');
s.Add('REPORT');
s.add('Input Sample Sequence: ' +dna_analise );
s.add('Found Sequences: '+inttostr(contagem));
s.add(dna_amostra + ' << File Sample');
s.add(seq + ' << Link' );
s.add(invertida +  ' << Complementary Sequence');


end;

//se ao encontrou nada
if AnsiContainsStr(dna_amostra,dna_analise)=false then
begin

writeln('Found Sequences: '+ inttostr(contagem));

writeln('');
s.Add('REPORT');
s.add('Input Sample Sequence: ' +dna_analise );
s.add('Found Sequences: '+inttostr(contagem));
s.add(dna_amostra + ' << File Sample');
s.add(seq + ' << Link' );
s.add(invertida +  ' << Complementary Sequence');

end;
result:= s.text;
s.free;
end;