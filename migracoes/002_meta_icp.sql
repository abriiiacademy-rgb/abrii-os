-- 002 · Painel Meta ICP (ferramentas/meta-icp) · 23/11/2026
-- Aditivo: cria 2 tabelas novas no schema public. Não altera nada existente.
-- Rodar no SQL Editor do Supabase huwlikdosgknyfoykjwn (ABRii memória).

create table if not exists public.meta_icp_retornos (
  conta_id text not null,
  semana smallint not null,           -- 0 = 15-21/11 · 1 = 22-28/11 · 2 = 29/11-05/12 · 3 = 06-12/12 · 4 = 13-15/12
  leads int, perfil int, sem_perfil int, nao_falou int,
  atualizado_em timestamptz not null default now(),
  origem text,
  primary key (conta_id, semana)
);

create table if not exists public.meta_icp_status (
  lead_key text primary key,
  conta_id text not null,
  status text not null check (status in ('a','c','n')),
  atualizado_em timestamptz not null default now()
);

comment on table public.meta_icp_retornos is 'Painel Meta ICP: retorno semanal do cliente sobre leads com perfil (ciclo 15/11-15/12/2026).';
comment on table public.meta_icp_status  is 'Painel Meta ICP: ajuste manual do status de pré-filtro dos leads de formulário.';

alter table public.meta_icp_retornos enable row level security;
alter table public.meta_icp_status  enable row level security;

-- A página é estática (sem login): leitura e escrita pela chave publishable, só nestas 2 tabelas.
create policy meta_icp_ret_select on public.meta_icp_retornos for select to anon, authenticated using (true);
create policy meta_icp_ret_insert on public.meta_icp_retornos for insert to anon, authenticated
  with check (conta_id in ('solar','roberto','victor','priorizze','w2','josiane','inkaza','abrii') and semana between 0 and 4);
create policy meta_icp_ret_update on public.meta_icp_retornos for update to anon, authenticated using (true)
  with check (conta_id in ('solar','roberto','victor','priorizze','w2','josiane','inkaza','abrii') and semana between 0 and 4);
create policy meta_icp_ret_delete on public.meta_icp_retornos for delete to anon, authenticated using (true);

create policy meta_icp_st_select on public.meta_icp_status for select to anon, authenticated using (true);
create policy meta_icp_st_insert on public.meta_icp_status for insert to anon, authenticated with check (status in ('a','c','n'));
create policy meta_icp_st_update on public.meta_icp_status for update to anon, authenticated using (true) with check (status in ('a','c','n'));
create policy meta_icp_st_delete on public.meta_icp_status for delete to anon, authenticated using (true);

grant select, insert, update, delete on public.meta_icp_retornos, public.meta_icp_status to anon, authenticated;
