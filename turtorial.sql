create EXTENSION uuid-ossp;
create table usuarios
( 
  id uuid primary key not null default uuid_generate_v4(),
  nome text not null,
  email text not null
); 


create table mensagens 
(
  id uuid primary key not null default uuid_generate_v4(),
  usuario_id_remetente uuid not null,
  usuario_id_destinatario uuid not null,
  mensagem text not null
);

CREATE OR REPLACE FUNCTION noticacao_eventos() 
RETURNS TRIGGER AS $$

    DECLARE 
        data json;
        notification json;
        arg TEXT;
    
    BEGIN
    
        -- Convert the old or new row to JSON, based on the kind of action.
        -- Action = DELETE?             -> OLD row
        -- Action = INSERT or UPDATE?   -> NEW row
        IF (TG_OP = 'DELETE') THEN
            data = row_to_json(OLD);
        ELSE
            data = row_to_json(NEW);
        END IF;
        
        -- Contruct the notification as a JSON string.
        notification = json_build_object(
                          'table',TG_TABLE_NAME,
                          'action', TG_OP,
                          'data', data);
        
                        
        -- Execute pg_notify(channel, notification)
        FOREACH arg IN ARRAY TG_ARGV LOOP
        PERFORM pg_notify(arg,notification::text);
        END LOOP;
        -- Result is ignored since this is an AFTER trigger
        RETURN NULL; 
    END;
    
$$ LANGUAGE plpgsql;


CREATE TRIGGER noticacao_eventos_mensagens
AFTER INSERT OR UPDATE OR DELETE ON mensagens
    FOR EACH ROW EXECUTE PROCEDURE noticacao_eventos('mensagens');

insert into usuarios(nome,email) values('fulano','fulano@email.com');
insert into usuarios(nome,email) values('beltrano','beltrano@email.com');

insert into mensagens(usuario_id_remetente,usuario_id_destinatario,mensagem) values(
'7191c71c-b8f7-4247-87d4-6fdad42e5515','5dc3e0d1-b5a9-4cf7-a6ce-a009dc8366e3', 'foo');

insert into mensagens(usuario_id_remetente,usuario_id_destinatario,mensagem) values(
'7191c71c-b8f7-4247-87d4-6fdad42e5515','5dc3e0d1-b5a9-4cf7-a6ce-a009dc8366e3', 'bar');



