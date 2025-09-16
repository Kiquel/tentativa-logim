-- Criação da tabela de usuários
create table if not exists users (
  id serial primary key,
  username text not null unique,
  created_at timestamp default current_timestamp
);

-- Trigger para inserir dados
create or replace function insert_user_trigger() 
returns trigger as $$
begin
  -- Aqui podemos adicionar outras validações ou ações no momento do insert
  return new;
end;
$$ language plpgsql;

create trigger insert_user_trigger
before insert on users
for each row execute function insert_user_trigger();
