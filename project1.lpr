program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes ,crt,sysutils,strutils;

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
 textcolor(12);
 link:='|';
 end;
 if copy(normal,i,1)<>'X' then
 begin
 textcolor(15);
 link:=' ';
 end;
 if i=length(dna_amostra) then
 begin
 writeln(copy(dna_amostra,i,1)+' << Amostra do Arquivo ' );
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
 textcolor(12);
 end;
 if copy(normal,i,1)<>'X' then
 begin
 textcolor(15);
 end;
  if i=length(dna_amostra) then
  begin
writeln(copy(inverte(dna_amostra),i,1)+ ' << Sequencia inversa');
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
textcolor(9);
writeln('Total encontradas: '+ inttostr(contagem));
textcolor(15);
writeln('');
s.Add('|||||||||||||||||||||||| Relatorio ||||||||||||||||||||||||||||');
s.add('Sequencia da analise: ' +dna_analise );
s.add('Total de coincidencias encontradas: '+inttostr(contagem));
s.add(dna_amostra + ' << Amostra do Arquivo');
s.add(seq + ' << Relacao' );
s.add(invertida +  ' << Sequencia inversa');
s.add('Hora: '+ timetostr(time) + ' - Data: ' + datetostr(date));

end;

//se ao encontrou nada
if AnsiContainsStr(dna_amostra,dna_analise)=false then
begin
textcolor(9);
writeln('Total encontradas: '+ inttostr(contagem));
textcolor(15);
writeln('');
s.Add('|||||||||||||||||||||||| Relatorio ||||||||||||||||||||||||||||');
s.add('Sequencia da analise: ' +dna_analise );
s.add('Total de coincidencias encontradas: '+inttostr(contagem));
s.add(dna_amostra + ' << Amostra do Arquivo');
s.add(seq + ' << Relacao' );
s.add(invertida +  ' << Sequencia inversa');
s.add('Hora: '+ timetostr(time) + ' - Data: ' + datetostr(date));

end;
result:= s.text;
s.free;
end;
 //////

function transcreve_RNA(DNA_entrada:string):string;
var i:integer;
    rna_transcrito,inverso,base:string;
begin
DNA_entrada:=AnsiUpperCase(trim(DNA_entrada));//torna maiusculas
DNA_entrada:=stringreplace(DNA_entrada,#13,'',[rfreplaceall]);  //retira CR
DNA_entrada:=stringreplace(DNA_entrada,#10,'',[rfreplaceall]);  //retira LF
for i:= 1 to Length(DNA_entrada) do
begin
base := copy(DNA_entrada,i,1);//cada base
if (base='A') then
begin
base:='U';
end;
rna_transcrito:=rna_transcrito + base;

end;

result:=rna_transcrito;
end;



var sfile,newfile,TRNA:Tstringlist;
  cmd,filename,qualseq,novofile,opcaofile:string;
begin
newfile:=Tstringlist.create;
repeat
textbackground(11);
textcolor(10);
writeln('||||||||||||||||||||||||| Comandos ||||||||||||||||||||||||||||');
textbackground(0);
textcolor(10);
writeln('(1) Contagem de Nucleotideo  e   Busca de  ocorrencias         ');
writeln('(2) Transcricao de RNA                (3) Limpar tela          ');
writeln('(4) Salva para Arquivo                (5) Sair                 ');
writeln('Digite comando >>');
readln(cmd);
//comandos 1
     if cmd='1'then
     begin
     textcolor(10);
    writeln('Digite nome do arquivo de texto que deseja abrir >>');
    readln(filename);
    if fileexists(filename) then
    begin
     sfile:=Tstringlist.create;
    sfile.LoadFromFile(filename);
    writeln('Arquivo carregado');
    writeln('Digite a sequencia a ser contada (Uma sequencia apenas) >>');
    readln(qualseq);

    qualseq:=stringreplace(qualseq,#13,'',[rfreplaceAll]);
    qualseq:=stringreplace(qualseq,#10,'',[rfreplaceAll]);

    newfile.text:=busca_complementar(sfile.text,qualseq);
    textbackground(0);
    writeln (newfile.text);
    sfile.free;
    opcaofile:='file';
    end;
    if not fileexists(filename) then
    begin
    writeln('Arquivo inexistente.Certifique se que digitou corretamente.');
    end;

    end;
//2
    if (cmd='2') then
    begin
    textcolor(10);
   writeln('Digite nome do arquivo de texto que deseja abrir >>');
   readln(filename);

    if fileexists(filename) then
    begin
      TRNA:=Tstringlist.create;
     TRNA.LoadFromFile(filename);
      writeln('Arquivo carregado');
     TRNA.text:= transcreve_RNA(TRNA.Text) ; //funcao trasncreve RNA substituindo A por U (Adenina por Uracila)
     textbackground(13);
     writeln (TRNA.text);
     newfile.Text:=TRNA.Text;
     textbackground(0);
     TRNA.free;
     opcaofile:='file';
    end;

    if not fileexists(filename) then
    begin
    writeln('Arquivo inexistente.Certifique se que digitou corretamente.');
    end;

    end;

//   salva arquivos
     if (cmd='4')and(opcaofile<>'file') then
     begin
     textbackground(0);
     writeln('Nenhum arquivo carregado.Opte pela opcoes (1 ou 2) para carregar arquivo');

     end;
     if (cmd='4')and(opcaofile='file') then
     begin
     textbackground(0);
     writeln('Digite nome do Novo Arquivo >>');
     readln(novofile);
     newfile.SaveToFile(novofile);
     writeln('Salvo');
     end;

//3 limpa tela
  if cmd='3'then begin clrscr; end;

until(cmd='5') ;
newfile.free;
end.

