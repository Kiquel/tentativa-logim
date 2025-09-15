create table public.profiles (
  id uuid not null
references auth.users(id) on delete cascade,
  full_name text,
  dob date,
  phone text,
  username text
unique,
  created_at
timestamptz default now(),
 primary key (id)
);

alter
table public.profiles enable row level security;

create policy "Profiles: allow select for owner"
  on public.profiles
  for select
 to authenticated
 using (auth.uid() =
id);


create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into
public.profiles (id, full_name, username, phone, created_at)
  values (
    new.id,
   
(new.raw_user_meta_data ->> 'full_name'),
   
(new.raw_user_meta_data ->> 'username'),
    (new.raw_user_meta_data
->> 'phone'),
    now()
  );
  return new;
end;
$$ language plpgsql security definer;
 
drop trigger if exists auth_user_created on auth.users;
 
create trigger auth_user_created
  after insert on
auth.users
  for each row
 execute procedure
public.handle_new_user();
