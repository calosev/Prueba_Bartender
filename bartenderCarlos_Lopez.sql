CREATE OR REPLACE PROCEDURE BARTENDER (q number, id number, typeOut)
--q corresponde al número de iteraciones
--id corresponde al id de array
--:q number;
type A is table of number(3);
type Aa is table of number(3);
type B is table of number(3);
type P is table of number(3);
t_P P;
t_A A;
t_Aa A;
t_B B;
v_var number;
v_div number := 0;
v_ndiv number := 0;
Respuesta varchar2(1000) := 'Respuesta=';

procedure obtenerArray (v_id number, v_array out A) is
  datos varchar2(60);
  inc number;
  fin number;
  vez number := 0;
begin
  inc := 1;
  v_array := A ();
  for i in (select ta.input_array from arrays ta where ta.id = v_id) loop
    fin := instr(i.input_array,',',-1);
    while inc <= instr(i.input_array,',',-1) loop
      if substr(i.input_array,inc,1) != ',' then
        datos := datos||substr(i.input_array,inc,1);
        --dbms_output.put_line(datos||';');
      else
        v_array.extend;
        vez := vez + 1;
        v_array(vez) := datos;
        datos := '';
        if inc = instr(i.input_array,',',-1) then
          v_array.extend;
          datos := substr(i.input_array,instr(i.input_array,',',-1)+1);
          v_array(vez+1) := datos;
          --dbms_output.put_line(datos||';');
        end if;
      end if;
      inc := inc + 1;
    end loop;
  end loop;
end;

begin
  t_P := P (2,3,5,7,11,13,17,19,23,29);
  t_A := A (2,3,4,5,6,7);
  t_B := B ();
  t_Aa := A ();

  obtenerArray(id,t_A);
 
  for i in 1 .. q loop
    v_ndiv := 0;
    v_var := t_A.count+1;
    --dbms_output.put_line('Itera:'||i);
    for y in t_A.first  .. t_A.last loop
      dbms_output.put_line('type A('||(v_var-y)||'):'||t_A(v_var-y));
      if t_A(v_var-y) mod t_P(i) = 0 then
        --dbms_output.put_line('Dividio type A('||(v_var-y)||'):'||t_A(v_var-y)||' P('||i||'):'||t_P(i));
        t_B.extend;
        v_div := v_div + 1;
        t_B(v_div) := t_A(v_var-y);
        --dbms_output.put_line('type B('||v_div||'):'||t_A(v_var-y));
      else
        t_Aa.extend;
        v_ndiv := v_ndiv + 1;
        t_Aa(v_ndiv) := t_A(v_var-y);
        --dbms_output.put_line('type Aa('||v_ndiv||'):'||t_A(v_var-y));
      end if;
    end loop;
    t_A := t_Aa;
    if i != q then
    t_Aa.delete;
    end if;
  end loop;
  if t_B.count > 0 then
  for x in t_B.first .. t_B.last loop
    if t_B(x) = t_B.last then
      Respuesta := Respuesta||t_B(x)||',';
      if t_Aa.count > 0 then
      for xx in t_Aa.first .. t_Aa.last loop
        if t_Aa(xx) = t_Aa.last then
          Respuesta := Respuesta||t_Aa(xx);
        else
          Respuesta := Respuesta||t_Aa(xx)||',';
        end if;
      end loop;
      end if;
    else
    Respuesta := Respuesta||t_B(x)||',';
    end if;
  end loop;
  else
  for xx in t_Aa.first .. t_Aa.last loop
    if t_Aa(xx) = t_Aa.last then
      Respuesta := Respuesta||t_Aa(xx);
    else
      Respuesta := Respuesta||t_Aa(xx)||',';
    end if;
  end loop;
  end if;
  dbms_output.put_line(respuesta);
end;
/
